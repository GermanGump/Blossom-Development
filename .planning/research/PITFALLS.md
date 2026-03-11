# Pitfalls Research

**Domain:** SwiftUI Patreon-like paid community prototype for iOS social investing app
**Researched:** 2026-03-10
**Confidence:** HIGH (navigation, font, dark mode), MEDIUM (iOS 26 Liquid Glass specifics, tier permission patterns)

---

## Critical Pitfalls

### Pitfall 1: Shared Navigation State Across Tabs

**What goes wrong:**
A single NavigationPath or NavigationStack is shared across all tabs in TabView. When the user navigates deep in the Communities tab (e.g., Community > Tier Detail > Payment), then taps another tab and comes back, the navigation stack resets or bleeds into other tabs. The prototype looks broken during a stakeholder demo.

**Why it happens:**
Developers wrap the entire TabView in a single NavigationStack, or pass a single `@State var path: NavigationPath` down from the root. This is the most natural-looking structure in code but produces cross-contamination between tab navigation stacks.

**How to avoid:**
Each tab must own its own `NavigationStack` with its own independent `NavigationPath`. Define a separate `@State var communitiesPath: NavigationPath` scoped to the Communities tab content, not at the root `ContentView` level. Never place `NavigationStack` outside `TabView` wrapping all tabs.

```swift
TabView {
    NavigationStack(path: $communitiesPath) {
        CommunitiesRootView()
    }
    .tabItem { Label("Communities", systemImage: "person.3") }

    NavigationStack(path: $homePath) {
        HomeRootView()
    }
    .tabItem { Label("Home", systemImage: "house") }
}
```

**Warning signs:**
- Navigation bar title from Communities tab bleeds into Home tab
- Back button appears when switching tabs
- Tapping the Communities tab icon a second time does not pop to root
- Child views from one tab appear when switching to another

**Phase to address:** Phase 1 (Foundation / Navigation Architecture). This must be locked in before any feature screens are built. Retrofitting correct navigation architecture across 15+ screens is painful.

---

### Pitfall 2: iOS 26 Liquid Glass Tab Bar Visual Collisions

**What goes wrong:**
iOS 26 (the project target) introduced Liquid Glass, Apple's most significant design evolution since iOS 7. The default tab bar is now a floating, translucent glass pill — not the traditional full-width bar from iOS 15-17. Content that was designed assuming a standard tab bar will have incorrect safe-area insets, clipped bottom padding, or cards that scroll under the glass bar in visually jarring ways.

**Why it happens:**
Prototypes built on iOS 16/17 mental models assume fixed-height opaque tab bars. iOS 26's tab bar collapses while scrolling (`tabBarMinimizeBehavior`) and is no longer full-width, meaning padding and bottom inset assumptions break.

**How to avoid:**
Use `.safeAreaInset(edge: .bottom)` for bottom content padding instead of hardcoded values. Test scroll views and list content specifically at the bottom to ensure no content is obscured by the glass bar. Explicitly configure `toolbarBackground` and `toolbarColorScheme` to ensure Blossom Violet accent on the tab bar doesn't fight with the glass material. Verify the Communities tab icon renders correctly in the Liquid Glass context.

**Warning signs:**
- Bottom card content clips behind the tab bar during scroll
- Tab bar color looks washed out instead of adopting Blossom brand tones
- Community feed list items have different bottom spacing than other tabs

**Phase to address:** Phase 1 (Foundation). Establish the tab bar container and safe area handling before any scroll views are built.

---

### Pitfall 3: Custom Font Silent Fallback (Inter Never Loads)

**What goes wrong:**
The app runs in the Simulator and uses the system San Francisco font everywhere instead of Inter, because Inter was not properly registered. SwiftUI silently falls back without any error or warning — the font mismatch is invisible in code but visually obvious to anyone who knows Blossom's brand.

**Why it happens:**
Three distinct failure modes cause this:
1. Inter font files are added to the project folder but not added to the Xcode target's Build Phases > Copy Bundle Resources
2. `UIAppFonts` (or `Fonts provided by application`) key is missing from Info.plist
3. The font is referenced by filename ("Inter-Regular.ttf") rather than the PostScript name required by `.custom()` — which is "Inter-Regular", "Inter-SemiBold", etc.

**How to avoid:**
- Immediately after adding Inter to the project, verify registration with a temporary debug print: `for family in UIFont.familyNames { print(family) }`. Inter must appear in the list.
- Add all required weights (Regular 400, Medium 500, SemiBold 600) to Info.plist under `UIAppFonts`.
- Create a `BlossomFont` Swift enum that wraps all `.custom("Inter-Regular", size:)` calls, ensuring one place to fix if the name is wrong.
- Never use `Font.body` or `.headline` directly — always go through the design system wrapper.

**Warning signs:**
- Text looks slightly different from Figma/brand mockups in the Simulator
- Running `UIFont.familyNames` doesn't include "Inter"
- Font weight modifiers (`.bold()`) produce unexpected results

**Phase to address:** Phase 1 (Design System Setup). Inter registration must be verified before any UI screens are built.

---

### Pitfall 4: Brand Drift via Hardcoded Colors

**What goes wrong:**
After building 10+ screens, the codebase contains `Color(hex: "#7361F7")` in 40 places, `Color.purple` used as a stand-in for Violet in 5 places, and slightly wrong hex values (`#7360F7` instead of `#7361F7`) scattered through copy-paste. The prototype fails the brand compliance bar for stakeholder review, and fixing it requires touching every file.

**Why it happens:**
When building quickly, developers write inline colors to move fast. They grab a color, paste a hex, and move on. There is no compile-time enforcement preventing this. The brand has six named colors but no centralized Swift definition that enforces their use.

**How to avoid:**
Create a `BlossomColors` design token file in Phase 1 before any view code:

```swift
extension Color {
    static let blossomViolet = Color(hex: "#7361F7")
    static let blossomOrange = Color(hex: "#FF7833")
    static let blossomTeal = Color(hex: "#35C7B2")
    static let blossomNavy = Color(hex: "#1E222A")
    static let blossomSlate = Color(hex: "#565E76")
    static let blossomCardBorder = Color(hex: "#E2E4E9")
}
```

Additionally, define `Color.xcassets` entries with Light/Dark appearances for each semantic color so the Asset Catalog handles dark mode automatically. Never accept a PR (or AI-generated code block) that uses `Color(hex:)` inline in a view file.

**Warning signs:**
- Multiple `.foregroundColor(Color(hex:...))` calls appearing in view files
- Colors look subtly wrong compared to the Blossom brand reference
- Dark mode inconsistencies in specific screens but not others

**Phase to address:** Phase 1 (Design System). Non-negotiable foundation before building any feature views.

---

### Pitfall 5: Dark Mode Breakage from Hardcoded Background Colors

**What goes wrong:**
Cards and container views that look correct in light mode turn into invisible white-on-white or black-on-navy disasters in dark mode. This happens because `Color.white` was used instead of an adaptive background color, or because the card border `#E2E4E9` has no dark mode counterpart.

**Why it happens:**
Light mode is built first and tested exclusively. Dark mode is assumed to "just work" because SwiftUI has automatic dark mode support — but that only applies to semantic system colors like `.primary` and `Color(.systemBackground)`. Blossom's custom hex colors do not auto-adapt.

**How to avoid:**
Every custom color used for backgrounds, borders, and container surfaces must have both a Light and Dark appearance defined in Assets.xcassets Color Sets. The card spec `#E2E4E9` border needs a dark-mode equivalent (approximately `#2E3340`). Never use `Color.white` for card backgrounds — use `Color(.systemBackground)` or a named adaptive color set.

The Blossom `colorScheme` environment variable detection (as described in PROJECT.md) should be used only for explicit brand moments like the splash screen, not for general surface colors.

**Warning signs:**
- Running the Simulator in dark mode reveals white boxes on white backgrounds
- Card borders disappear in dark mode
- Text becomes unreadable on certain screens when dark mode is activated

**Phase to address:** Phase 1 (Design System), with verification pass in each subsequent phase's QA.

---

### Pitfall 6: Tier Permission Logic Scattered Across Views

**What goes wrong:**
The locked/unlocked state for discussion forum access, content posts, and FAQ zones is computed inline in each view — `if currentUserTier >= .pro { show content } else { show lock }`. This logic gets inconsistently applied: one screen checks correctly, another shows locked content to free-tier users, a third crashes when `currentUserTier` is nil for a user who hasn't subscribed at all.

**Why it happens:**
Permission logic feels simple enough to write inline during rapid development. By the time three different content types (forum, posts, FAQ) each have their own inline checks, the rules have diverged.

**How to avoid:**
Create a single `TierPermissionService` or `CommunityAccessEvaluator` struct in Phase 2 before building any locked content screens. All gating logic flows through one function:

```swift
func canAccess(_ content: ContentType, in community: Community, as user: CommunityMember?) -> Bool
```

Views never compute access themselves — they call this function. The mock data layer defines which tier IDs unlock which content sections, and the evaluator reads that data. This also makes the demo more credible: access rules behave consistently throughout the walkthrough.

**Warning signs:**
- Different content screens show different lock states for the same user
- `if tierLevel >= 2` scattered across multiple view files
- Adding a new tier requires hunting through 10+ view files to update checks

**Phase to address:** Phase 2 (Community Feature Core). Must be established before building tiered content screens.

---

### Pitfall 7: Mock Data Without a Service Layer (Singleton Data Blob)

**What goes wrong:**
All mock communities, tiers, users, posts, and forum threads are dumped into a single `MockData.swift` file as static arrays. Views reach into `MockData.communities[0]` directly. When a second screen needs the same data with a filter applied, it duplicates the access pattern. When the demo needs to show a "subscribed" vs "unsubscribed" state, there is no clean way to simulate it because there is no concept of mutable session state.

**Why it happens:**
Static arrays are the fastest way to bootstrap data in a prototype. The problem is not the data itself — it's that views couple to it directly rather than through a service abstraction.

**How to avoid:**
Wrap all mock data behind a `CommunityService` protocol with a `MockCommunityService` implementation. Views and view models interact only with the protocol:

```swift
protocol CommunityServiceProtocol {
    func getCommunities() -> [Community]
    func getSubscribedCommunities(for user: MockUser) -> [Community]
    func subscribe(to community: Community, tier: Tier, as user: MockUser)
}
```

The `MockCommunityService` holds mutable `@Published` state so the demo shows real subscription flows — tapping "Subscribe" actually changes what the Communities tab shows. This makes the prototype dramatically more convincing for stakeholders.

**Warning signs:**
- `MockData.communities[2].tiers[1]` appearing directly in view files
- No way to demonstrate a before/after subscription state transition
- Changing a mock community name requires hunting through multiple files

**Phase to address:** Phase 1 (Foundation). The service protocol layer must exist before Phase 2 builds feature screens on top of it.

---

### Pitfall 8: Prototype Scope Creep from "Just One More Screen"

**What goes wrong:**
The creator dashboard, which is already a full secondary app, grows to include analytics charts, member management screens, tier editing flows, and a settings panel — none of which are needed for the subscriber-side demo pitch. Each "one more screen" costs hours and introduces new bugs, while the core subscriber journey remains unpolished.

**Why it happens:**
The creator dashboard and subscriber experience are both described in the requirements. Builders interpret completeness as building both sides to equal depth. But the stakeholder pitch centers on the subscriber experience and the revenue model; a shallow creator dashboard showing earnings and a tier list is sufficient.

**How to avoid:**
Explicitly define the demo script before building. The script determines which screens must be pixel-perfect vs. which can be placeholder/stub. Creator dashboard: earnings summary view and community setup overview only — everything else is "coming soon" or behind a disabled button. Lock the scope in `.planning/` with a "demo path" document that lists exactly which screens are walked through in the pitch.

**Warning signs:**
- More than 3 screens built for the creator side before the subscriber flow is complete
- Time spent on charts/analytics for the creator before the payment flow is built
- New screens added that are not on the original requirements list

**Phase to address:** Phase 0 (Planning). Establish the demo script and scope boundary before any code is written.

---

### Pitfall 9: Confetti Animation Blocking the UI or Crashing on Re-trigger

**What goes wrong:**
The subscription success confetti animation runs once correctly. When the user navigates back and resubscribes to a second community (simulating the demo walkthrough twice), the confetti either does not trigger again, runs twice simultaneously, or crashes with an animation state error. On older Simulator hardware configs, 200+ particles cause visible frame drops.

**Why it happens:**
Confetti is triggered by a `@State var showConfetti = true` boolean that is never reset to `false` before the next trigger. Or the animation overlay is not torn down after completion, accumulating instances. Particle counts are set high for visual impact without considering Simulator performance.

**How to avoid:**
Implement confetti as a modal overlay that is presented and dismissed via a coordinator, ensuring full teardown between uses. Use a reset pattern: trigger → animate → auto-dismiss after 3 seconds → reset trigger flag. Cap particle count at 150 for Simulator stability. The Blossom logo overlay during confetti should use a simple `.scaleEffect` entrance animation, not a particle system.

**Warning signs:**
- `showConfetti` never set back to `false` after animation completes
- Memory warnings in Xcode console during confetti sequence
- Confetti animation stops abruptly when triggered a second time

**Phase to address:** Phase 3 (Payment & Subscription Flow). Build the animation clean from the start with proper lifecycle management.

---

### Pitfall 10: Swift 6 Strict Concurrency Compiler Errors in Mock Data Layer

**What goes wrong:**
The project targets Swift 6.2 with strict concurrency enabled by default. Mock data services that look fine in Swift 5 produce waves of concurrency compiler errors: `Sending 'self' risks causing data races`, actor isolation violations on `@Observable` classes, and `nonisolated` function conflicts. Development stalls because the mock data layer was written without concurrency in mind.

**Why it happens:**
Swift 6 strict concurrency is significantly stricter than Swift 5. `@Observable` objects that mutate state from background contexts (even hypothetical ones) produce compile-time errors. Developers unfamiliar with the actor model write `@Observable` classes that touch UI state from non-`@MainActor` contexts.

**How to avoid:**
Mark all view model and mock service classes with `@MainActor` from the start:

```swift
@MainActor
@Observable
final class CommunityViewModel {
    var communities: [Community] = []
}
```

Since this is a prototype with no real networking, all operations are synchronous and `@MainActor` causes no practical issues. Do not mix `async/await` into mock services — return data synchronously to avoid actor isolation complexity entirely. If async patterns are used for realism, use `@MainActor` task annotations consistently.

**Warning signs:**
- Build errors mentioning "Sending risks causing data races"
- `nonisolated` functions accessing mutable state
- Compiler errors increase as more view models are added

**Phase to address:** Phase 1 (Foundation). Establish the `@MainActor` convention in the first view model before any others are built.

---

## Technical Debt Patterns

Shortcuts that seem reasonable but create long-term problems.

| Shortcut | Immediate Benefit | Long-term Cost | When Acceptable |
|----------|-------------------|----------------|-----------------|
| Inline hex color values | Fast development | Brand drift, impossible to audit or update | Never — use design tokens from day one |
| Static `MockData` arrays accessed directly in views | Zero boilerplate | No simulated state changes, demo feels static | Never — use a service protocol layer |
| Single `NavigationStack` wrapping entire `TabView` | Simpler root structure | Cross-tab navigation bleed, broken back button behavior | Never |
| Skipping Info.plist `UIAppFonts` entry for Inter | One less config step | App ships with system font, brand non-compliant | Never |
| Hardcoded `.padding(.bottom, 90)` for tab bar offset | Quick fix for layout | Breaks with iOS 26 Liquid Glass bar height, breaks on iPad | Never — use `.safeAreaInset` |
| Building creator dashboard in depth before subscriber flow | Feels comprehensive | Subscriber UX (the demo focus) remains unpolished | Only after subscriber flow is demo-ready |
| `Color.white` for card backgrounds | Simple, obvious | Invisible cards in dark mode | Never — use `Color(.systemBackground)` or adaptive color sets |
| `if tierLevel >= 2` inline in views | Fast to write | Scattered permission logic, inconsistent enforcement | Never — centralize in a permission evaluator |

---

## Integration Gotchas

Common mistakes when connecting to external services or system APIs.

| Integration | Common Mistake | Correct Approach |
|-------------|----------------|------------------|
| YouTube URL open | Using `WKWebView` inline to load video | Use `UIApplication.shared.open(youtubeURL)` — opens YouTube app as specified in requirements |
| Dark mode detection | Polling `UITraitCollection.current.userInterfaceStyle` | Use SwiftUI `@Environment(\.colorScheme)` — reactive and automatic |
| Mocked Stripe payment | Building a multi-step UIKit sheet | Build as a SwiftUI `.sheet` with a realistic card entry form and hardcoded "success" on tap — no actual Stripe SDK |
| Profile images from `profiles-demos/` | Loading as `UIImage(named:)` with wrong bundle path | Ensure images are added to Assets.xcassets or verify bundle path; use `Image("BD-profile")` not file path strings |
| Confetti library (if using SPM) | Adding a third-party package | Requirements forbid third-party frameworks unless approved — build confetti with SwiftUI `Canvas` and `TimelineView` |

---

## Performance Traps

Patterns that work at small scale but create visible jank in the Simulator demo.

| Trap | Symptoms | Prevention | When It Breaks |
|------|----------|------------|----------------|
| Confetti with 200+ particles using `ZStack` overlay per particle | Frame drops, animation stutter | Use `Canvas`-based rendering; cap at 100-150 particles | Immediately on Simulator A14 and below hardware emulation |
| Forum thread list with `LazyVStack` inside `ScrollView` and complex row views | Slow scroll, visible redraws | Use `List` or ensure `LazyVStack` rows have bounded height and no redundant computed properties | At 20+ posts per forum thread |
| `ForEach` over all communities including non-subscribed with large images | Initial load flicker, memory spike | Use `LazyVStack` or `List` for discovery screens; size images at display resolution, not full resolution | At 6+ communities with profile banners |
| `@Observable` view models recomputing entire view tree on any property change | Unnecessary redraws during navigation | Split large view models; use fine-grained `@Observable` properties rather than one monolithic model | During complex animated transitions |
| Animating `.scaleEffect` and `.opacity` together during tab switch | Janky transition | Prefer `withAnimation(.spring)` for single property; avoid simultaneous transform + opacity on complex views | Every tab switch during demo |

---

## UX Pitfalls

Common user experience mistakes in community/subscription app interfaces.

| Pitfall | User Impact | Better Approach |
|---------|-------------|-----------------|
| Showing tier price without value context | User sees cost before benefit; conversion drops | Content-first: show what they get in each tier, price is secondary — follows Patreon's proven model |
| Decision fatigue from showing all 4 tiers expanded by default | Overwhelming, stakeholders don't know where to look | Show tiers collapsed with expand-on-tap; highlight the recommended/popular tier |
| Community landing page that looks like a settings screen | Feels like admin, not a destination | Landing page must feel like a product page: banner, creator hero moment, value statement before tier options |
| Lock icons that block content without explaining what tier unlocks it | Frustration, no clear path to upgrade | Show "Available to [Tier Name] members" with a subtle CTA, not just a padlock |
| Creator dashboard shown first in the demo before subscriber journey | Stakeholders anchor to the creator tool, miss the consumer experience | Always start the demo from the subscriber perspective; creator view is appendix |
| Confetti animation that plays for too long | Awkward in a live demo | Cap at 2.5-3 seconds; auto-dismiss the success state and navigate to the community |
| FAQ "submit a question" with no confirmation state | Unclear if action succeeded | Always show a success state after mock submission, even if it's just a toast |
| Inconsistent card border radius (8px vs 12px) | Subtle visual incoherence across screens | PROJECT.md says 8px radius for buttons, 12px for cards — enforce this distinction in the design token layer |

---

## "Looks Done But Isn't" Checklist

Things that appear complete visually but are missing critical pieces for a convincing demo.

- [ ] **Communities tab icon:** Verify the tab bar icon is the correct SF Symbol or custom icon, not a placeholder — it appears in every tab switch during the demo
- [ ] **Inter font:** Confirm Inter is rendering by checking a weight-sensitive string (e.g., a SemiBold button label) against the brand reference — system SF Pro looks similar enough to miss
- [ ] **Dark mode pass:** Run the entire subscriber demo flow in dark mode; card borders, tier cards, forum posts, and the payment sheet must all be readable
- [ ] **Tier permission consistency:** Verify locked content shows the correct lock state for a free-tier user across ALL three content types: feed posts, forum threads, FAQ zone
- [ ] **Subscribe → Community transition:** After mocked payment success and confetti, confirm the user lands in the correct community with subscribed state reflected in the UI (tier badge visible, locked content unlocked)
- [ ] **Profile images load:** All six ambassador profiles (BD, Brandon, Max, Nick, Moe, Canadian in a T-shirt) must load from `profiles-demos/` — missing images break community card credibility
- [ ] **YouTube tap:** Tapping a video link must open the YouTube app, not crash or open an in-app browser
- [ ] **Creator earnings math:** The 10% Blossom fee calculation in the creator dashboard must be arithmetically correct for whatever mock revenue numbers are displayed

---

## Recovery Strategies

When pitfalls occur despite prevention, how to recover.

| Pitfall | Recovery Cost | Recovery Steps |
|---------|---------------|----------------|
| Shared navigation state discovered mid-build | HIGH | Refactor TabView to give each tab its own NavigationStack and path; touches every root view and any view that uses `.navigationDestination` |
| Brand color drift across 15+ screens | MEDIUM | Create `BlossomColors` token file; use Xcode Find & Replace with regex to locate all `Color(hex:` and `Color.purple/blue` instances; replace systematically |
| Inter font not loading | LOW | Add to Info.plist `UIAppFonts`, verify Build Phases Copy Bundle Resources, confirm PostScript names with debug print — usually fixed in under 30 minutes |
| Dark mode breakage | MEDIUM | Audit all `Color.white`, `Color.black`, and raw hex color uses; replace with adaptive color sets in Assets.xcassets; test each screen in both modes |
| Tier permission logic inconsistency | MEDIUM | Extract all inline permission checks into a `TierPermissionService`; grep for `tierLevel` and `tier >=` patterns across the codebase |
| Swift 6 concurrency errors throughout mock layer | MEDIUM | Add `@MainActor` to all `@Observable` view models and service classes; remove any `async` functions that aren't needed in a synchronous mock context |
| Scope creep on creator dashboard | LOW | Defer all creator screens beyond earnings summary and community overview to a "Phase 2" stub; add disabled buttons with "Coming soon" labels |

---

## Pitfall-to-Phase Mapping

How roadmap phases should address these pitfalls.

| Pitfall | Prevention Phase | Verification |
|---------|------------------|--------------|
| Shared navigation state | Phase 1 (Foundation) | Each tab can navigate independently without affecting other tabs; tapping same tab icon twice pops to root |
| iOS 26 Liquid Glass tab bar insets | Phase 1 (Foundation) | Bottom content is not obscured on scroll in any tab; tab bar renders with correct Blossom brand presence |
| Inter font silent fallback | Phase 1 (Design System) | `UIFont.familyNames` includes "Inter"; SemiBold button text visually matches brand reference |
| Brand color drift | Phase 1 (Design System) | Zero inline `Color(hex:)` calls in view files; all colors reference `BlossomColors` tokens |
| Dark mode breakage | Phase 1 (Design System) + per-phase QA | Full subscriber demo flow runs without visual defects in dark mode |
| Tier permission scattered logic | Phase 2 (Community Core) | All lock states derive from one `TierPermissionService`; changing a tier's permissions updates all screens |
| Mock data without service layer | Phase 1 (Foundation) | No direct `MockData.x[n]` references in view files; subscription state change is reflected live in the UI |
| Prototype scope creep | Phase 0 (Planning) | Demo script exists; creator dashboard is scoped to two screens maximum |
| Confetti lifecycle issues | Phase 3 (Payment Flow) | Confetti can be triggered three times in a row without animation state corruption |
| Swift 6 concurrency errors | Phase 1 (Foundation) | Project builds with zero warnings on Swift 6 strict concurrency mode |

---

## Sources

- [Mastering Navigation in SwiftUI: The 2025 Guide to Clean, Scalable Routing](https://medium.com/@dinaga119/mastering-navigation-in-swiftui-the-2025-guide-to-clean-scalable-routing-bbcb6dbce929)
- [The Ideal TabView Behaviour With SwiftUI Navigation Stack](https://betterprogramming.pub/swiftui-navigation-stack-and-ideal-tab-view-behaviour-e514cc41a029)
- [Using NavigationPath with TabView in SwiftUI](https://tanaschita.com/swiftui-navigation-path-with-tabview/)
- [Exploring tab bars on iOS 26 with Liquid Glass – Donny Wals](https://www.donnywals.com/exploring-tab-bars-on-ios-26-with-liquid-glass/)
- [Liquid Glass Tab Bar in SwiftUI (iOS 26): behavior, Search, and customization](https://jorgemrht.dev/2025/09/18/liquid-glass-tab-bar)
- [What can go wrong when using custom fonts in SwiftUI](https://blog.eidinger.info/what-can-go-wrong-when-using-custom-fonts-in-swiftui)
- [How to add custom fonts to iOS app – Sarunw](https://sarunw.com/posts/how-to-add-custom-fonts-to-ios-app/)
- [Master SwiftUI Design Systems: From Scattered Colors to Unified UI Components](https://dev.to/swift_pal/master-swiftui-design-systems-from-scattered-colors-to-unified-ui-components-4i9c)
- [SwiftUI Design System Considerations: Semantic Colors](https://www.magnuskahr.dk/posts/2025/06/swiftui-design-system-considerations-semantic-colors/)
- [Exploring concurrency changes in Swift 6.2 – Donny Wals](https://www.donnywals.com/exploring-concurrency-changes-in-swift-6-2/)
- [Migrating to Swift Strict Concurrency: A Complete Practical Guide for iOS Developers](https://medium.com/@sampath27/migrating-to-swift-strict-concurrency-a-complete-practical-guide-for-ios-developers-716a9423714d)
- [We Need to Talk About Observation – Jared Sinclair](https://jaredsinclair.com/2025/09/10/observation.html)
- [Scrolling a list up and down breaks the animation – Hacking with Swift forums](https://www.hackingwithswift.com/forums/swiftui/scrolling-a-list-up-and-down-breaks-the-animation/13707)
- [ConfettiSwiftUI – Swift Package Index](https://swiftpackageindex.com/simibac/ConfettiSwiftUI)
- [Stop Making Singletons in Swift: A Dependency Injection Guide](https://medium.com/@ivkuznetsov/how-to-stop-making-singletons-in-swift-a-dependency-injection-guide-dd7bd55abe4d)
- [Handling Dark Mode Elegantly in SwiftUI](https://jacobzivandesign.com/technology/dark_mode_swift_ui/)
- [Blossom Brand Guidelines – SKILL.md (project internal)](../brand-guidlines/SKILL.md)

---
*Pitfalls research for: SwiftUI Patreon-like paid community prototype (Blossom Communities)*
*Researched: 2026-03-10*
