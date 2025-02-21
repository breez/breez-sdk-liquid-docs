// Populate the sidebar
//
// This is a script, and not included directly in the page, to control the total size of the book.
// The TOC contains an entry for each page, so if each page includes a copy of the TOC,
// the total size of the page becomes O(n**2).
class MDBookSidebarScrollbox extends HTMLElement {
    constructor() {
        super();
    }
    connectedCallback() {
        this.innerHTML = '<ol class="chapter"><li class="chapter-item expanded affix "><li class="part-title">API Overview</li><li class="chapter-item expanded "><a href="guide/about_breez_sdk_liquid.html"><strong aria-hidden="true">1.</strong> About Breez SDK - Nodeless</a></li><li class="chapter-item expanded "><a href="guide/getting_started.html"><strong aria-hidden="true">2.</strong> Getting started</a></li><li><ol class="section"><li class="chapter-item expanded "><a href="guide/install.html"><strong aria-hidden="true">2.1.</strong> Installing the SDK</a></li><li class="chapter-item expanded "><a href="guide/connecting.html"><strong aria-hidden="true">2.2.</strong> Connecting and disconnecting</a></li><li class="chapter-item expanded "><a href="guide/wallet_state.html"><strong aria-hidden="true">2.3.</strong> Fetching the balance</a></li><li class="chapter-item expanded "><a href="guide/events.html"><strong aria-hidden="true">2.4.</strong> Listening to events</a></li><li class="chapter-item expanded "><a href="guide/logging.html"><strong aria-hidden="true">2.5.</strong> Adding logging</a></li></ol></li><li class="chapter-item expanded "><a href="guide/payments.html"><strong aria-hidden="true">3.</strong> Payment fundamentals</a></li><li><ol class="section"><li class="chapter-item expanded "><a href="guide/parse.html"><strong aria-hidden="true">3.1.</strong> Parsing inputs</a></li><li class="chapter-item expanded "><a href="guide/receive_payment.html"><strong aria-hidden="true">3.2.</strong> Receiving payments</a></li><li class="chapter-item expanded "><a href="guide/send_payment.html"><strong aria-hidden="true">3.3.</strong> Sending payments</a></li><li class="chapter-item expanded "><a href="guide/list_payments.html"><strong aria-hidden="true">3.4.</strong> Listing payments</a></li><li class="chapter-item expanded "><a href="guide/refund_payment.html"><strong aria-hidden="true">3.5.</strong> Refunding payments</a></li><li class="chapter-item expanded "><a href="guide/rescanning_swaps.html"><strong aria-hidden="true">3.6.</strong> Rescanning swaps</a></li></ol></li><li class="chapter-item expanded "><a href="guide/pay_onchain.html"><strong aria-hidden="true">4.</strong> Sending an on-chain transaction</a></li><li class="chapter-item expanded "><a href="guide/lnurl.html"><strong aria-hidden="true">5.</strong> Using LNURL &amp; Lightning addresses</a></li><li><ol class="section"><li class="chapter-item expanded "><a href="guide/lnurl_pay.html"><strong aria-hidden="true">5.1.</strong> Sending payments using LNURL-Pay/Lightning address</a></li><li class="chapter-item expanded "><a href="guide/lnurl_pay_service.html"><strong aria-hidden="true">5.2.</strong> Receiving payments using LNURL-Pay/Lightning address</a></li><li class="chapter-item expanded "><a href="guide/lnurl_withdraw.html"><strong aria-hidden="true">5.3.</strong> Receiving payments using LNURL-Withdraw</a></li><li class="chapter-item expanded "><a href="guide/lnurl_auth.html"><strong aria-hidden="true">5.4.</strong> Authenticating using LNURL-Auth</a></li></ol></li><li class="chapter-item expanded "><a href="guide/fiat_currencies.html"><strong aria-hidden="true">6.</strong> Supporting fiat currencies</a></li><li class="chapter-item expanded "><a href="guide/buy_btc.html"><strong aria-hidden="true">7.</strong> Buying Bitcoin</a></li><li class="chapter-item expanded "><a href="guide/end-user_fees.html"><strong aria-hidden="true">8.</strong> End-user fees</a></li><li class="chapter-item expanded "><a href="guide/self_signer.html"><strong aria-hidden="true">9.</strong> Connecting an external signer</a></li><li class="chapter-item expanded "><a href="guide/assets.html"><strong aria-hidden="true">10.</strong> Handling multiple assets</a></li><li class="chapter-item expanded "><a href="guide/production.html"><strong aria-hidden="true">11.</strong> Moving to production</a></li><li class="chapter-item expanded affix "><li class="spacer"></li><li class="chapter-item expanded affix "><li class="part-title">Notifications</li><li class="chapter-item expanded "><a href="notifications/getting_started.html"><strong aria-hidden="true">12.</strong> Implementing mobile notifications</a></li><li class="chapter-item expanded "><a href="notifications/setup_nds.html"><strong aria-hidden="true">13.</strong> Setting up an NDS</a></li><li class="chapter-item expanded "><a href="notifications/using_webhooks.html"><strong aria-hidden="true">14.</strong> Using webhooks</a></li><li class="chapter-item expanded "><a href="notifications/setup_plugin.html"><strong aria-hidden="true">15.</strong> Integrating the plugin</a></li><li><ol class="section"><li class="chapter-item expanded "><a href="notifications/android_setup.html"><strong aria-hidden="true">15.1.</strong> Android</a></li><li><ol class="section"><li class="chapter-item expanded "><a href="notifications/android_service.html"><strong aria-hidden="true">15.1.1.</strong> Setting up the Foreground Service</a></li><li class="chapter-item expanded "><a href="notifications/android_plugin.html"><strong aria-hidden="true">15.1.2.</strong> Adding the Notification Plugin</a></li></ol></li><li class="chapter-item expanded "><a href="notifications/ios_setup.html"><strong aria-hidden="true">15.2.</strong> iOS</a></li><li><ol class="section"><li class="chapter-item expanded "><a href="notifications/ios_service.html"><strong aria-hidden="true">15.2.1.</strong> Setting up the Notification Service Extension</a></li><li class="chapter-item expanded "><a href="notifications/ios_plugin.html"><strong aria-hidden="true">15.2.2.</strong> Adding the Notification Plugin</a></li></ol></li></ol></li><li class="chapter-item expanded "><li class="spacer"></li><li class="chapter-item expanded affix "><li class="part-title">Advanced</li><li class="chapter-item expanded "><a href="notifications/logging.html"><strong aria-hidden="true">16.</strong> Adding logging</a></li><li class="chapter-item expanded "><a href="notifications/changing_strings.html"><strong aria-hidden="true">17.</strong> Changing default strings</a></li><li class="chapter-item expanded "><a href="notifications/custom_messages.html"><strong aria-hidden="true">18.</strong> Customising push messages</a></li><li class="chapter-item expanded "><a href="notifications/custom_notifications.html"><strong aria-hidden="true">19.</strong> Handling custom notifications</a></li></ol>';
        // Set the current, active page, and reveal it if it's hidden
        let current_page = document.location.href.toString().split("#")[0];
        if (current_page.endsWith("/")) {
            current_page += "index.html";
        }
        var links = Array.prototype.slice.call(this.querySelectorAll("a"));
        var l = links.length;
        for (var i = 0; i < l; ++i) {
            var link = links[i];
            var href = link.getAttribute("href");
            if (href && !href.startsWith("#") && !/^(?:[a-z+]+:)?\/\//.test(href)) {
                link.href = path_to_root + href;
            }
            // The "index" page is supposed to alias the first chapter in the book.
            if (link.href === current_page || (i === 0 && path_to_root === "" && current_page.endsWith("/index.html"))) {
                link.classList.add("active");
                var parent = link.parentElement;
                if (parent && parent.classList.contains("chapter-item")) {
                    parent.classList.add("expanded");
                }
                while (parent) {
                    if (parent.tagName === "LI" && parent.previousElementSibling) {
                        if (parent.previousElementSibling.classList.contains("chapter-item")) {
                            parent.previousElementSibling.classList.add("expanded");
                        }
                    }
                    parent = parent.parentElement;
                }
            }
        }
        // Track and set sidebar scroll position
        this.addEventListener('click', function(e) {
            if (e.target.tagName === 'A') {
                sessionStorage.setItem('sidebar-scroll', this.scrollTop);
            }
        }, { passive: true });
        var sidebarScrollTop = sessionStorage.getItem('sidebar-scroll');
        sessionStorage.removeItem('sidebar-scroll');
        if (sidebarScrollTop) {
            // preserve sidebar scroll position when navigating via links within sidebar
            this.scrollTop = sidebarScrollTop;
        } else {
            // scroll sidebar to current active section when navigating via "next/previous chapter" buttons
            var activeSection = document.querySelector('#sidebar .active');
            if (activeSection) {
                activeSection.scrollIntoView({ block: 'center' });
            }
        }
        // Toggle buttons
        var sidebarAnchorToggles = document.querySelectorAll('#sidebar a.toggle');
        function toggleSection(ev) {
            ev.currentTarget.parentElement.classList.toggle('expanded');
        }
        Array.from(sidebarAnchorToggles).forEach(function (el) {
            el.addEventListener('click', toggleSection);
        });
    }
}
window.customElements.define("mdbook-sidebar-scrollbox", MDBookSidebarScrollbox);
