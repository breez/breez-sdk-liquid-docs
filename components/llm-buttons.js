(function() {
  'use strict';

  // Convert HTML element to Markdown
  function htmlToMarkdown(element) {
    // Clone the element to avoid modifying the original
    var clone = element.cloneNode(true);

    // Remove hidden tab panels (aria-hidden="true")
    clone.querySelectorAll('section[aria-hidden="true"]').forEach(function(panel) {
      panel.remove();
    });

    // Also remove tab titles (slot="title")
    clone.querySelectorAll('[slot="title"]').forEach(function(title) {
      title.remove();
    });

    var html = clone.innerHTML;
    var markdown = html
      // Code blocks
      .replace(/<pre><code[^>]*>([\s\S]*?)<\/code><\/pre>/gi, function(match, code) {
        return '\n```\n' + decodeHtml(code.trim()) + '\n```\n';
      })
      // Inline code
      .replace(/<code>([^<]+)<\/code>/gi, '`$1`')
      // Bold
      .replace(/<strong>([^<]+)<\/strong>/gi, '**$1**')
      .replace(/<b>([^<]+)<\/b>/gi, '**$1**')
      // Italic
      .replace(/<em>([^<]+)<\/em>/gi, '*$1*')
      .replace(/<i>([^<]+)<\/i>/gi, '*$1*')
      // Links
      .replace(/<a[^>]+href="([^"]+)"[^>]*>([^<]+)<\/a>/gi, '[$2]($1)')
      // Headers
      .replace(/<h1[^>]*>([^<]+)<\/h1>/gi, '# $1\n')
      .replace(/<h2[^>]*>([^<]+)<\/h2>/gi, '## $1\n')
      .replace(/<h3[^>]*>([^<]+)<\/h3>/gi, '### $1\n')
      .replace(/<h4[^>]*>([^<]+)<\/h4>/gi, '#### $1\n')
      // List items
      .replace(/<li>([^<]+)<\/li>/gi, '- $1\n')
      // Paragraphs
      .replace(/<p>([^<]*)<\/p>/gi, '$1\n\n')
      // Line breaks
      .replace(/<br\s*\/?>/gi, '\n')
      // Remove remaining HTML tags
      .replace(/<[^>]+>/g, '')
      // Decode HTML entities
      .replace(/&amp;/g, '&')
      .replace(/&lt;/g, '<')
      .replace(/&gt;/g, '>')
      .replace(/&quot;/g, '"')
      .replace(/&#39;/g, "'")
      // Clean up whitespace
      .replace(/\n{3,}/g, '\n\n')
      .trim();

    return markdown;
  }

  function decodeHtml(html) {
    var txt = document.createElement('textarea');
    txt.innerHTML = html;
    return txt.value;
  }

  // Max characters for content (conservative limit accounting for URL encoding expansion)
  var MAX_CONTENT_LENGTH = 1500;

  // Truncate markdown to fit within URL limits
  function truncateMarkdown(markdown) {
    if (markdown.length <= MAX_CONTENT_LENGTH) {
      return markdown;
    }
    return markdown.substring(0, MAX_CONTENT_LENGTH) + '... [truncated]';
  }

  // Create button element
  function createButton(icon, title, onClick) {
    var button = document.createElement('button');
    button.className = 'llm-button';
    button.title = title;
    button.innerHTML = icon;
    button.addEventListener('click', function(e) {
      e.preventDefault();
      e.stopPropagation();
      onClick(button);
    });
    return button;
  }

  // Create button container for an element
  function createButtonContainer(targetElement) {
    var container = document.createElement('div');
    container.className = 'llm-buttons-container';

    // Claude button
    var claudeBtn = createButton(
      '<svg viewBox="0 0 24 24" fill="currentColor"><path d="M4.709 15.955l4.72-2.647.08-.23-.08-.128H9.2l-.79-.048-2.698-.073-2.339-.097-2.266-.122-.571-.121L0 11.784l.055-.352.48-.321.686.06 1.52.103 2.278.158 1.652.097 2.449.255h.389l.055-.157-.134-.098-.103-.097-2.358-1.596-2.552-1.688-1.336-.972-.724-.491-.364-.462-.158-1.008.656-.722.881.06.225.061.893.686 1.908 1.476 2.491 1.833.365.304.145-.103.019-.073-.164-.274-1.355-2.446-1.446-2.49-.644-1.032-.17-.619a2.97 2.97 0 01-.104-.729L6.283.134 6.696 0l.996.134.42.364.62 1.414 1.002 2.229 1.555 3.03.456.898.243.832.091.255h.158V9.01l.128-1.706.237-2.095.23-2.695.08-.76.376-.91.747-.492.584.28.48.685-.067.444-.286 1.851-.559 2.903-.364 1.942h.212l.243-.242.985-1.306 1.652-2.064.73-.82.85-.904.547-.431h1.033l.76 1.129-.34 1.166-1.064 1.347-.881 1.142-1.264 1.7-.79 1.36.073.11.188-.02 2.856-.606 1.543-.28 1.841-.315.833.388.091.395-.328.807-1.969.486-2.309.462-3.439.813-.042.03.049.061 1.549.146.662.036h1.622l3.02.225.79.522.474.638-.079.485-1.215.62-1.64-.389-3.829-.91-1.312-.329h-.182v.11l1.093 1.068 2.006 1.81 2.509 2.33.127.578-.322.455-.34-.049-2.205-1.657-.851-.747-1.926-1.62h-.128v.17l.444.649 2.345 3.521.122 1.08-.17.353-.608.213-.668-.122-1.374-1.925-1.415-2.167-1.143-1.943-.14.08-.674 7.254-.316.37-.729.28-.607-.461-.322-.747.322-1.476.389-1.924.315-1.53.286-1.9.17-.632-.012-.042-.14.018-1.434 1.967-2.18 2.945-1.726 1.845-.414.164-.717-.37.067-.662.401-.589 2.388-3.036 1.44-1.882.93-1.086-.006-.158h-.055L4.132 18.56l-1.13.146-.487-.456.061-.746.231-.243 1.908-1.312-.006.006z"></path></svg>',
      'Ask Claude',
      function() {
        var markdown = truncateMarkdown(htmlToMarkdown(targetElement));
        var prompt = encodeURIComponent('Please help me understand this:\n\n' + markdown);
        window.open('https://claude.ai/new?q=' + prompt, '_blank');
      }
    );

    // ChatGPT button
    var chatgptBtn = createButton(
      '<svg viewBox="0 0 24 24" fill="currentColor"><path d="M22.2819 9.8211a5.9847 5.9847 0 0 0-.5157-4.9108 6.0462 6.0462 0 0 0-6.5098-2.9A6.0651 6.0651 0 0 0 4.9807 4.1818a5.9847 5.9847 0 0 0-3.9977 2.9 6.0462 6.0462 0 0 0 .7427 7.0966 5.98 5.98 0 0 0 .511 4.9107 6.051 6.051 0 0 0 6.5146 2.9001A5.9847 5.9847 0 0 0 13.2599 24a6.0557 6.0557 0 0 0 5.7718-4.2058 5.9894 5.9894 0 0 0 3.9977-2.9001 6.0557 6.0557 0 0 0-.7475-7.0729zm-9.022 12.6081a4.4755 4.4755 0 0 1-2.8764-1.0408l.1419-.0804 4.7783-2.7582a.7948.7948 0 0 0 .3927-.6813v-6.7369l2.02 1.1686a.071.071 0 0 1 .038.052v5.5826a4.504 4.504 0 0 1-4.4945 4.4944zm-9.6607-4.1254a4.4708 4.4708 0 0 1-.5346-3.0137l.142.0852 4.783 2.7582a.7712.7712 0 0 0 .7806 0l5.8428-3.3685v2.3324a.0804.0804 0 0 1-.0332.0615L9.74 19.9502a4.4992 4.4992 0 0 1-6.1408-1.6464zM2.3408 7.8956a4.485 4.485 0 0 1 2.3655-1.9728V11.6a.7664.7664 0 0 0 .3879.6765l5.8144 3.3543-2.0201 1.1685a.0757.0757 0 0 1-.071 0l-4.8303-2.7865A4.504 4.504 0 0 1 2.3408 7.872zm16.5963 3.8558L13.1038 8.364l2.0201-1.1638a.0757.0757 0 0 1 .071 0l4.8303 2.7913a4.4944 4.4944 0 0 1-.6765 8.1042v-5.6772a.79.79 0 0 0-.4066-.6898zm2.0107-3.0231l-.142-.0852-4.7735-2.7818a.7759.7759 0 0 0-.7854 0L9.409 9.2297V6.8974a.0662.0662 0 0 1 .0284-.0615l4.8303-2.7866a4.4992 4.4992 0 0 1 6.6802 4.66zM8.3065 12.863l-2.02-1.1638a.0804.0804 0 0 1-.038-.0567V6.0742a4.4992 4.4992 0 0 1 7.3757-3.4537l-.142.0805L8.704 5.459a.7948.7948 0 0 0-.3927.6813zm1.0976-2.3654l2.602-1.4998 2.6069 1.4998v2.9994l-2.5974 1.4997-2.6067-1.4997Z"/></svg>',
      'Ask ChatGPT',
      function() {
        var markdown = truncateMarkdown(htmlToMarkdown(targetElement));
        var prompt = encodeURIComponent('Please help me understand this:\n\n' + markdown);
        window.open('https://chat.openai.com/?q=' + prompt, '_blank');
      }
    );

    // Gemini button
    var geminiBtn = createButton(
      '<svg viewBox="0 0 24 24" fill="currentColor"><path d="M12 0L14.59 9.41L24 12L14.59 14.59L12 24L9.41 14.59L0 12L9.41 9.41L12 0Z"/></svg>',
      'Ask Gemini',
      function() {
        var markdown = truncateMarkdown(htmlToMarkdown(targetElement));
        var prompt = encodeURIComponent('Please help me understand this:\n\n' + markdown);
        window.open('https://gemini.google.com/app?q=' + prompt, '_blank');
      }
    );

    // Copy button
    var copyBtn = createButton(
      '<svg viewBox="0 0 24 24" fill="currentColor"><path d="M16 1H4c-1.1 0-2 .9-2 2v14h2V3h12V1zm3 4H8c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h11c1.1 0 2-.9 2-2V7c0-1.1-.9-2-2-2zm0 16H8V7h11v14z"/></svg>',
      'Copy as Markdown',
      function(btn) {
        var markdown = htmlToMarkdown(targetElement);
        navigator.clipboard.writeText(markdown).then(function() {
          btn.classList.add('copied');
          btn.innerHTML = '<svg viewBox="0 0 24 24" fill="currentColor"><path d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41z"/></svg>';
          setTimeout(function() {
            btn.classList.remove('copied');
            btn.innerHTML = '<svg viewBox="0 0 24 24" fill="currentColor"><path d="M16 1H4c-1.1 0-2 .9-2 2v14h2V3h12V1zm3 4H8c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h11c1.1 0 2-.9 2-2V7c0-1.1-.9-2-2-2zm0 16H8V7h11v14z"/></svg>';
          }, 2000);
        });
      }
    );

    container.appendChild(claudeBtn);
    container.appendChild(chatgptBtn);
    container.appendChild(geminiBtn);
    container.appendChild(copyBtn);

    return container;
  }

  // Get heading level (1-6) from tag name
  function getHeadingLevel(tagName) {
    var match = tagName.match(/^H(\d)$/);
    return match ? parseInt(match[1], 10) : 0;
  }

  // Check if a heading is a developer note (should be excluded from creating sections)
  function isDeveloperNote(heading) {
    var id = heading.id || '';
    var text = heading.textContent.toLowerCase();
    return id.indexOf('developer-note') !== -1 ||
           id.indexOf('dev-note') !== -1 ||
           text.indexOf('developer note') !== -1;
  }

  // Group content by sections with hierarchy awareness
  // h1 includes all content until next h1
  // h2 includes all content until next h2 or h1
  // etc.
  function getSections(content) {
    var sections = [];
    var headingTags = ['H1', 'H2', 'H3', 'H4', 'H5', 'H6'];

    // Get all direct children and nested elements
    var walker = document.createTreeWalker(
      content,
      NodeFilter.SHOW_ELEMENT,
      {
        acceptNode: function(node) {
          // Skip navigation elements
          if (node.closest('nav') || node.closest('.nav-wrapper') || node.closest('.menu-bar')) {
            return NodeFilter.FILTER_REJECT;
          }
          // Accept headings
          if (headingTags.indexOf(node.tagName) !== -1) {
            return NodeFilter.FILTER_ACCEPT;
          }
          return NodeFilter.FILTER_SKIP;
        }
      }
    );

    // Find all headings (excluding developer notes)
    var headings = [];
    var node;
    while (node = walker.nextNode()) {
      if (!isDeveloperNote(node)) {
        headings.push(node);
      }
    }

    // Create sections based on heading hierarchy
    headings.forEach(function(heading, index) {
      var level = getHeadingLevel(heading.tagName);

      var section = {
        heading: heading,
        elements: [heading]
      };

      // Find the next heading at same or higher level (lower number)
      var nextSameLevelIndex = -1;
      for (var i = index + 1; i < headings.length; i++) {
        var nextLevel = getHeadingLevel(headings[i].tagName);
        if (nextLevel <= level) {
          nextSameLevelIndex = i;
          break;
        }
      }

      var nextSameLevelHeading = nextSameLevelIndex !== -1 ? headings[nextSameLevelIndex] : null;

      // Collect all siblings until the next same-level heading
      var sibling = heading.nextElementSibling;
      while (sibling) {
        // Stop if we reach the next same-level heading
        if (nextSameLevelHeading && (sibling === nextSameLevelHeading || sibling.contains(nextSameLevelHeading))) {
          break;
        }
        section.elements.push(sibling);
        sibling = sibling.nextElementSibling;
      }

      sections.push(section);
    });

    return sections;
  }

  // Track currently hovered section
  var currentHoveredSection = null;

  // Handle mouse enter on section
  function handleSectionMouseEnter(e) {
    var section = e.currentTarget;

    // Remove hover from previous section
    if (currentHoveredSection && currentHoveredSection !== section) {
      currentHoveredSection.classList.remove('llm-hover');
    }

    // Remove hover from all ancestor sections
    var parent = section.parentElement;
    while (parent) {
      if (parent.classList && parent.classList.contains('llm-section-wrapper')) {
        parent.classList.remove('llm-hover');
      }
      parent = parent.parentElement;
    }

    // Add hover to current section
    section.classList.add('llm-hover');
    currentHoveredSection = section;
  }

  // Handle mouse leave on section
  function handleSectionMouseLeave(e) {
    var section = e.currentTarget;
    var relatedTarget = e.relatedTarget;

    // Check if we're moving to a child section
    if (relatedTarget && section.contains(relatedTarget)) {
      return; // Don't remove hover, child will handle it
    }

    // Check if we're moving to a parent section
    var parentSection = section.parentElement;
    while (parentSection) {
      if (parentSection.classList && parentSection.classList.contains('llm-section-wrapper')) {
        if (parentSection.contains(relatedTarget)) {
          // Moving to parent or sibling within parent
          section.classList.remove('llm-hover');
          parentSection.classList.add('llm-hover');
          currentHoveredSection = parentSection;
          return;
        }
      }
      parentSection = parentSection.parentElement;
    }

    // Moving outside all sections
    section.classList.remove('llm-hover');
    currentHoveredSection = null;
  }

  // Wrap section with container that includes buttons
  function wrapSection(section) {
    var heading = section.heading;
    var elements = section.elements;

    // Skip if already wrapped
    if (heading.parentElement && heading.parentElement.classList.contains('llm-section-wrapper')) {
      return;
    }

    // Skip empty sections
    var hasContent = elements.some(function(el) {
      return el.textContent.trim().length > 0;
    });
    if (!hasContent) return;

    // Create wrapper
    var wrapper = document.createElement('div');
    wrapper.className = 'llm-section-wrapper';

    // Create content container to hold all section elements
    var contentDiv = document.createElement('div');
    contentDiv.className = 'llm-section-content';

    // Insert wrapper before the heading
    heading.parentNode.insertBefore(wrapper, heading);

    // Move all section elements into content div
    elements.forEach(function(el) {
      contentDiv.appendChild(el);
    });

    wrapper.appendChild(contentDiv);
    wrapper.appendChild(createButtonContainer(contentDiv));

    // Add hover event listeners
    wrapper.addEventListener('mouseenter', handleSectionMouseEnter);
    wrapper.addEventListener('mouseleave', handleSectionMouseLeave);
  }

  // Initialize LLM buttons on content sections
  function init() {
    var content = document.querySelector('.content main') || document.querySelector('main') || document.querySelector('.content');
    if (!content) return;

    var sections = getSections(content);
    sections.forEach(function(section) {
      wrapSection(section);
    });
  }

  // Run when DOM is ready
  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', init);
  } else {
    init();
  }
})();
