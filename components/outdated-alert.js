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

  // Create and show outdated version alert
  function showOutdatedAlert(latestVersion, latestPath) {
    if (document.getElementById('outdated-version-alert')) {
      return;
    }

    var alert = document.createElement('div');
    alert.id = 'outdated-version-alert';
    alert.className = 'outdated-version-alert';

    var relativePath = getRelativePath();
    var latestUrl = latestPath + relativePath.replace(/^\//, '');

    alert.innerHTML =
      'You are viewing an outdated version of this documentation.' +
      '<a href="' + latestUrl + '">Switch to ' + latestVersion + ' (latest)</a>';

    // Insert at the top of the page content
    var content = document.querySelector('.content') || document.querySelector('main') || document.body;
    if (content.firstChild) {
      content.insertBefore(alert, content.firstChild);
    } else {
      content.appendChild(alert);
    }
  }

  // Check if current version is outdated and show alert
  function checkVersion() {
    var currentVersion = getCurrentVersion();
    if (!currentVersion) {
      return;
    }

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
        var latestVersion = data.latest;
        // Latest version is always at root
        var latestPath = '/';

        if (currentVersion !== latestVersion) {
          showOutdatedAlert(latestVersion, latestPath);
        }
      })
      .catch(function(error) {
        console.warn('Outdated alert: ', error.message);
      });
  }

  // Run when DOM is ready
  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', checkVersion);
  } else {
    checkVersion();
  }
})();
