# Requirements: Blossom Communities

**Defined:** 2026-03-10
**Core Value:** Blossom ambassadors and creators can monetize their investing expertise through tiered paid communities, while subscribers get access to premium content and engagement they can't get from the free social feed.

## v1 Requirements

Requirements for initial prototype release. Each maps to roadmap phases.

### Foundation

- [ ] **FOUND-01**: App launches as a SwiftUI project targeting iOS 26 / Swift 6.2 in Xcode Simulator
- [x] **FOUND-02**: Bottom tab bar with 6 tabs matching Blossom's existing navigation pattern (Home, Markets, Learn, Portfolio, Insights, Communities)
- [x] **FOUND-03**: Each tab has independent NavigationStack with value-based routing (no shared NavigationStack wrapping TabView)
- [x] **FOUND-04**: Blossom brand design system implemented as reusable SwiftUI components (colors, fonts, button styles, card modifiers)
- [ ] **FOUND-05**: Inter font registered and verified (Regular 400, Medium 500, Semi-Bold 600 weights)
- [ ] **FOUND-06**: Light and dark mode support with system preference detection and correct color adaptation
- [ ] **FOUND-07**: All @Observable classes marked @MainActor for Swift 6.2 strict concurrency compliance
- [ ] **FOUND-08**: ComponentsKit integrated via SPM as approved third-party dependency
- [x] **FOUND-09**: Mock data layer with sample communities, creators, tiers, posts, and forum content
- [x] **FOUND-10**: Real ambassador profile photos loaded from asset catalog (BD, Brandon, Max, Nick, Moe, Canadian in a T-shirt)
- [x] **FOUND-11**: Blossom logo assets (light mode, dark mode, icon) loaded from asset catalog

### Discovery

- [ ] **DISC-01**: Communities tab splash/intro screen with centered Blossom logo on white background before entering main view
- [ ] **DISC-02**: Community discovery/browse screen with featured communities displayed as scrollable cards
- [ ] **DISC-03**: Community preview cards showing: community logo, community name, creator profile picture (circular), verified badge, brief description, member count
- [ ] **DISC-04**: Tapping a community card navigates to that community's preview page

### Subscription

- [x] **SUBS-01**: Community preview page showing full description, value proposition, and creator bio
- [x] **SUBS-02**: Flexible 1-4 tier display with creator-defined tier names and monthly prices
- [x] **SUBS-03**: Tier detail expansion (tappable tray) showing benefits list, included content types, and monthly cost
- [x] **SUBS-04**: Mocked Stripe payment screen (card number, expiry, CVC fields) presented as a sheet — no real processing
- [x] **SUBS-05**: Payment validation simulation (brief loading state, then success)
- [x] **SUBS-06**: Confetti celebration animation with Blossom logo centered on screen upon successful subscription
- [x] **SUBS-07**: After celebration, user transitions into the subscribed community landing page
- [x] **SUBS-08**: Subscription management: user can upgrade tier, downgrade tier, or cancel subscription in-app

### Community Hub

- [x] **HUB-01**: Community landing page (mandatory per community) with: community logo, banner image, title, short description (1-2 sentences)
- [x] **HUB-02**: Link-tree style navigation on landing page — tappable buttons/trays defined by creator linking to community sections (Discussion, Videos, FAQ, etc.)
- [x] **HUB-03**: Content feed showing creator posts chronologically — supports text, trade highlights, and YouTube video links
- [x] **HUB-04**: Investing-native content types: trade highlight cards with stock ticker tags, portfolio summary posts matching Blossom's Home feed visual patterns
- [x] **HUB-05**: YouTube video links that open the YouTube app on tap (URL deep link, no inline player)
- [ ] **HUB-06**: Tier-gated content access — lower-tier subscribers see locked post previews with an upgrade prompt
- [ ] **HUB-07**: Collections / content organization — named categories (e.g., "Swing Trade Alerts", "Portfolio Updates", "Education") that users can browse by topic
- [x] **HUB-08**: Segmented control or tab switching at top of community for navigating between sections (Posts, Discussions, FAQ, Videos, etc.)

### Engagement

- [ ] **ENGR-01**: Discussion forums with threaded conversations — tier-based access permissions per forum
- [ ] **ENGR-02**: Full post interaction in forums: create new discussion threads, reply to existing threads, like posts
- [ ] **ENGR-03**: Visible tier badges on forum posts showing which tier the poster belongs to
- [ ] **ENGR-04**: FAQ zone where members with permission (defined by creator per tier) can submit questions
- [ ] **ENGR-05**: Creator/ambassador can answer FAQ questions — answered questions become persistent, discoverable entries
- [ ] **ENGR-06**: Forum posts and FAQ entries show creator/ambassador replies with a distinct visual treatment (highlighted, badged)

### Creator Dashboard

- [ ] **CRTR-01**: Creator dashboard accessible via role toggle or separate entry point in the app
- [ ] **CRTR-02**: Community setup: create community with logo, banner, title, description, and link-tree section configuration
- [ ] **CRTR-03**: Tier configuration: create 1-4 tiers with custom names, prices, benefit descriptions, and content/forum access permissions
- [ ] **CRTR-04**: Permission management: define which tiers can access which forums, submit FAQ questions, and view which content collections
- [ ] **CRTR-05**: Content publishing: creator can create posts, assign them to collections, and set tier-gate level
- [ ] **CRTR-06**: Earnings view with SwiftUI Charts: gross earnings, 10% Blossom platform fee deduction, net payout, member count, and revenue trend
- [ ] **CRTR-07**: Verified creator/ambassador badge displayed on creator profiles throughout the app

## v2 Requirements

Deferred to future release. Tracked but not in current roadmap.

### Notifications

- **NOTF-01**: In-app notification badges for new community content
- **NOTF-02**: Push notifications for new posts in subscribed communities
- **NOTF-03**: Notification when creator answers your FAQ question

### Discovery Enhancement

- **DSCV-01**: Category filters on discovery screen (Trading, Education, Crypto, Dividends, etc.)
- **DSCV-02**: Search communities by name or creator
- **DSCV-03**: "Recommended for you" communities based on portfolio/interests

### Platform Integration

- **PLAT-01**: Blossom PRO + Community bundle pricing
- **PLAT-02**: Cross-link community content to Blossom Home feed
- **PLAT-03**: Real Stripe or StoreKit 2 payment processing

### Content Enhancement

- **CONT-01**: Inline video player for YouTube content
- **CONT-02**: Image uploads in forum posts
- **CONT-03**: Poll creation in communities

## Out of Scope

| Feature | Reason |
|---------|--------|
| Real-time group chat | Anti-Discord philosophy — burns out creators, degrades content quality, creates notification fatigue |
| Trade signals / real-time alerts | Securities regulation risk (SEC/FINRA, IIROC) — constitutes investment advice without registration |
| Push notifications | Requires APNs backend — out of scope for local prototype |
| Backend API / server | All data is local mock — no network calls in prototype |
| Android build | SwiftUI/iOS only for this prototype |
| Web version | iOS native first — web deferred to post-PMF validation |
| User-to-user DMs within community | Adds social graph complexity, moderation burden, spam risk in investing contexts |
| Leaderboards / gamification | Toxic in investing contexts — encourages overtrading, conflicts with educational tone |
| Programmatic advertising | Conflicts with premium subscriber experience — Patreon tried it and damaged creator relationships |
| Unlimited tiers (5+) | Patreon data shows 3-4 tiers optimal; 5+ causes decision paralysis |
| In-line video player | Complexity vs. value — YouTube deep link achieves 90% of value at 10% of cost |

## Traceability

Which phases cover which requirements. Updated during roadmap creation.

| Requirement | Phase | Status |
|-------------|-------|--------|
| FOUND-01 | Phase 1 | Pending |
| FOUND-02 | Phase 1 | Complete |
| FOUND-03 | Phase 1 | Complete |
| FOUND-04 | Phase 2 | Complete |
| FOUND-05 | Phase 2 | Pending |
| FOUND-06 | Phase 2 | Pending |
| FOUND-07 | Phase 1 | Pending |
| FOUND-08 | Phase 1 | Pending |
| FOUND-09 | Phase 2 | Complete |
| FOUND-10 | Phase 2 | Complete |
| FOUND-11 | Phase 2 | Complete |
| DISC-01 | Phase 3 | Pending |
| DISC-02 | Phase 3 | Pending |
| DISC-03 | Phase 3 | Pending |
| DISC-04 | Phase 3 | Pending |
| SUBS-01 | Phase 3 | Complete |
| SUBS-02 | Phase 3 | Complete |
| SUBS-03 | Phase 3 | Complete |
| SUBS-04 | Phase 4 | Complete |
| SUBS-05 | Phase 4 | Complete |
| SUBS-06 | Phase 4 | Complete |
| SUBS-07 | Phase 4 | Complete |
| SUBS-08 | Phase 4 | Complete |
| HUB-01 | Phase 5 | Complete |
| HUB-02 | Phase 5 | Complete |
| HUB-03 | Phase 6 | Complete |
| HUB-04 | Phase 6 | Complete |
| HUB-05 | Phase 6 | Complete |
| HUB-06 | Phase 6 | Pending |
| HUB-07 | Phase 6 | Pending |
| HUB-08 | Phase 5 | Complete |
| ENGR-01 | Phase 7 | Pending |
| ENGR-02 | Phase 7 | Pending |
| ENGR-03 | Phase 7 | Pending |
| ENGR-04 | Phase 7 | Pending |
| ENGR-05 | Phase 7 | Pending |
| ENGR-06 | Phase 7 | Pending |
| CRTR-01 | Phase 8 | Pending |
| CRTR-02 | Phase 8 | Pending |
| CRTR-03 | Phase 8 | Pending |
| CRTR-04 | Phase 8 | Pending |
| CRTR-05 | Phase 8 | Pending |
| CRTR-06 | Phase 9 | Pending |
| CRTR-07 | Phase 8 | Pending |

**Coverage:**
- v1 requirements: 44 total
- Mapped to phases: 44
- Unmapped: 0 ✓

---
*Requirements defined: 2026-03-10*
*Last updated: 2026-03-10 after roadmap creation — all 44 v1 requirements mapped*
