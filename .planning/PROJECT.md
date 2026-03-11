# Blossom Communities

## What This Is

A Patreon-inspired paid communities feature built as a new tab within the Blossom social investing iOS app. Creators and ambassadors on the Blossom platform can build subscription-based communities where members pay monthly for access to premium investing content, discussion forums, and direct engagement. This is a native SwiftUI prototype that simulates the full experience — subscriber side and creator dashboard — running in Xcode Simulator, designed as an internal demo/pitch to show how Communities would integrate into the existing Blossom app.

## Core Value

Blossom ambassadors and creators can monetize their investing expertise through tiered paid communities, while subscribers get access to premium content and engagement they can't get from the free social feed.

## Requirements

### Validated

(None yet — ship to validate)

### Active

- [ ] Communities tab integrated as a new bottom tab in Blossom's existing 5-tab navigation
- [ ] Community discovery screen with highlighted/featured communities
- [ ] Community cards showing logo, name, creator profile picture (verified badge), brief description
- [ ] Splash/intro screen with centered Blossom logo on white background before entering Communities
- [ ] Individual community preview page with description, value proposition, and tier options
- [ ] Flexible 1-4 tier subscription model per community (creator-defined names, prices, permissions)
- [ ] Tier detail expansion showing benefits, included content, and monthly cost
- [ ] Mocked Stripe payment flow (looks real, no actual Stripe SDK)
- [ ] Confetti celebration animation with Blossom logo on successful subscription
- [ ] Community landing page (mandatory per community): logo, banner, title, short description, link-tree style navigation buttons
- [ ] Content feed within communities (posts, trade highlights, embedded YouTube links)
- [ ] Discussion forums with tier-based access permissions
- [ ] FAQ zone where permitted members can submit questions to the creator/ambassador
- [ ] Creator/ambassador dashboard for setting up communities, tiers, permissions, and content sections
- [ ] Creator earnings view with Blossom platform fee breakdown (10% fee model)
- [ ] YouTube video links that open the YouTube app on tap
- [ ] Tier-based permission system (creator defines which tiers access which content/forums)
- [ ] Full posting interaction in discussion forums (create, reply, like)
- [ ] Real ambassador profiles (BD, Brandon, Max, Nick, Moe, Canadian in a T-shirt) with actual profile photos
- [ ] Local mock data for all communities, tiers, content, and user interactions
- [ ] Content types: trading/investing posts, educational content, video-heavy embeds
- [ ] Brand-compliant UI following Blossom guidelines (Violet #7361F7, Orange #FF7833, Teal #35C7B2, Dark Navy #1E222A, Slate #565E76, Inter font, 8px border radius, card-based layouts)
- [ ] Light and dark mode support matching Blossom's existing system preference detection

### Out of Scope

- Real Stripe SDK integration or actual payment processing — mocked only
- Programmatic ads feature — hinted at conceptually, not built
- Push notifications — prototype is local-only
- Backend API or server — all data is local/hardcoded
- Android build — SwiftUI/iOS only for this prototype
- Integration with real Blossom app codebase — standalone prototype
- Real-time chat or messaging between community members — deliberately excluded (anti-Discord philosophy)
- Web version — iOS native only

## Context

### Existing Blossom App Structure (must match)

The current Blossom iOS app has:
- **5 bottom tabs**: Home, Markets, Learn, Portfolio, Insights
- **Home tab** sub-tabs: "For You", "Following", "News" — card-based social feed with trade posts, stock tags, charts, polls
- **Teal bell icon** (top-right) for notifications, **purple message icon** for DMs
- **Profile** via top-left avatar — percentage-based portfolio sharing (never dollar amounts)
- **Card-based design** throughout: white cards, subtle borders (#E2E4E9), 12px radius, light shadows
- **Pie charts** for portfolio allocation, sector breakdowns, data visualizations
- **Light/dark mode** with system preference detection
- **Inter font** for all UI, clean/modern aesthetic
- **4.8-star rating**, 500K+ users, iOS 16.0+
- **Blossom PRO** premium tier ($8.99/mo or $59.99/yr) for advanced analytics
- **Beevis AI Coach** — recent AI feature addition
- Brokerage connections: Wealthsimple, Questrade, Robinhood, Fidelity, etc.

### Design Philosophy (from Patreon research)

Communities should follow Patreon's proven patterns:
- **Content-first**: Tiers are accessible but not the primary visual element — focus on the value
- **Collections/topics**: Content organized by theme (e.g., "Swing Trade Alerts", "Portfolio Updates")
- **Low-frequency, high-value**: Deliberately NOT Discord-like. Creator posts valuable content at a measured pace. Higher tiers get more access, but the vibe stays professional and curated
- **Creator page**: Header image + profile photo + bio + content tabs — similar structure to Patreon creator pages
- **3-5 tiers recommended**: Patreon data shows too many tiers cause decision fatigue

### Available Assets

- **Profile photos**: BD, Brandon, Max, Nick, Moe, Canadian in a T-shirt — in `profiles-demos/`
- **Blossom logos**: Light mode, dark mode, icon square — in `brand-guidlines/logos/`
- **Brand guidelines**: Full color palette, typography, component patterns — in `brand-guidlines/SKILL.md`

### Project Portability

This project must be self-contained in the GitHub repo so any AI assistant can pick it up:
- `.planning/` contains all context, state, and planning docs
- `docs/` contains setup guides and session handoff files
- Brand assets live in `brand-guidlines/` and `profiles-demos/`
- A `SETUP.md` at root describes how to clone, open in Xcode, and run the simulator
- A `CLAUDE.md` at root provides AI context for any new session

## Constraints

- **Tech stack**: SwiftUI, targeting iOS 26, Swift 6.2 — no UIKit unless absolutely necessary
- **No third-party frameworks**: Use only Apple frameworks unless explicitly approved
- **Platform**: iOS only — Xcode Simulator for demo
- **Data**: All mock data hardcoded locally — no backend, no network calls
- **Brand compliance**: Must use Blossom color palette, Inter font, 8px radius buttons, card patterns exactly as specified
- **Navigation**: Must feel like a natural 6th tab in Blossom's existing tab bar, not a separate app
- **Tone**: Friendly, casual, lowercase display headlines, encouraging — matching Blossom's brand voice
- **Portability**: Repo must be self-contained with setup docs so any developer or AI can run it

## Key Decisions

| Decision | Rationale | Outcome |
|----------|-----------|---------|
| SwiftUI native prototype | Closest to production Blossom integration, iOS-first | — Pending |
| Local mock data only | Fastest path to demo, no backend complexity | — Pending |
| Mocked Stripe payment | Real enough for demo, avoids SDK integration overhead | — Pending |
| Both subscriber + creator views | Full picture for stakeholder pitch, shows both sides of the marketplace | — Pending |
| Full discussion interaction | Makes the demo feel real and interactive, not just static mockups | — Pending |
| Flexible 1-4 tiers | Matches Patreon's model, avoids artificial constraints on creators | — Pending |
| Open YouTube app (not inline) | Simpler implementation, clear UX, avoids video player complexity | — Pending |
| Anti-Discord philosophy | Low-frequency, high-value engagement — core differentiator from chat-heavy platforms | — Pending |
| 10% Blossom platform fee | Revenue model shown in creator dashboard, not subscriber-facing | — Pending |
| Communities as 6th tab | Integrates naturally into existing Blossom nav without disrupting current UX | — Pending |

---
*Last updated: 2026-03-10 after initialization*
