#!/usr/bin/env bash
set -euo pipefail

# Build versioned documentation for specified git tags
# Uses content-addressable caching to deduplicate identical files across versions
#
# Usage: ./scripts/build-versioned-docs.sh [OPTIONS] [TAG...]
#
# Options:
#   -o, --output DIR     Output directory (default: ./versioned-book)
#   -f, --force          Force rebuild even if tree hash matches
#   -n, --max-versions N Maximum versions to keep (default: from versioning.json or 5)
#   -h, --help           Show this help message
#
# If no tags are specified, uses smart selection from versioning.json:
#   - Keeps last X minor versions (keepMinorVersions, default: 3)
#   - For each minor except latest: only highest patch
#   - For latest minor: keeps last Y patches (keepLatestPatches, default: 3)
#   Example result: v0.9.5, v0.10.3, v0.11.9, v0.11.10, v0.11.11
#
# Examples:
#   ./scripts/build-versioned-docs.sh                     # Smart selection
#   ./scripts/build-versioned-docs.sh v1.0.0 v0.11.2     # Specific tags
#   ./scripts/build-versioned-docs.sh --force v1.0.0     # Force rebuild
#   ./scripts/build-versioned-docs.sh -o ./dist v1.0.0   # Custom output

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

# Defaults
OUTPUT_DIR="$REPO_ROOT/versioned-book"
FORCE_REBUILD=false
MAX_VERSIONS=""
KEEP_MINOR_VERSIONS=""
KEEP_LATEST_PATCHES=""
CACHE_DIR=""

# Parse arguments
TAGS=()
while [[ $# -gt 0 ]]; do
    case $1 in
        -o|--output)
            OUTPUT_DIR="$2"
            shift 2
            ;;
        -f|--force)
            FORCE_REBUILD=true
            shift
            ;;
        -n|--max-versions)
            MAX_VERSIONS="$2"
            shift 2
            ;;
        -h|--help)
            head -20 "$0" | tail -18
            exit 0
            ;;
        -*)
            echo "Unknown option: $1" >&2
            exit 1
            ;;
        *)
            TAGS+=("$1")
            shift
            ;;
    esac
done

# Load config from versioning.json
load_config() {
    if [ -f "$REPO_ROOT/versioning.json" ]; then
        if [ -z "$MAX_VERSIONS" ]; then
            MAX_VERSIONS=$(jq -r '.maxVersions // 5' "$REPO_ROOT/versioning.json")
        fi
        if [ -z "$KEEP_MINOR_VERSIONS" ]; then
            KEEP_MINOR_VERSIONS=$(jq -r '.keepMinorVersions // 3' "$REPO_ROOT/versioning.json")
        fi
        if [ -z "$KEEP_LATEST_PATCHES" ]; then
            KEEP_LATEST_PATCHES=$(jq -r '.keepLatestPatches // 3' "$REPO_ROOT/versioning.json")
        fi
        TRACKED_PATHS=$(jq -r '.trackedPaths | join(" ")' "$REPO_ROOT/versioning.json")
    else
        MAX_VERSIONS="${MAX_VERSIONS:-5}"
        KEEP_MINOR_VERSIONS="${KEEP_MINOR_VERSIONS:-3}"
        KEEP_LATEST_PATCHES="${KEEP_LATEST_PATCHES:-3}"
        TRACKED_PATHS="src/ snippets/ book.toml styles.css tabs.js theme/"
    fi
    CACHE_DIR="$OUTPUT_DIR/.cache"
}

# Compute tree hash for tracked paths at a specific ref
compute_tree_hash() {
    local ref="$1"
    local hash=""

    for path in $TRACKED_PATHS; do
        if git ls-tree "$ref" -- "$path" &>/dev/null; then
            if git ls-tree "$ref" -- "$path" | head -1 | grep -q "^[0-9]* tree"; then
                # Directory
                path_hash=$(git ls-tree -r "$ref" -- "$path" | sha256sum | cut -d' ' -f1)
            else
                # File
                path_hash=$(git ls-tree "$ref" -- "$path" | awk '{print $3}')
            fi
            hash="${hash}${path_hash}"
        fi
    done

    echo -n "$hash" | sha256sum | cut -d' ' -f1
}

# Load existing versions.json
load_versions_json() {
    if [ -f "$OUTPUT_DIR/versions.json" ]; then
        cat "$OUTPUT_DIR/versions.json"
    else
        echo '{"schemaVersion":1,"latest":"","versions":[]}'
    fi
}

# Get existing tree hash for a version
get_existing_hash() {
    local version="$1"
    local versions_json="$2"
    echo "$versions_json" | jq -r --arg v "$version" '.versions[] | select(.version == $v) | .treeHash // ""'
}

# Check if mdbook is installed
check_dependencies() {
    if ! command -v mdbook &>/dev/null; then
        echo "Error: mdbook is not installed. Install with: cargo install mdbook" >&2
        exit 1
    fi
    if ! command -v jq &>/dev/null; then
        echo "Error: jq is not installed" >&2
        exit 1
    fi
}

# ============================================================================
# Content-Addressable Cache Functions
# ============================================================================

# Compute SHA256 hash of a file
hash_file() {
    local file="$1"
    sha256sum "$file" | cut -d' ' -f1
}

# Get cache path for a hash (uses first 2 chars as subdirectory for performance)
get_cache_path() {
    local hash="$1"
    local prefix="${hash:0:2}"
    echo "$CACHE_DIR/$prefix/$hash"
}

# Add a file to the cache, returns the hash
cache_file() {
    local src_file="$1"
    local hash
    hash=$(hash_file "$src_file")
    local cache_path
    cache_path=$(get_cache_path "$hash")

    if [ ! -f "$cache_path" ]; then
        mkdir -p "$(dirname "$cache_path")"
        cp "$src_file" "$cache_path"
    fi

    echo "$hash"
}

# Create a hardlink from cache to destination
# Falls back to copy if hardlink fails (cross-filesystem)
link_from_cache() {
    local hash="$1"
    local dest_file="$2"
    local cache_path
    cache_path=$(get_cache_path "$hash")

    mkdir -p "$(dirname "$dest_file")"

    # Try hardlink first, fall back to copy
    if ! ln "$cache_path" "$dest_file" 2>/dev/null; then
        cp "$cache_path" "$dest_file"
    fi
}

# Process a built directory into the cache and create version with hardlinks
# Returns manifest of file -> hash mappings
process_build_to_cache() {
    local build_dir="$1"
    local version_dir="$2"
    local manifest_file="$3"

    # Clear existing version directory
    rm -rf "$version_dir"
    mkdir -p "$version_dir"

    # Initialize manifest
    echo "{}" > "$manifest_file"

    local file_count=0
    local cached_count=0
    local new_count=0

    # Process all files
    while IFS= read -r -d '' file; do
        local rel_path="${file#$build_dir/}"
        local hash
        local cache_path

        hash=$(hash_file "$file")
        cache_path=$(get_cache_path "$hash")

        # Check if already in cache
        if [ -f "$cache_path" ]; then
            cached_count=$((cached_count + 1))
        else
            mkdir -p "$(dirname "$cache_path")"
            cp "$file" "$cache_path"
            new_count=$((new_count + 1))
        fi

        # Create hardlink in version directory
        link_from_cache "$hash" "$version_dir/$rel_path"

        # Update manifest
        local tmp_manifest
        tmp_manifest=$(mktemp)
        jq --arg path "$rel_path" --arg hash "$hash" \
            '.[$path] = $hash' "$manifest_file" > "$tmp_manifest"
        mv "$tmp_manifest" "$manifest_file"

        file_count=$((file_count + 1))
    done < <(find "$build_dir" -type f -print0)

    echo "  Processed $file_count files ($new_count new, $cached_count from cache)"
}

# Cleanup orphaned cache entries not referenced by any version
cleanup_cache() {
    echo "Cleaning up orphaned cache entries..."

    # Collect all referenced hashes from manifests
    local referenced_hashes
    referenced_hashes=$(mktemp)

    shopt -s nullglob
    for manifest in "$OUTPUT_DIR"/v*/.manifest.json; do
        if [ -f "$manifest" ]; then
            jq -r '.[]' "$manifest" >> "$referenced_hashes"
        fi
    done
    shopt -u nullglob

    # Sort and deduplicate
    sort -u "$referenced_hashes" -o "$referenced_hashes"

    # Find and remove orphaned cache files
    local removed_count=0
    if [ -d "$CACHE_DIR" ]; then
        while IFS= read -r -d '' cache_file; do
            local hash
            hash=$(basename "$cache_file")
            if ! grep -q "^${hash}$" "$referenced_hashes"; then
                rm -f "$cache_file"
                removed_count=$((removed_count + 1))
            fi
        done < <(find "$CACHE_DIR" -type f -print0)

        # Remove empty subdirectories
        find "$CACHE_DIR" -type d -empty -delete 2>/dev/null || true
    fi

    rm -f "$referenced_hashes"

    if [ $removed_count -gt 0 ]; then
        echo "  Removed $removed_count orphaned cache entries"
    fi
}

# Get cache statistics
print_cache_stats() {
    if [ ! -d "$CACHE_DIR" ]; then
        echo "Cache: empty"
        return
    fi

    local cache_files
    local cache_size
    cache_files=$(find "$CACHE_DIR" -type f | wc -l | tr -d ' ')
    cache_size=$(du -sh "$CACHE_DIR" 2>/dev/null | cut -f1)

    echo "Cache: $cache_files files, $cache_size"
}

# ============================================================================
# Build Functions
# ============================================================================

# Build docs for a specific tag using content-addressable cache
build_version() {
    local tag="$1"
    local version_dir="$OUTPUT_DIR/$tag"
    local manifest_file="$version_dir/.manifest.json"

    echo "Building documentation for $tag..."

    # Create temp directory for checkout
    local temp_dir
    temp_dir=$(mktemp -d)

    # Checkout the tag to temp directory using worktree
    if ! git worktree add --detach "$temp_dir" "$tag" 2>/dev/null; then
        echo "Error: Failed to checkout tag $tag" >&2
        rm -rf "$temp_dir"
        return 1
    fi

    # Build mdbook
    pushd "$temp_dir" > /dev/null

    # Install snippets-processor if it exists
    if [ -d "snippets-processor" ]; then
        cargo install --path ./snippets-processor --quiet 2>/dev/null || true
    fi

    mdbook build
    local build_result=$?

    popd > /dev/null

    # Process build output to cache if successful
    if [ $build_result -eq 0 ]; then
        mkdir -p "$CACHE_DIR"
        process_build_to_cache "$temp_dir/book" "$version_dir" "$manifest_file"
        echo "Built $tag -> $version_dir"
    fi

    # Cleanup worktree
    git worktree remove --force "$temp_dir" 2>/dev/null || true
    rm -rf "$temp_dir"

    return $build_result
}

# Update versions.json
update_versions_json() {
    local versions_json="$1"
    local tag="$2"
    local tree_hash="$3"
    local commit_sha
    commit_sha=$(git rev-parse "$tag")
    local build_date
    build_date=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

    # Remove existing entry for this version
    versions_json=$(echo "$versions_json" | jq --arg v "$tag" \
        '.versions = [.versions[] | select(.version != $v)]')

    # Add new entry
    local new_entry
    new_entry=$(jq -n \
        --arg v "$tag" \
        --arg date "$build_date" \
        --arg sha "$commit_sha" \
        --arg hash "$tree_hash" \
        --arg path "/$tag/" \
        '{version: $v, buildDate: $date, commitSha: $sha, treeHash: $hash, path: $path}')

    versions_json=$(echo "$versions_json" | jq --argjson entry "$new_entry" \
        '.versions = [$entry] + .versions')

    # Sort by semver (descending) and set latest
    versions_json=$(echo "$versions_json" | jq '
        .versions |= (sort_by(
            .version | ltrimstr("v") | split(".") | .[0:3] | map(split("-")[0] | tonumber? // 0)
        ) | reverse)
        | .latest = .versions[0].version')

    # Trim to max versions
    versions_json=$(echo "$versions_json" | jq --argjson max "$MAX_VERSIONS" \
        '.versions = .versions[:$max]')

    echo "$versions_json"
}

# Cleanup old versions
cleanup_old_versions() {
    local keep_versions
    keep_versions=$(jq -r '.versions[].version' "$OUTPUT_DIR/versions.json")

    shopt -s nullglob
    for dir in "$OUTPUT_DIR"/v*/; do
        if [ -d "$dir" ]; then
            local version
            version=$(basename "$dir")
            if ! echo "$keep_versions" | grep -q "^${version}$"; then
                echo "Removing old version: $version"
                rm -rf "$dir"
            fi
        fi
    done
    shopt -u nullglob
}

# Inject version switcher and outdated alert into all versions
inject_version_switcher() {
    echo "Injecting version switcher into all versions..."

    # Paths to component files
    local components_dir="$REPO_ROOT/components"
    local switcher_js="$components_dir/version-switcher.js"
    local switcher_css="$components_dir/version-switcher.css"
    local alert_js="$components_dir/outdated-alert.js"
    local alert_css="$components_dir/outdated-alert.css"

    if [ ! -f "$switcher_js" ]; then
        echo "Warning: version-switcher.js not found at $switcher_js"
        return
    fi

    shopt -s nullglob
    for version_dir in "$OUTPUT_DIR"/v*/; do
        if [ -d "$version_dir" ]; then
            local version
            version=$(basename "$version_dir")

            # Copy version-switcher.js if not present
            if [ ! -f "$version_dir/version-switcher.js" ]; then
                cp "$switcher_js" "$version_dir/"
            fi

            # Copy version-switcher.css if not present
            if [ -f "$switcher_css" ] && [ ! -f "$version_dir/version-switcher.css" ]; then
                cp "$switcher_css" "$version_dir/"
            fi

            # Copy outdated-alert.js if not present
            if [ -f "$alert_js" ] && [ ! -f "$version_dir/outdated-alert.js" ]; then
                cp "$alert_js" "$version_dir/"
            fi

            # Copy outdated-alert.css if not present
            if [ -f "$alert_css" ] && [ ! -f "$version_dir/outdated-alert.css" ]; then
                cp "$alert_css" "$version_dir/"
            fi

            # Inject into all HTML files if not already present
            local injected=false
            for html_file in "$version_dir"/*.html "$version_dir"/**/*.html; do
                if [ -f "$html_file" ] && ! grep -q "version-switcher.js" "$html_file"; then
                    # Insert CSS before </head>
                    sed -i.bak 's|</head>|<link rel="stylesheet" href="/'"$version"'/version-switcher.css"><link rel="stylesheet" href="/'"$version"'/outdated-alert.css"></head>|' "$html_file"
                    # Insert JS before </body>
                    sed -i.bak 's|</body>|<script src="/'"$version"'/version-switcher.js"></script><script src="/'"$version"'/outdated-alert.js"></script></body>|' "$html_file"
                    rm -f "$html_file.bak"
                    injected=true
                fi
            done

            if [ "$injected" = true ]; then
                echo "  Injected version switcher into $version"
            fi
        fi
    done
    shopt -u nullglob
    echo "Version switcher injection complete"
}

# Copy latest version to root and inject components
copy_latest_to_root() {
    local latest
    latest=$(jq -r '.latest' "$OUTPUT_DIR/versions.json")
    local latest_dir="$OUTPUT_DIR/$latest"

    if [ ! -d "$latest_dir" ]; then
        echo "Warning: Latest version directory not found: $latest_dir"
        return
    fi

    echo "Copying latest version ($latest) to root..."

    # Copy all files from latest version to root (excluding the version directory itself)
    shopt -s dotglob nullglob
    for item in "$latest_dir"/*; do
        local basename
        basename=$(basename "$item")
        # Skip manifest file
        if [ "$basename" = ".manifest.json" ]; then
            continue
        fi
        # Remove existing item at root if it exists (but not version directories and not .cache)
        if [ -e "$OUTPUT_DIR/$basename" ] && [[ ! "$basename" =~ ^v[0-9] ]] && [ "$basename" != ".cache" ]; then
            rm -rf "$OUTPUT_DIR/$basename"
        fi
        # Copy to root
        if [ -d "$item" ]; then
            cp -r "$item" "$OUTPUT_DIR/$basename"
        else
            cp "$item" "$OUTPUT_DIR/$basename"
        fi
    done
    shopt -u dotglob nullglob

    # Copy component files to root
    local components_dir="$REPO_ROOT/components"
    cp "$components_dir/version-switcher.js" "$OUTPUT_DIR/" 2>/dev/null || true
    cp "$components_dir/version-switcher.css" "$OUTPUT_DIR/" 2>/dev/null || true
    cp "$components_dir/outdated-alert.js" "$OUTPUT_DIR/" 2>/dev/null || true
    cp "$components_dir/outdated-alert.css" "$OUTPUT_DIR/" 2>/dev/null || true

    # Fix component paths in root HTML files (change /vX.X.X/ paths to /)
    shopt -s nullglob
    for html_file in "$OUTPUT_DIR"/*.html "$OUTPUT_DIR"/guide/*.html "$OUTPUT_DIR"/notifications/*.html; do
        if [ -f "$html_file" ]; then
            # Fix version-specific paths to root paths
            sed -i.bak "s|/$latest/version-switcher|/version-switcher|g" "$html_file"
            sed -i.bak "s|/$latest/outdated-alert|/outdated-alert|g" "$html_file"
            rm -f "$html_file.bak"
        fi
    done
    shopt -u nullglob

    echo "Latest version available at root"
}

# Get top N version tags sorted by semver (descending)
get_top_versions() {
    local n="$1"
    # Get all version tags, sort by semver (descending), take top N
    # Try version sort (-V), fall back to basic reverse sort
    if git tag -l 'v*' | sort -rV >/dev/null 2>&1; then
        git tag -l 'v*' | sort -rV | head -n "$n"
    else
        git tag -l 'v*' | sort -r | head -n "$n"
    fi
}

# Smart version selection:
# - Keep last X minor versions
# - For each minor except latest: keep only highest patch
# - For latest minor: keep last Y patches
# Example with X=3, Y=3: v0.9.5, v0.10.3, v0.11.9, v0.11.10, v0.11.11
get_smart_versions() {
    local keep_minors="$1"
    local keep_patches="$2"

    # Get all version tags sorted by semver descending
    local all_tags
    if git tag -l 'v*' | sort -rV >/dev/null 2>&1; then
        all_tags=$(git tag -l 'v*' | sort -rV)
    else
        all_tags=$(git tag -l 'v*' | sort -r)
    fi

    if [ -z "$all_tags" ]; then
        return
    fi

    # Extract unique minor versions (major.minor)
    local minor_versions
    minor_versions=$(echo "$all_tags" | sed 's/^v//' | cut -d. -f1,2 | sort -t. -k1,1nr -k2,2nr | uniq | head -n "$keep_minors")

    if [ -z "$minor_versions" ]; then
        return
    fi

    # Get the latest minor version
    local latest_minor
    latest_minor=$(echo "$minor_versions" | head -1)

    local selected_tags=""

    # Process each minor version
    while IFS= read -r minor; do
        if [ "$minor" = "$latest_minor" ]; then
            # For latest minor: get last Y patches
            local patches
            patches=$(echo "$all_tags" | grep "^v${minor}\." | head -n "$keep_patches")
            selected_tags="$selected_tags"$'\n'"$patches"
        else
            # For older minors: get only the highest patch
            local highest_patch
            highest_patch=$(echo "$all_tags" | grep "^v${minor}\." | head -1)
            if [ -n "$highest_patch" ]; then
                selected_tags="$selected_tags"$'\n'"$highest_patch"
            fi
        fi
    done <<< "$minor_versions"

    # Output unique tags, sorted by semver descending
    echo "$selected_tags" | grep -v '^$' | sort -rV | uniq
}

# ============================================================================
# Main
# ============================================================================

main() {
    check_dependencies
    load_config

    # If no tags specified, use smart version selection
    if [ ${#TAGS[@]} -eq 0 ]; then
        echo "No tags specified, using smart version selection..."
        echo "  Keep $KEEP_MINOR_VERSIONS minor versions, with $KEEP_LATEST_PATCHES patches of latest minor"
        while IFS= read -r tag; do
            [ -n "$tag" ] && TAGS+=("$tag")
        done < <(get_smart_versions "$KEEP_MINOR_VERSIONS" "$KEEP_LATEST_PATCHES")

        if [ ${#TAGS[@]} -eq 0 ]; then
            echo "No version tags found. Create tags with: git tag -a v1.0.0 -m 'Release v1.0.0'"
            exit 1
        fi

        echo "Selected versions: ${TAGS[*]}"
        echo ""
    fi

    mkdir -p "$OUTPUT_DIR"
    mkdir -p "$CACHE_DIR"

    local versions_json
    versions_json=$(load_versions_json)

    local built_count=0
    local skipped_count=0

    for tag in "${TAGS[@]}"; do
        # Verify tag exists
        if ! git rev-parse "$tag" &>/dev/null; then
            echo "Warning: Tag $tag does not exist, skipping" >&2
            continue
        fi

        # Compute tree hash
        local tree_hash
        tree_hash=$(compute_tree_hash "$tag")

        # Check if rebuild needed
        local existing_hash
        existing_hash=$(get_existing_hash "$tag" "$versions_json")

        if [ "$FORCE_REBUILD" = "true" ]; then
            echo "Force rebuild requested for $tag"
        elif [ -n "$existing_hash" ] && [ "$existing_hash" = "$tree_hash" ]; then
            echo "Skipping $tag (tree hash unchanged: ${tree_hash:0:12}...)"
            skipped_count=$((skipped_count + 1))
            continue
        elif [ -n "$existing_hash" ]; then
            echo "Rebuilding $tag (tree hash changed)"
        fi

        # Build the version
        if build_version "$tag"; then
            versions_json=$(update_versions_json "$versions_json" "$tag" "$tree_hash")
            built_count=$((built_count + 1))
        fi
    done

    # Save versions.json
    echo "$versions_json" | jq '.' > "$OUTPUT_DIR/versions.json"
    echo ""
    echo "Updated versions.json:"
    jq '.' "$OUTPUT_DIR/versions.json"

    # Cleanup old versions
    cleanup_old_versions

    # Cleanup orphaned cache entries
    cleanup_cache

    # Inject version switcher into all versions
    inject_version_switcher

    # Copy latest version to root
    copy_latest_to_root

    echo ""
    print_cache_stats
    echo "Summary: Built $built_count version(s), skipped $skipped_count version(s)"
    echo "Output directory: $OUTPUT_DIR"
}

main "$@"
