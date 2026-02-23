(function() {
  'use strict';

  // Get current version from URL path (null if at root = latest)
  function getCurrentVersion() {
    var path = window.location.pathname;
    var match = path.match(/^\/([\d]+\.[\d.]+[-\w]*)\//);
    return match ? match[1] : null;
  }

  // Check if we're viewing the root (latest) version
  function isAtRoot() {
    return getCurrentVersion() === null;
  }

  // Get the relative path within the current version
  function getRelativePath() {
    var path = window.location.pathname;
    if (isAtRoot()) {
      // At root, the whole path is the relative path
      return path;
    }
    var match = path.match(/^\/[\d]+\.[\d.]+[-\w]*(\/.*)/);
    return match ? match[1] : '/';
  }

  // Create version switcher element
  function createVersionSwitcher() {
    var container = document.createElement('div');
    container.id = 'version-switcher';
    container.className = 'version-switcher';

    var select = document.createElement('select');
    select.id = 'version-select';
    select.className = 'version-select';
    select.setAttribute('aria-label', 'Select documentation version');

    var loadingOption = document.createElement('option');
    loadingOption.textContent = 'Loading...';
    loadingOption.disabled = true;
    select.appendChild(loadingOption);

    container.appendChild(select);
    return container;
  }

  // Find the right place to insert the version switcher
  function insertVersionSwitcher(switcher) {
    // Try to find the right-side icons in the menu bar
    var rightButtons = document.querySelector('.right-buttons');
    if (rightButtons) {
      rightButtons.insertBefore(switcher, rightButtons.firstChild);
      return true;
    }

    // Fallback: insert in menu bar
    var menuBar = document.querySelector('.menu-bar');
    if (menuBar) {
      menuBar.appendChild(switcher);
      return true;
    }

    return false;
  }

  // Load versions and populate dropdown
  function loadVersions() {
    var select = document.getElementById('version-select');
    if (!select) return;

    var baseUrl = window.location.origin;
    var versionsUrl = baseUrl + '/versions.json';

    fetch(versionsUrl)
      .then(function(response) {
        if (!response.ok) {
          throw new Error('Failed to load versions.json');
        }
        return response.json();
      })
      .then(function(data) {
        var currentVersion = getCurrentVersion();
        var atRoot = isAtRoot();

        // Clear loading option
        select.innerHTML = '';

        // Add version options
        data.versions.forEach(function(version, index) {
          var option = document.createElement('option');
          var isLatest = (index === 0);

          // Latest version is at root, others in subdirectories
          option.value = isLatest ? '/' : '/' + version.version + '/';
          option.textContent = version.version;

          if (isLatest) {
            option.textContent += ' (latest)';
          }

          // Select current version (root = latest)
          if ((atRoot && isLatest) || version.version === currentVersion) {
            option.selected = true;
          }

          select.appendChild(option);
        });

        // Handle version change
        select.addEventListener('change', function() {
          var relativePath = getRelativePath();
          var newBase = select.value;
          // Remove leading slash from relative path when combining
          var newUrl = newBase + relativePath.replace(/^\//, '');
          window.location.href = newUrl;
        });
      })
      .catch(function(error) {
        console.warn('Version switcher: ', error.message);
        var switcher = document.getElementById('version-switcher');
        if (switcher) {
          switcher.style.display = 'none';
        }
      });
  }

  // Initialize version switcher
  function init() {
    var switcher = createVersionSwitcher();
    if (insertVersionSwitcher(switcher)) {
      loadVersions();
    }
  }

  // Run when DOM is ready
  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', init);
  } else {
    init();
  }
})();
