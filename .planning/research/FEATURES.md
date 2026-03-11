# Feature Research

**Domain:** Paid subscription community platform — investing/finance creator niche, iOS mobile native
**Researched:** 2026-03-10
**Confidence:** HIGH (Patreon/Circle/Substack/Whop verified via official sources + App Store listings)

---

## Feature Landscape

### Table Stakes (Users Expect These)

Features users assume exist. Missing these = product feels incomplete.

| Feature | Why Expected | Complexity | Notes |
|---------|--------------|------------|-------|
| Creator public page (discovery) | Every community platform (Patreon, Circle, Substack) has a public-facing creator page before subscription | LOW | Logo, banner, bio, tier preview — users won't subscribe blind |
| Tiered subscription model (1–4 tiers) | Patreon/Whop/Circle all use tiers; investing communities charge $5–$225/mo depending on access level | MEDIUM | Patreon data: 3 tiers is the sweet spot; middle tier gets most sign-ups via decoy effect |
| Tier benefits listing | Subscribers need to understand what they get at each tier before paying | LOW | Per-tier bullet list of inclusions; unlock gate must be clear |
| Subscription payment flow | Every paid platform has this — missing it means zero monetization | MEDIUM | Blossom prototype: mocked Stripe; real app would require StoreKit 2 or Stripe |
| Verified creator badge | Subscribers in investing contexts specifically look for credibility signals | LOW | Existing Blossom concept — carry it over into Communities |
| Content feed (posts) | Patreon, Substack, Circle all deliver content chronologically; subscribers expect a feed of updates | MEDIUM | Must support text posts, images, trade highlights, embedded video links |
| Tier-gated content access | Core mechanic of every paid community — some posts are behind higher tiers | MEDIUM | Lower tiers see locked post previews with upgrade prompt; standard paywall pattern |
| Creator earnings / payout view | Every creator-side platform shows earnings: Patreon shows member count, monthly income, projections | MEDIUM | Blossom charges 10% fee — show gross earnings and fee deduction clearly |
| Community discovery / browse screen | Patreon, Circle, Whop all have discovery feeds; users expect to browse communities, not just deep-link | LOW | Featured communities, search, category filter |
| Subscription management (cancel/upgrade) | Users expect to be able to manage their subscription in-app without emailing support | MEDIUM | Upgrade, downgrade, cancel — standard subscription UX requirement |
| Creator profile page (authenticated view) | Once subscribed, users expect a proper landing with all their content organized in one place | MEDIUM | Header banner + avatar + bio + content tabs |
| Discussion/forum section | Patreon, Circle, Whop all have threaded discussions; investing communities rely on Q&A and analysis threads | HIGH | Thread creation, replies, likes — tier-gated access per forum |

### Differentiators (Competitive Advantage)

Features that set Blossom Communities apart from generic Patreon clones or investing Discord servers.

| Feature | Value Proposition | Complexity | Notes |
|---------|-------------------|------------|-------|
| Investing-native content types | Generic platforms (Patreon, Circle) force investing creators to use generic "post" types. Blossom can support trade highlight cards, portfolio summary posts, stock ticker tags — formats that feel native to investing | HIGH | Trade post cards with stock tags + chart embeds match Blossom's existing Home feed patterns; massive UX win |
| FAQ zone (structured Q&A) | Discord investing servers lose Q&A in chat noise. Patreon Q&A is buried in comments. A dedicated FAQ zone where members submit questions and creator answers are persistent and discoverable is genuinely better | MEDIUM | Submitted questions queue for creator; answered questions become persistent FAQ entries; tier-gated submission rights |
| Anti-Discord philosophy (low-frequency, high-value) | Most investing communities fail because they become high-noise chat servers that burn out creators and distract subscribers. Blossom's curated, asynchronous content model is a genuine differentiator — professional, not chaotic | LOW (philosophy) | This is a positioning decision more than a feature; manifests as: no real-time chat, structured content collections, measured posting cadence |
| Existing Blossom profile integration | Real ambassadors (BD, Brandon, Max, etc.) with existing Blossom followers. Subscribers can see their existing investing track record in the same app. No other paid community platform can do this | LOW (integration) | Profile photos + verified badge already exist in Blossom; communities layer monetization on top of established trust |
| Confetti subscription celebration | Small delight moment at subscription confirmation. Patreon does nothing. Substack sends a plain email. Blossom can make joining a community feel like an event | LOW | Confetti + Blossom logo animation; reinforces brand and emotional hook |
| Collections / content organization | Patreon's feed is chronological and unstructured. Blossom Communities can organize content into named collections ("Swing Trade Alerts", "Portfolio Updates", "Education") that users can browse by topic | MEDIUM | Inspired by Patreon's post categorization; investing content benefits from topical organization more than most content types |
| Platform fee transparency (10% model) | Creator-side transparency about the fee structure. Most platforms (Patreon: 8–12%, Whop: 10%, Discord: 10%) bury this. Showing it clearly builds creator trust in Blossom as a platform | LOW | Creator earnings view shows gross → fee → payout; builds trust |
| Splash/intro screen with community identity | Each community has a branded intro screen. Discord and Patreon have none — you just land in a feed. The intro screen sets tone and expectation for the community | LOW | Logo + banner + mission statement + CTA to join |
| Blossom PRO + Community bundle potential | Subscribers who are already Blossom PRO users could get communities as an add-on, or community subscribers could be upsold to PRO for analytics. No competitor has this cross-sell opportunity | MEDIUM | Not in v1 prototype, but a genuine product advantage to highlight |

### Anti-Features (Commonly Requested, Often Problematic)

Features that seem good but create problems. Explicitly do NOT build these.

| Feature | Why Requested | Why Problematic | Alternative |
|---------|---------------|-----------------|-------------|
| Real-time group chat | Investing Discord servers all have it; creators and members know the pattern | Burns out creators, creates pressure to be always-on, degrades content quality, makes the community feel like a chat server not a knowledge resource, drives notification fatigue — exactly what investing Discord communities fail with | FAQ Zone for structured Q&A; discussion forums for threaded async conversations; posts + comments for engagement |
| Unlimited tiers (5+) | Creators want maximum flexibility | Patreon research shows 3-4 tiers is optimal; 5+ causes decision paralysis and reduces conversions; managing many tiers increases creator overhead | Cap at 4 tiers with clear naming guidance; highlight the middle tier as "most popular" |
| Trade signals / real-time alerts | High demand from investing community subscribers | Constitutes investment advice in most jurisdictions (SEC/FINRA in US, IIROC in Canada) unless creator is registered; creates regulatory and legal liability for Blossom | Educational content framing ("what I'm watching"), not signals ("buy this now"); disclaimer system |
| In-line video player | Slicker UX than linking to YouTube | Requires AVPlayer implementation, caching, CDN, significant complexity for a prototype; YouTube linking achieves 90% of value at 10% of cost | Deep-link to YouTube app on tap — cleaner, faster, no complexity |
| Push notifications | Standard mobile app feature | Out of scope for local prototype; would require APNs setup, backend, user preferences management | Show content badges/counts in-app to simulate awareness |
| User-to-user DMs within community | Community members want to connect | Adds social graph complexity, moderation burden, potential for spam/scams in investing contexts, scope explosion | Creator-to-subscriber one-way communication via post comments and FAQ zone |
| Leaderboards / gamification | Engagement mechanics borrowed from consumer apps | Toxic in investing contexts — creates incentive to fake performance, encourages overtrading, conflicts with educational/professional tone | Creator-verified performance posts; transparent percentage returns (not dollar amounts, matching Blossom's existing philosophy) |
| Programmatic advertising | Revenue diversification | Conflicts with premium subscriber experience; Patreon tried it and it damaged creator relationships; subscribers pay specifically to avoid ads | Platform fee (10%) + subscription revenue only |
| Web version alongside iOS | Platform reach | Doubles surface area, SwiftUI-native approach doesn't translate; out of scope for prototype and launch | iOS native first; web deferred to after product-market fit validation |

---

## Feature Dependencies

```
Community Discovery Screen
    └──requires──> Creator Public Page (preview)
                       └──requires──> Tier Structure (what's being sold)
                                          └──requires──> Subscription Payment Flow

Subscription Payment Flow
    └──unlocks──> Community Landing Page (authenticated)
                      └──unlocks──> Content Feed
                                        └──unlocks──> Tier-Gated Posts
                      └──unlocks──> Discussion Forums (tier-gated)
                      └──unlocks──> FAQ Zone (tier-gated submission)

Creator Dashboard
    └──requires──> Tier Structure (creator defines before publishing)
    └──requires──> Subscription Management (to see who's subscribed)
    └──unlocks──> Creator Earnings View
    └──unlocks──> Content Publishing (posts, collections)

Tier-Gated Content
    └──requires──> Tier Structure (permissions defined)
    └──requires──> Subscription Status (to enforce gates)

FAQ Zone
    └──requires──> Discussion Forums (shared infrastructure)
    └──requires──> Tier-Gated Access (submission rights defined by tier)

Collections / Content Organization
    └──enhances──> Content Feed (structured vs chronological)
    └──requires──> Content Publishing (posts must exist to organize)
```

### Dependency Notes

- **Community Discovery requires Creator Public Page:** A subscriber cannot evaluate a community without seeing what they'd get. The public preview page (tiers, benefits, sample content) is the funnel entry point.
- **Subscription Flow unlocks everything else:** All community features are gated behind payment. The payment flow is the critical path blocker for all subscriber-side features.
- **Creator Dashboard requires Tier Structure first:** A creator must define tiers (names, prices, permissions) before they can publish content or earn money. Tier setup is the creator-side critical path.
- **Tier-Gated Content requires both Tier Structure and Subscription Status:** The gate enforcement depends on knowing (a) what tiers unlock what content and (b) what tier a given user is on.
- **FAQ Zone enhances Discussion Forums:** FAQ Zone is essentially a structured view of Q&A within the forum infrastructure. They share the same access control model and can share component architecture.
- **Real-time chat conflicts with Anti-Discord philosophy:** Building any persistent group chat feature, even "lightweight," sets a precedent that will grow. Explicitly excluded at the architecture level, not just feature level.

---

## MVP Definition

### Launch With (v1 — Prototype Demo)

Minimum viable for stakeholder pitch — demonstrates full subscriber and creator journeys end-to-end.

- [x] Community discovery screen with featured communities — establishes the tab as a browseable destination
- [x] Creator public page (logo, banner, bio, tiers, tier benefits) — the conversion page subscribers see before subscribing
- [x] Subscription payment flow (mocked Stripe) — validates the monetization mechanic
- [x] Confetti celebration on subscription — delight moment that makes the demo memorable
- [x] Community landing page (authenticated) — proves the post-subscription experience exists
- [x] Content feed with posts (text, trade highlights, embedded YouTube links) — shows the core value delivery
- [x] Tier-gated content (locked preview + upgrade prompt) — demonstrates the tiered model in action
- [x] Discussion forums with tier-based access (create, reply, like) — shows community engagement
- [x] FAQ zone for subscriber questions — demonstrates the anti-Discord Q&A mechanic
- [x] Creator dashboard (community setup, tiers, permissions, content sections) — shows creator-side of the marketplace
- [x] Creator earnings view with 10% fee breakdown — demonstrates Blossom's revenue model
- [x] Light and dark mode — required for Blossom brand compliance

### Add After Validation (v1.x)

Features to add once the prototype is validated and development begins on the real product.

- [ ] Real payment processing (StoreKit 2 for iOS IAP or Stripe web billing) — triggered when App Store compliance is required; Apple's November 2026 deadline means StoreKit 2 is likely necessary
- [ ] Push notifications for new posts and FAQ answers — triggered when user retention data shows drop-off between sessions
- [ ] Content collections / topic organization — triggered when creators have enough content that chronological feed becomes unwieldy (10+ posts)
- [ ] Subscription management (upgrade, downgrade, cancel in-app) — triggered before public launch; required for App Store approval
- [ ] Blossom PRO cross-sell integration — triggered when community subscriber cohort is large enough to test upsell funnel

### Future Consideration (v2+)

Features to defer until product-market fit is established.

- [ ] Investing-native content types (trade cards with ticker tags, portfolio summary posts) — high value but requires backend schema design; defer until real data model is established
- [ ] Creator analytics (subscriber growth, content performance, earnings trends) — defer until creators are live and asking for it
- [ ] Community search (search posts and FAQ answers within a community) — defer until content volume justifies it
- [ ] Web version of communities — defer until iOS is validated; web introduces separate payment compliance surface area
- [ ] Blossom PRO + Community bundle pricing — defer until both products have standalone traction

---

## Feature Prioritization Matrix

| Feature | User Value | Implementation Cost | Priority |
|---------|------------|---------------------|----------|
| Community discovery screen | HIGH | LOW | P1 |
| Creator public page | HIGH | LOW | P1 |
| Tier structure + benefits | HIGH | MEDIUM | P1 |
| Subscription payment flow (mocked) | HIGH | MEDIUM | P1 |
| Community landing page | HIGH | LOW | P1 |
| Content feed with posts | HIGH | MEDIUM | P1 |
| Tier-gated content | HIGH | MEDIUM | P1 |
| Discussion forums | HIGH | HIGH | P1 |
| FAQ zone | MEDIUM | MEDIUM | P1 |
| Creator dashboard | HIGH | HIGH | P1 |
| Creator earnings view | MEDIUM | MEDIUM | P1 |
| Confetti celebration animation | MEDIUM | LOW | P1 |
| Verified creator badge | MEDIUM | LOW | P1 |
| Light/dark mode | HIGH | LOW | P1 |
| Content collections / organization | MEDIUM | MEDIUM | P2 |
| Subscription management (upgrade/cancel) | HIGH | MEDIUM | P2 |
| Creator analytics dashboard | MEDIUM | HIGH | P2 |
| Real payment processing (StoreKit 2) | HIGH | HIGH | P2 |
| Push notifications | MEDIUM | HIGH | P2 |
| Investing-native post types (ticker tags) | HIGH | HIGH | P3 |
| Community search | MEDIUM | MEDIUM | P3 |
| Blossom PRO + Community bundle | HIGH | HIGH | P3 |
| Web version | LOW | HIGH | P3 |

**Priority key:**
- P1: Must have for launch (in scope for prototype demo)
- P2: Should have, add when possible (post-validation)
- P3: Nice to have, future consideration (v2+)

---

## Competitor Feature Analysis

| Feature | Patreon | Circle | Whop | Discord (investing servers) | Blossom Communities |
|---------|---------|--------|------|----------------------------|---------------------|
| Tiered memberships | Yes (up to unlimited) | Yes | Yes | Via bots (fragile) | Yes (1–4 tiers, creator-defined) |
| Content feed | Yes (chronological) | Yes (Spaces) | Yes | No (chat-only) | Yes (chronological + collections) |
| Creator public page | Yes | Yes | Yes | Server invite link only | Yes (logo, banner, bio, tiers) |
| Discussion forums | Comments only | Yes (Spaces) | Yes (Forums app) | Chat channels (high-freq) | Yes (tier-gated threads) |
| Q&A / FAQ zone | No (buried in comments) | No | No (chat only) | No | YES — genuine differentiator |
| Creator earnings view | Yes | Yes | Yes | Via Stripe dashboard only | Yes (with Blossom 10% fee breakdown) |
| iOS native app | Yes | Yes (branded via Circle Plus) | Yes | Yes | Yes (SwiftUI, native) |
| Investing-native content types | No | No | No | Custom (manual setup) | Planned v2+ |
| Real-time chat | Yes (up to 10 chats) | Yes | Yes | Core feature | Deliberately excluded |
| Payment processing | Stripe + StoreKit | Stripe + StoreKit | Stripe | Discord Nitro / Stripe | Mocked Stripe (prototype) |
| Platform fee | 8–12% | 4–8% | 3–10% | 10% | 10% (shown transparently) |
| Brokerage/portfolio integration | No | No | No | No | Future: Blossom PRO linkage |
| Confetti/delight moments | No | No | No | No | Yes |
| Anti-Discord positioning | No | No | No | N/A | Core philosophy |

---

## Investing-Specific Feature Notes

### What Works in Investing Communities (from Whop/Discord research)

Successful paid investing communities consistently include:
1. **Trade alerts / watchlist posts** — what the creator is watching (educational framing, not signals)
2. **Educational breakdowns** — why a trade was made, post-mortem analysis
3. **Portfolio update posts** — percentage-based performance transparency (never dollar amounts)
4. **AMA / Q&A sessions** — scheduled or async; the FAQ zone is the async version
5. **Video content** — screen recordings of charts, YouTube educational content

Blossom's existing content types (trade posts, stock tags, portfolio allocation charts) align perfectly with #1, #3, and #5.

### Regulatory Caution

Investment communities in Canada (Blossom's home market) and the US face securities law constraints:
- Content framed as **education** ("here's what I'm watching and why") is generally safe
- Content framed as **recommendations** ("buy X now") may constitute investment advice and require registration
- The FAQ zone should have a disclaimer prompt for creators when answering investing questions
- No leaderboards or "top performers" that could imply guaranteed returns

---

## Sources

- [Patreon iOS In-App Purchases FAQ](https://support.patreon.com/hc/en-us/articles/27992151772813-iOS-in-app-purchases-FAQ) — MEDIUM confidence (official Patreon support)
- [Patreon Community Chats feature](https://support.patreon.com/hc/en-us/articles/18855652505357-Building-Community-with-Chats) — HIGH confidence (official Patreon docs)
- [Patreon tier setup guide](https://support.patreon.com/hc/en-us/articles/203913559-How-to-set-up-paid-tiers-and-benefits) — HIGH confidence (official Patreon docs)
- [Patreon creator quick tips for tiers](https://creatorhub.patreon.com/articles/how-to-structure-your-membership-and-price-your-benefits) — MEDIUM confidence (Patreon creator hub)
- [Circle community platform guide 2026](https://linodash.com/circle-community-guide/) — MEDIUM confidence (third-party review, verified against Circle.so)
- [Circle iOS App Store listing](https://apps.apple.com/us/app/circle-communities/id1509651625) — HIGH confidence (App Store)
- [Whop iOS App Store listing](https://apps.apple.com/us/app/whop/id1600181492) — HIGH confidence (App Store)
- [Whop platform overview + trading communities](https://whop.com/blog/top-trading-whops/) — MEDIUM confidence (Whop's own blog)
- [eToro CopyTrader + Popular Investor Program](https://www.etoro.com/copytrader/popular-investor/) — HIGH confidence (official eToro docs)
- [Substack app overview](https://substack.com/app) — HIGH confidence (official Substack)
- [Ko-fi vs Buy Me a Coffee 2026](https://talks.co/p/kofi-vs-buy-me-a-coffee/) — LOW confidence (third-party comparison)
- [Best trading Discord servers 2026](https://whop.com/blog/trading-discord-servers/) — MEDIUM confidence (Whop's own marketplace data)
- [Patreon goes all-in on community features](https://news.patreon.com/articles/patreon-all-in-on-community) — HIGH confidence (official Patreon newsroom)
- [Subscription paywall UX best practices](https://apphud.com/blog/design-high-converting-subscription-app-paywalls) — MEDIUM confidence (industry blog, cross-referenced with multiple sources)
- [Creator tier levels guide 2026](https://influenceflow.io/resources/creator-tier-levels-the-complete-2026-guide-to-building-your-monetization-strategy/) — LOW confidence (third-party, single source)

---

*Feature research for: Blossom Communities — paid subscription community platform, investing niche, iOS native*
*Researched: 2026-03-10*
