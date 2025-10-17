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
        this.innerHTML = '<ol class="chapter"><li class="chapter-item affix "><li class="part-title">API Overview</li><li class="chapter-item "><a href="guide/about_breez_sdk_liquid.html">About Breez SDK - Nodeless</a></li><li class="chapter-item "><a href="guide/getting_started.html">Getting started</a><a class="toggle"><div>❱</div></a></li><li><ol class="section"><li class="chapter-item "><a href="guide/install.html">Installing the SDK</a></li><li class="chapter-item "><a href="guide/connecting.html">Connecting and disconnecting</a></li><li class="chapter-item "><a href="guide/wallet_state.html">Fetching the balance</a></li><li class="chapter-item "><a href="guide/events.html">Listening to events</a></li><li class="chapter-item "><a href="guide/logging.html">Adding logging</a></li><li class="chapter-item "><a href="guide/configuration.html">Custom configuration</a></li></ol></li><li class="chapter-item "><a href="guide/payments.html">Payment fundamentals</a><a class="toggle"><div>❱</div></a></li><li><ol class="section"><li class="chapter-item "><a href="guide/parse.html">Parsing inputs</a></li><li class="chapter-item "><a href="guide/receive_payment.html">Receiving payments</a><a class="toggle"><div>❱</div></a></li><li><ol class="section"><li class="chapter-item "><a href="guide/receiving_payments_offline.html">Receiving payments offline</a></li></ol></li><li class="chapter-item "><a href="guide/send_payment.html">Sending payments</a></li><li class="chapter-item "><a href="guide/list_payments.html">Listing payments</a></li><li class="chapter-item "><a href="guide/refund_payment.html">Refunding payments</a></li><li class="chapter-item "><a href="guide/rescanning_swaps.html">Rescanning swaps</a></li></ol></li><li class="chapter-item "><a href="guide/pay_onchain.html">Sending an on-chain payment</a></li><li class="chapter-item "><a href="guide/lnurl.html">Using LNURL, Lightning and BIP353 addresses</a><a class="toggle"><div>❱</div></a></li><li><ol class="section"><li class="chapter-item "><a href="guide/lnurl_pay.html">Sending payments using LNURL-Pay/Lightning address</a></li><li class="chapter-item "><a href="guide/pay_service.html">Receiving payments using LNURL-Pay, Lightning and BIP353 addresses</a><a class="toggle"><div>❱</div></a></li><li><ol class="section"><li class="chapter-item "><a href="guide/lnurl_pay_service.html">LNURL-Pay and BIP353 registration</a></li><li class="chapter-item "><a href="guide/bip353_pay_service.html">BIP353 registration</a></li></ol></li><li class="chapter-item "><a href="guide/lnurl_withdraw.html">Receiving payments using LNURL-Withdraw</a></li><li class="chapter-item "><a href="guide/lnurl_auth.html">Authenticating using LNURL-Auth</a></li></ol></li><li class="chapter-item "><a href="guide/messages.html">Signing and verifying messages</a></li><li class="chapter-item "><a href="guide/fiat_currencies.html">Supporting fiat currencies</a></li><li class="chapter-item "><a href="guide/buy_btc.html">Buying Bitcoin</a></li><li class="chapter-item "><a href="guide/end-user_fees.html">End-user fees</a><a class="toggle"><div>❱</div></a></li><li><ol class="section"><li class="chapter-item "><a href="guide/base_fees.html">Base fees</a></li><li class="chapter-item "><a href="guide/partner_fees.html">Partner fees</a></li></ol></li><li class="chapter-item "><a href="guide/self_signer.html">Connecting an external signer</a></li><li class="chapter-item "><a href="guide/assets.html">Handling multiple assets</a></li><li class="chapter-item "><a href="guide/production.html">Moving to production</a></li><li class="chapter-item affix "><li class="spacer"></li><li class="chapter-item affix "><li class="part-title">Notifications</li><li class="chapter-item "><a href="notifications/getting_started.html">Implementing mobile notifications</a></li><li class="chapter-item "><a href="notifications/setup_nds.html">Setting up an NDS</a></li><li class="chapter-item "><a href="notifications/using_webhooks.html">Using webhooks</a></li><li class="chapter-item "><a href="notifications/setup_plugin.html">Integrating the plugin</a><a class="toggle"><div>❱</div></a></li><li><ol class="section"><li class="chapter-item "><a href="notifications/android_setup.html">Android</a><a class="toggle"><div>❱</div></a></li><li><ol class="section"><li class="chapter-item "><a href="notifications/android_service.html">Setting up the foreground service</a></li><li class="chapter-item "><a href="notifications/android_plugin.html">Adding the notification plugin</a></li></ol></li><li class="chapter-item "><a href="notifications/ios_setup.html">iOS</a><a class="toggle"><div>❱</div></a></li><li><ol class="section"><li class="chapter-item "><a href="notifications/ios_service.html">Setting up the notification service extension</a></li><li class="chapter-item "><a href="notifications/ios_plugin.html">Adding the notification plugin</a></li><li class="chapter-item "><a href="notifications/ios_connect.html">Configuring the main application</a></li></ol></li></ol></li><li class="chapter-item "><a href="notifications/advanced.html">Advanced</a><a class="toggle"><div>❱</div></a></li><li><ol class="section"><li class="chapter-item "><a href="notifications/logging.html">Adding logging</a></li><li class="chapter-item "><a href="notifications/changing_strings.html">Changing default strings</a></li><li class="chapter-item "><a href="notifications/custom_messages.html">Customising push messages</a></li><li class="chapter-item "><a href="notifications/custom_notifications.html">Handling custom notifications</a></li></ol></li><li class="chapter-item "><li class="spacer"></li><li class="chapter-item affix "><li class="part-title">UX Guidelines</li><li class="chapter-item "><a href="guide/uxguide.html">Overview</a></li><li class="chapter-item "><a href="guide/uxguide_receive.html">Receiving Payments</a></li><li class="chapter-item "><a href="guide/uxguide_send.html">Sending Payments</a></li><li class="chapter-item "><a href="guide/uxguide_display.html">Displaying Payments</a></li><li class="chapter-item "><a href="guide/uxguide_seed.html">Seed &amp; Key Management</a></li></ol>';
        // Set the current, active page, and reveal it if it's hidden
        let current_page = document.location.href.toString().split("#")[0].split("?")[0];
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
