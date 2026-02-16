(function() {
  'use strict';

  // Get current version from URL path
  function getCurrentVersion() {
    var path = window.location.pathname;
    var match = path.match(/^\/(v[\d.]+[-\w]*)\//);
    return match ? match[1] : null;
  }

  // Get the relative path within the current version
  function getRelativePath() {
    var path = window.location.pathname;
    var match = path.match(/^\/v[\d.]+[-\w]*(\/.*)/);
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

    // Determine the base URL for versions.json
    // It should be at the root of the versioned docs
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

        // Clear loading option
        select.innerHTML = '';

        // Add version options
        data.versions.forEach(function(version, index) {
          var option = document.createElement('option');
          option.value = version.path;
          option.textContent = version.version;

          if (index === 0) {
            option.textContent += ' (latest)';
          }

          if (version.version === currentVersion) {
            option.selected = true;
          }

          select.appendChild(option);
        });

        // Handle version change
        select.addEventListener('change', function() {
          var relativePath = getRelativePath();
          var newUrl = select.value + relativePath.replace(/^\//, '');
          window.location.href = newUrl;
        });
      })
      .catch(function(error) {
        console.warn('Version switcher: ', error.message);
        // Hide the switcher if versions.json is not available
        var switcher = document.getElementById('version-switcher');
        if (switcher) {
          switcher.style.display = 'none';
        }
      });
  }

  // Initialize version switcher
  function init() {
    // Only initialize if we're in a versioned path
    var currentVersion = getCurrentVersion();
    if (!currentVersion) {
      return;
    }

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
