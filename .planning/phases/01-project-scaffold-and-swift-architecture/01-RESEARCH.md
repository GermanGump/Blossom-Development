# Phase 1: Project Scaffold and Swift Architecture - Research

**Researched:** 2026-03-10
**Domain:** SwiftUI / iOS 26 / Swift 6.2 / Xcode Project Setup
**Confidence:** HIGH

---

<user_constraints>
## User Constraints (from CONTEXT.md)

### Locked Decisions
- Traditional solid white tab bar — suppress iOS 26 Liquid Glass with `.toolbarBackground`
- White background in light mode, Dark Navy #1E222A in dark mode
- Active tab: Teal #35C7B2 (icon + label text) — matches real Blossom app exactly
- Inactive tabs: Light gray icons + light gray labels
- Subtle top separator line on the tab bar — matches screenshot
- Scrollable tab bar — do not cram all 6 icons into fixed width. Implement as a horizontally scrolling tab bar so more tabs can be added in the future
- Violet floating action button (FAB) — only show on screens where the user can take an action. Not on every screen
- Tab order (left to right): Home, Hubs, Markets, Learn, Portfolio, Insights
- Hubs is 2nd position (after Home) — prominent placement
- Icons: Home: house.fill, Hubs: person.3.fill, Markets: globe, Learn: book.fill, Portfolio: arrow.triangle.2.circlepath, Insights: bolt.fill
- Label: "Hubs" (not "Communities")
- Top nav bar on Hubs tab: Left avatar (teal ring + Blossom badge), Center functional search bar, Right teal bell with red badge + purple dollar-sign chat bubble
- Non-Hubs tabs show branded placeholder screens (large icon + tab name + "Coming soon")
- Nick is the logged-in demo user; photo from profiles-demos/nick-profile-pic.png
- Dark mode support from day one; app defaults to light mode on launch
- Xcode project name: "BlossomHubs", app display name: "Blossom Hubs", bundle: com.blossom.hubs-prototype
- App icon: Blossom-logo-icon-square.png from brand assets

### Claude's Discretion
- Exact Xcode project structure and group organization (feature-based recommended)
- NavigationStack path enum design per tab
- ComponentsKit import and initial configuration
- Swift 6.2 strict concurrency setup details
- Exact SF Symbol names if the ones listed don't match Blossom screenshots closely enough

### Deferred Ideas (OUT OF SCOPE)
- None — discussion stayed within phase scope
</user_constraints>

---

<phase_requirements>
## Phase Requirements

| ID | Description | Research Support |
|----|-------------|-----------------|
| FOUND-01 | App launches as a SwiftUI project targeting iOS 26 / Swift 6.2 in Xcode Simulator | Xcode 26 released Sept 2025 alongside iOS 26; SwiftUI App lifecycle is the correct entry point; deployment target set to iOS 26 |
| FOUND-02 | Bottom tab bar with 6 tabs matching Blossom's existing navigation pattern | Custom scrollable tab bar using ZStack + ScrollView approach; native TabView used for content hosting; Liquid Glass suppressed via UITabBar.appearance() + toolbarBackground modifiers |
| FOUND-03 | Each tab has independent NavigationStack with value-based routing (no shared NavigationStack wrapping TabView) | TabView must be the outer container; each tab's content wrapped in its own NavigationStack with a per-tab enum-based path |
| FOUND-07 | All @Observable classes marked @MainActor for Swift 6.2 strict concurrency compliance | Swift 6.2's approachable concurrency: annotate every @Observable class with @MainActor; synchronous mock data returns eliminate actor-crossing; Xcode strict concurrency setting must be "Complete" |
| FOUND-08 | ComponentsKit integrated via SPM as approved third-party dependency | SPM URL: https://github.com/componentskit/ComponentsKit.git; version 1.6.1 (Feb 2026); iOS 15+ minimum; add via File > Add Package Dependencies |
</phase_requirements>

---

## Summary

Phase 1 establishes the architectural skeleton on which all subsequent phases build. The two highest-risk areas are (1) correctly suppressing iOS 26 Liquid Glass on the tab bar — requiring both UIKit appearance APIs and SwiftUI `toolbarBackground` modifiers — and (2) implementing strict-concurrency-clean @Observable view models with @MainActor from day one, because retrofitting later is error-prone.

The scrollable custom tab bar is a deliberate departure from native `TabView` tab items. Because the project needs 6+ items that scroll horizontally and requires full color control (teal active state, light gray inactive state, custom separator, no glass), the correct approach is a ZStack architecture: native `TabView` handles content switching underneath while a fully custom `ScrollView`-based `HStack` overlays the bottom. The native tab bar chrome is hidden entirely via `UITabBar.appearance()` and `.toolbar(.hidden, for: .tabBar)`.

Swift 6.2's approachable concurrency (SE-0466 `defaultIsolation`) can optionally reduce annotation boilerplate, but the most portable and explicit pattern — annotating every `@Observable` ViewModel class with `@MainActor` — is preferred here because it is readable, unambiguous, and Xcode strict concurrency mode "Complete" will verify it at compile time.

**Primary recommendation:** Build the tab bar as a custom overlay (ZStack + ScrollView HStack) over a hidden native TabView. Annotate every @Observable class @MainActor. Set Xcode Swift Strict Concurrency to "Complete" on the target before writing a single ViewModel.

---

## Standard Stack

### Core
| Library / Framework | Version | Purpose | Why Standard |
|---|---|---|---|
| SwiftUI | iOS 26 / Xcode 26 | Primary UI framework | First-party; required by project targeting |
| Swift | 6.2 | Language | Ships with Xcode 26; concurrency model is the requirement |
| Observation framework (@Observable) | iOS 17+ / bundled with iOS 26 | Reactive state management replacing ObservableObject | First-party; lower boilerplate than Combine; works with SwiftUI automatically |
| ComponentsKit | 1.6.1 (Feb 2026) | Pre-built SwiftUI/UIKit UI components | Only approved third-party SPM dependency |

### Supporting
| Library / Framework | Version | Purpose | When to Use |
|---|---|---|---|
| UIKit (UITabBar.appearance) | iOS 26 | Suppress Liquid Glass on tab bar at the UIKit layer | Required in app init to globally set tab bar appearance before SwiftUI renders |
| SF Symbols | 6.x (bundled iOS 26) | System icons for tab items and nav bar | All tab icons; teal bell; no custom icon assets needed |

### Alternatives Considered
| Instead of | Could Use | Tradeoff |
|---|---|---|
| Custom ZStack tab bar | Native TabView .tabItem | Native approach cannot scroll, cannot fully suppress glass reliably, cannot achieve teal/gray color control |
| @Observable + @MainActor | ObservableObject + @Published | ObservableObject is the old pattern; @Observable is the Swift 6.2 idiomatic choice |
| Explicit @MainActor per class | SE-0466 defaultIsolation in Package.swift | defaultIsolation is cleaner for SPM packages but Xcode targets use different mechanism; explicit annotations are more readable in an Xcode app target |

**Installation:**
```bash
# Via Xcode: File > Add Package Dependencies
# URL: https://github.com/componentskit/ComponentsKit.git
# Version rule: Up to Next Major from 1.6.1
```

---

## Architecture Patterns

### Recommended Project Structure
```
BlossomHubs/
├── App/
│   ├── BlossomHubsApp.swift          # @main entry point, UITabBar.appearance() setup
│   └── ContentView.swift             # Root ZStack (custom tab bar + TabView content switcher)
├── Features/
│   ├── TabBar/
│   │   ├── BlossomTabBar.swift        # Custom scrollable horizontal tab bar view
│   │   ├── TabItem.swift              # Model: tab identifier, icon, label
│   │   └── TabSelection.swift         # @Observable @MainActor selected tab state
│   ├── Hubs/
│   │   ├── HubsView.swift             # Hubs tab root — contains top nav bar
│   │   ├── HubsTopNavBar.swift        # Avatar + search + bell + chat row
│   │   ├── HubsViewModel.swift        # @Observable @MainActor
│   │   └── HubsNavigation.swift       # enum HubsRoute: Hashable
│   ├── Home/
│   │   ├── HomeView.swift
│   │   └── HomeNavigation.swift
│   ├── Markets/
│   ├── Learn/
│   ├── Portfolio/
│   └── Insights/
├── Core/
│   ├── Components/
│   │   ├── AvatarView.swift           # Reusable: circular photo + teal ring + badge
│   │   └── PlaceholderTabView.swift   # Branded "Coming soon" screen
│   └── Theme/
│       └── BlossomTheme.swift         # Color constants (teal, violet, navy, etc.)
└── Assets.xcassets/
    ├── AppIcon                        # Blossom-logo-icon-square.png
    └── (color sets added Phase 2)
```

### Pattern 1: ZStack Custom Tab Bar Over Hidden Native TabView

**What:** Native `TabView` drives content switching (preserves per-tab NavigationStack state). A custom `BlossomTabBar` view is overlaid at the bottom using `ZStack(alignment: .bottom)`. The native tab bar chrome is hidden entirely.

**When to use:** When you need full visual control over the tab bar (scrollable, custom colors, no system glass) while retaining native content lifecycle and NavigationStack isolation.

**Example:**
```swift
// ContentView.swift
// Source: Synthesized from AppCoda custom tab bar pattern + iOS 26 Liquid Glass suppression
struct ContentView: View {
    @State private var selectedTab: AppTab = .hubs

    var body: some View {
        ZStack(alignment: .bottom) {
            TabView(selection: $selectedTab) {
                NavigationStack {
                    HubsView()
                }
                .tag(AppTab.hubs)
                .toolbar(.hidden, for: .tabBar)   // hide native chrome per tab

                NavigationStack {
                    PlaceholderTabView(tab: .home)
                }
                .tag(AppTab.home)
                .toolbar(.hidden, for: .tabBar)

                // ... other tabs
            }
            .ignoresSafeArea(edges: .bottom)      // let content fill; custom bar handles safe area

            BlossomTabBar(selectedTab: $selectedTab)
        }
    }
}
```

### Pattern 2: Per-Tab Enum-Based NavigationStack Routing

**What:** Each feature module defines its own `Route` enum conforming to `Hashable`. The tab's root view owns a `NavigationStack(path:)` binding to an `@State` array of that enum. Only that tab's routes are ever on its stack.

**When to use:** Always — this is the non-negotiable architectural requirement (FOUND-03). Prevents navigation bleed between tabs.

**Example:**
```swift
// HubsNavigation.swift
enum HubsRoute: Hashable {
    case communityDetail(id: String)
    case memberProfile(userId: String)
}

// HubsView.swift
struct HubsView: View {
    @State private var path: [HubsRoute] = []

    var body: some View {
        NavigationStack(path: $path) {
            HubsRootView(path: $path)
                .navigationDestination(for: HubsRoute.self) { route in
                    switch route {
                    case .communityDetail(let id): CommunityDetailView(id: id)
                    case .memberProfile(let userId): MemberProfileView(userId: userId)
                    }
                }
        }
    }
}
```

### Pattern 3: @Observable @MainActor ViewModel

**What:** Every ViewModel class uses the `@Observable` macro and `@MainActor` annotation. All state mutations happen synchronously on the main actor, avoiding data race warnings under Swift 6 strict concurrency.

**When to use:** Every ViewModel in the project, starting with the very first one created in Phase 1.

**Example:**
```swift
// HubsViewModel.swift
// Source: Swift 6.2 strict concurrency pattern; @Observable (iOS 17+)
@Observable
@MainActor
final class HubsViewModel {
    var searchText: String = ""
    var communities: [Community] = []

    func loadCommunities() {
        // Synchronous mock data — no async needed in Phase 1/2
        communities = MockData.sampleCommunities
    }
}

// Usage in view:
struct HubsRootView: View {
    @State private var viewModel = HubsViewModel()
    // ...
}
```

### Pattern 4: Liquid Glass Suppression — Dual Layer

**What:** Suppress iOS 26 Liquid Glass at both the UIKit layer (globally, before first render) and the SwiftUI layer (per tab content).

**When to use:** Required. Both layers needed because iOS 26 can restore glass during scroll edge transitions if only one layer is set.

**Example:**
```swift
// BlossomHubsApp.swift
@main
struct BlossomHubsApp: App {
    init() {
        // UIKit layer: suppress glass globally before SwiftUI renders
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = UIColor.systemBackground  // adaptive: white / dark navy
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance  // CRITICAL: both must be set
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(.light)  // Default to light mode for demo
        }
    }
}
```

```swift
// In each tab's NavigationStack content (SwiftUI layer):
.toolbarBackground(.visible, for: .tabBar)
.toolbarBackground(Color.white, for: .tabBar)  // redundant with hidden native bar, but belt-and-suspenders
```

Note: Because the custom tab bar replaces the native one entirely (`.toolbar(.hidden, for: .tabBar)` per tab), the primary suppression mechanism is the UIKit `UITabBarAppearance` setup in `init()`. The SwiftUI modifiers are belt-and-suspenders.

### Pattern 5: BlossomTabBar — Scrollable Custom Implementation

**What:** A `ScrollView(.horizontal, showsIndicators: false)` containing an `HStack` of custom tab item buttons. An `@Namespace` + `matchedGeometryEffect` or a simple Teal underline/fill marks the selected tab.

**When to use:** Replaces native `.tabItem` entirely. Positioned at the bottom via the ZStack parent.

**Example:**
```swift
// BlossomTabBar.swift
struct BlossomTabBar: View {
    @Binding var selectedTab: AppTab
    private let tabColor = Color(hex: "#35C7B2")   // Teal
    private let inactiveColor = Color(UIColor.systemGray3)

    var body: some View {
        VStack(spacing: 0) {
            Divider()  // subtle separator line matching screenshot
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 0) {
                    ForEach(AppTab.allCases) { tab in
                        BlossomTabItem(
                            tab: tab,
                            isSelected: selectedTab == tab,
                            activeColor: tabColor,
                            inactiveColor: inactiveColor
                        ) {
                            selectedTab = tab
                        }
                    }
                }
                .padding(.horizontal, 8)
            }
            .background(Color(UIColor.systemBackground))
            .frame(height: 60)
            // safe area padding handled here:
            .padding(.bottom, UIApplication.shared.firstKeyWindow?.safeAreaInsets.bottom ?? 0)
        }
    }
}
```

### Anti-Patterns to Avoid

- **NavigationStack wrapping TabView:** NavigationStack must be inside each tab, never outside. Wrapping TabView in NavigationStack causes all tabs to share a single back stack — navigation bleeds across tabs.
- **Using `.tabItem` for the Blossom design:** Native tab items cannot be made scrollable, cannot be tinted per-item to Blossom brand colors reliably in iOS 26, and cannot suppress the glass reliably.
- **Calling `UITabBar.appearance()` after the first render:** Must be called in `App.init()` or `SceneDelegate`, not in `onAppear`.
- **Forgetting `scrollEdgeAppearance`:** Setting only `standardAppearance` allows Liquid Glass to reappear when content is scrolled to the edge. Both must be set to the same object.
- **@Observable without @MainActor:** Will trigger Swift 6 strict concurrency warnings on any stored property access from outside the class. Always pair them.

---

## Don't Hand-Roll

| Problem | Don't Build | Use Instead | Why |
|---|---|---|---|
| UI components (buttons, inputs, modals) | Custom button/input/modal from scratch | ComponentsKit 1.6.1 | Pre-built, animated, production-ready; only approved third-party dep |
| Tab bar glass suppression | Custom UIViewRepresentable UITabBar subclass | UITabBarAppearance API + `.toolbar(.hidden)` | First-party UIKit appearance API handles it cleanly |
| Reactive state | @Published + ObservableObject + Combine | @Observable macro | iOS 17+ built-in, less boilerplate, Swift 6 native |
| Color constants | String literals "#35C7B2" everywhere | BlossomTheme.swift with Color extensions | Single source of truth; dark mode adaptability |

**Key insight:** The appearance API and Observation framework cover all of Phase 1's "infrastructure" concerns. No new patterns are needed beyond standard Apple-provided tools.

---

## Common Pitfalls

### Pitfall 1: Liquid Glass Persists During Scroll
**What goes wrong:** The custom appearance is set but Liquid Glass reappears when scroll content reaches the edge of a ScrollView.
**Why it happens:** `scrollEdgeAppearance` is a separate iOS property that overrides `standardAppearance` at scroll edges. It defaults to the system glass effect.
**How to avoid:** Always set BOTH: `UITabBar.appearance().standardAppearance = appearance` AND `UITabBar.appearance().scrollEdgeAppearance = appearance` to the same configured appearance object.
**Warning signs:** Tab bar looks correct when content is scrolled down but shows glass blur when content is at the top.

### Pitfall 2: Navigation Bleed Between Tabs
**What goes wrong:** Navigating deep into tab A, switching to tab B, switching back to tab A — and finding you're at the root instead of where you were. Or worse, tab B's content appearing on tab A's stack.
**Why it happens:** Placing `NavigationStack` outside `TabView` (wrapping the whole thing) creates a single shared path.
**How to avoid:** `TabView` is always the outermost container. Every tab's content is independently wrapped in its own `NavigationStack(path: $tabSpecificPath)`.
**Warning signs:** Tapping the back button after a tab switch behaves unexpectedly.

### Pitfall 3: Swift 6 Strict Concurrency Warnings Cascade
**What goes wrong:** Enabling strict concurrency on an existing codebase produces dozens of errors all at once.
**Why it happens:** @Observable properties accessed from non-@MainActor contexts, Sendable conformance gaps.
**How to avoid:** Set Xcode Build Settings > Swift Strict Concurrency to "Complete" on the target BEFORE writing any code in Phase 1. Fix each file as you write it rather than retroactively.
**Warning signs:** Any "Main actor-isolated property" or "Sendable" warning in Xcode.

### Pitfall 4: Safe Area Inset on Custom Tab Bar
**What goes wrong:** Custom tab bar overlaps home indicator on Face ID devices. Or content underneath the custom bar is clipped.
**Why it happens:** Custom views overlaid in a ZStack don't automatically get tab bar safe-area treatment like native TabView does.
**How to avoid:** Read `UIApplication.shared.firstKeyWindow?.safeAreaInsets.bottom` and add it as bottom padding to the custom tab bar. Add `.ignoresSafeArea(edges: .bottom)` to the `TabView` so content can extend under the bar, then use `safeAreaInset(edge: .bottom)` or padding on the content to prevent actual clipping.
**Warning signs:** Content is clipped or tab bar floats too high leaving a gap.

### Pitfall 5: UITabBar.appearance() Called Too Late
**What goes wrong:** Appearance customization has no effect or flickers on first load.
**Why it happens:** `UITabBar.appearance()` must be called before UIKit renders the first tab bar. Calling it in `onAppear` or `task` is too late.
**How to avoid:** Call in `App.init()`.
**Warning signs:** First launch shows glass briefly before switching to correct appearance.

### Pitfall 6: iOS 26 SF Symbol Name Changes
**What goes wrong:** An SF Symbol name that existed in iOS 17/18 does not exist in iOS 26, causing a placeholder to render.
**Why it happens:** Apple adds and renames symbols across major releases.
**How to avoid:** Verify each symbol in SF Symbols app (version 6.x, included with Xcode 26) before hardcoding. The symbols specified (house.fill, person.3.fill, globe, book.fill, arrow.triangle.2.circlepath, bolt.fill) are all confirmed stable.
**Warning signs:** Image renders as a question mark or empty box.

---

## Code Examples

### Tab Enum Definition
```swift
// TabSelection.swift
// Source: Standard SwiftUI enum-based tab pattern
enum AppTab: String, CaseIterable, Identifiable {
    case home = "Home"
    case hubs = "Hubs"
    case markets = "Markets"
    case learn = "Learn"
    case portfolio = "Portfolio"
    case insights = "Insights"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .home:      "house.fill"
        case .hubs:      "person.3.fill"
        case .markets:   "globe"
        case .learn:     "book.fill"
        case .portfolio: "arrow.triangle.2.circlepath"
        case .insights:  "bolt.fill"
        }
    }
}
```

### Branded Placeholder Screen
```swift
// PlaceholderTabView.swift
// Source: Original — standard SwiftUI composition
struct PlaceholderTabView: View {
    let tab: AppTab

    var body: some View {
        VStack(spacing: 16) {
            Spacer()
            Image(systemName: tab.icon)
                .font(.system(size: 56, weight: .regular))
                .foregroundColor(Color(hex: "#35C7B2"))
            Text(tab.rawValue)
                .font(.title.weight(.semibold))
                .foregroundColor(Color(hex: "#1E222A"))
            Text("Coming soon")
                .font(.subheadline)
                .foregroundColor(.secondary)
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(UIColor.systemBackground))
    }
}
```

### Top Nav Bar (Hubs Tab) — Visual Reference
From the confirmed screenshot (`Blossom app Tab Bar Sample.png`):
- Left: circular avatar (Nick's photo), teal ring border, small Blossom bolt badge overlay bottom-left
- Center: rounded rectangle search field, gray background (#F0F0F0 approx), magnifying glass + "Search" placeholder text
- Right: teal bell icon with red notification badge (count "9+"), then purple circle with "$" chat bubble icon

```swift
// HubsTopNavBar.swift
struct HubsTopNavBar: View {
    @Binding var searchText: String

    var body: some View {
        HStack(spacing: 12) {
            // Left: Nick's avatar with teal ring
            AvatarView(
                image: Image("nick-profile-pic"),
                ringColor: Color(hex: "#35C7B2"),
                showBadge: true
            )
            .frame(width: 40, height: 40)

            // Center: search bar
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.secondary)
                TextField("Search", text: $searchText)
                    .font(.subheadline)
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 8)
            .background(Color(UIColor.systemGray6))
            .cornerRadius(10)

            Spacer()

            // Right: bell with badge
            ZStack(alignment: .topTrailing) {
                Image(systemName: "bell.fill")
                    .foregroundColor(Color(hex: "#35C7B2"))
                    .font(.title3)
                Text("9+")
                    .font(.system(size: 9, weight: .bold))
                    .foregroundColor(.white)
                    .padding(.horizontal, 3)
                    .background(Color.red)
                    .clipShape(Capsule())
                    .offset(x: 6, y: -6)
            }

            // Right: purple chat bubble with dollar sign
            ZStack {
                Circle()
                    .fill(Color(hex: "#7361F7"))
                    .frame(width: 34, height: 34)
                Image(systemName: "dollarsign.bubble.fill")
                    .foregroundColor(.white)
                    .font(.system(size: 16))
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 8)
    }
}
```

### Reusable AvatarView (Teal Ring + Badge)
```swift
// AvatarView.swift — reusable across the entire app
struct AvatarView: View {
    let image: Image
    var ringColor: Color = Color(hex: "#35C7B2")
    var showBadge: Bool = false
    var size: CGFloat = 40

    var body: some View {
        ZStack(alignment: .bottomLeading) {
            image
                .resizable()
                .scaledToFill()
                .frame(width: size, height: size)
                .clipShape(Circle())
                .overlay(Circle().stroke(ringColor, lineWidth: 2))

            if showBadge {
                Image(systemName: "bolt.fill")
                    .font(.system(size: size * 0.25, weight: .bold))
                    .foregroundColor(.white)
                    .frame(width: size * 0.32, height: size * 0.32)
                    .background(Color(hex: "#7361F7"))
                    .clipShape(Circle())
                    .offset(x: -2, y: 2)
            }
        }
    }
}
```

---

## Visual Reference Analysis

From screenshots examined:

**`Blossom app Tab Bar Sample.png` (top nav bar):**
- Avatar: ~40pt circular, teal (#35C7B2) ring, violet bolt badge bottom-left
- Search bar: full-width rounded rectangle, ~systemGray6 fill, leading magnifying glass, "Search" placeholder
- Bell: teal fill, red capsule badge "9+"
- Chat: violet (#7361F7) filled circle, white dollar-sign-in-bubble icon

**`Blossom app bottom Tab bar sample.png` (bottom tab bar):**
- Active tab (Home): teal icon + teal label
- Inactive tabs: gray icons + gray labels (not pure black)
- 5 tabs visible (Home, Markets, Learn, Portfolio, Insights) — Hubs to be inserted at position 2
- Violet FAB visible at bottom-right, floating above content
- Separator line above tab bar: thin, light gray
- Tab bar background: solid white, no glass/blur

---

## State of the Art

| Old Approach | Current Approach | When Changed | Impact |
|---|---|---|---|
| ObservableObject + @Published + Combine | @Observable macro (Observation framework) | iOS 17 / Swift 5.9 (2023), idiomatic in Swift 6.2 | Less boilerplate; no @Published needed; works with SwiftUI automatically |
| NavigationView | NavigationStack + value-based routing | iOS 16 (2022) | Type-safe navigation; programmatic routing; no deprecated APIs |
| UITabBarController (UIKit) | SwiftUI TabView | iOS 13+ (well-established) | Pure SwiftUI; but custom overlay approach needed for Blossom design |
| Manual @MainActor annotations everywhere | Swift 6.2 approachable concurrency (SE-0466 defaultIsolation) | Swift 6.2, Sept 2025 | Can set defaultIsolation in Package.swift to reduce boilerplate; for Xcode app targets, explicit @MainActor per class remains clearest |

**Deprecated/outdated:**
- `NavigationView`: Deprecated since iOS 16; never use in new iOS 26 projects
- `ObservableObject + @Published`: Functional but deprecated pattern for new code; use `@Observable`
- `@StateObject`, `@ObservedObject`: Replaced by `@State` and `@Bindable` when using @Observable

---

## Open Questions

1. **UITabBar.appearance() vs toolbarBackground on iOS 26 with hidden tab bar**
   - What we know: UITabBar.appearance() works at the UIKit layer; when the native tab bar is hidden with `.toolbar(.hidden, for: .tabBar)`, the custom BlossomTabBar takes over and appearance settings don't matter
   - What's unclear: Whether any iOS 26 system behavior can re-show the native tab bar unexpectedly
   - Recommendation: Call `UITabBar.appearance()` in App.init() as insurance. The custom overlay approach is the primary solution.

2. **ComponentsKit components used in Phase 1**
   - What we know: ComponentsKit is integrated as SPM dep in Phase 1; its components are used heavily in Phase 2+ (buttons, inputs, modals)
   - What's unclear: Whether Phase 1 actually needs any ComponentsKit component beyond ensuring it builds cleanly
   - Recommendation: Import ComponentsKit in Phase 1 to verify the SPM dep resolves and the project builds clean. Actual usage begins Phase 2.

3. **`firstKeyWindow` safe area access pattern**
   - What we know: `UIApplication.shared.windows.first(where: \.isKeyWindow)` is deprecated in iOS 15+
   - What's unclear: Best iOS 26 approach to read safe area insets outside of a View context
   - Recommendation: Use `GeometryReader` or `.safeAreaInset(edge: .bottom)` SwiftUI modifier on the content inside the ZStack, rather than reading UIKit safe area insets programmatically.

---

## Validation Architecture

`workflow.nyquist_validation` is `true` — validation section included.

### Test Framework
| Property | Value |
|---|---|
| Framework | Swift Testing (built into Xcode 26, no extra install) |
| Config file | None — Swift Testing is built-in; no separate config file |
| Quick run command | `xcodebuild test -scheme BlossomHubs -destination 'platform=iOS Simulator,name=iPhone 16' -only-testing BlossomHubsTests` |
| Full suite command | `xcodebuild test -scheme BlossomHubs -destination 'platform=iOS Simulator,name=iPhone 16'` |

Note: Phase 1 is a project scaffold phase. The primary validation is build success + Simulator launch, not unit test coverage. Most behavioral requirements (tab rendering, navigation isolation) are verified visually in Simulator. Unit tests cover the structural/compile-time correctness.

### Phase Requirements -> Test Map
| Req ID | Behavior | Test Type | Automated Command | File Exists? |
|---|---|---|---|---|
| FOUND-01 | App compiles and scheme builds without error | Build verification | `xcodebuild build -scheme BlossomHubs -destination 'platform=iOS Simulator,name=iPhone 16'` | ❌ Wave 0 |
| FOUND-01 | App launches in Simulator and reaches initial screen | Manual / UI | Launch in Simulator — visual confirm | N/A (manual) |
| FOUND-02 | 6 tabs present with correct labels and icons | Manual | Visual inspect in Simulator | N/A (manual) |
| FOUND-03 | NavigationStack path arrays are per-tab (not shared) | Unit | Verify each tab's View has its own `@State private var path` — code review | N/A (structural) |
| FOUND-07 | Zero Swift 6 strict concurrency warnings | Build verification | `xcodebuild build ...` with strict concurrency "Complete" — zero warnings required | ❌ Wave 0 (target setting) |
| FOUND-08 | ComponentsKit SPM dependency resolves and project builds | Build verification | `xcodebuild build -scheme BlossomHubs ...` — no missing symbol errors | ❌ Wave 0 |

### Sampling Rate
- **Per task commit:** Build verification (`xcodebuild build`)
- **Per wave merge:** Full build + Simulator launch visual check
- **Phase gate:** Zero build errors, zero strict concurrency warnings, Simulator shows correct 6-tab UI

### Wave 0 Gaps
- [ ] `BlossomHubs.xcodeproj` — does not exist yet, created in Wave 1 task 1
- [ ] Strict concurrency "Complete" setting on app target — must be set during project creation
- [ ] Swift Testing test target — add alongside app target during project creation
- [ ] ComponentsKit SPM resolution — verified by clean build after adding dependency

---

## Sources

### Primary (HIGH confidence)
- Official WWDC 2025 / Apple — iOS 26 released Sept 15, 2025; Xcode 26 released same date
- UITabBarAppearance API — UIKit appearance pattern: cross-verified across multiple sources
- Swift.org blog — [Swift 6.2 Released](https://www.swift.org/blog/swift-6.2-released/) — SE-0466 defaultIsolation, approachable concurrency
- ComponentsKit official docs — [https://componentskit.io/docs/getting-started/installation](https://componentskit.io/docs/getting-started/installation) — iOS 15+ min, SPM URL confirmed
- Brand screenshots (`brand-guidlines/app-screenshots/`) — visually confirmed top nav bar and bottom tab bar layout
- Brand SKILL.md — color palette, typography, brand identity constraints

### Secondary (MEDIUM confidence)
- [Donny Wals — Exploring tab bars on iOS 26 with Liquid Glass](https://www.donnywals.com/exploring-tab-bars-on-ios-26-with-liquid-glass/) — tab bar modifier behavior, verified against general UIKit appearance knowledge
- [AppCoda — Building a Scrollable Custom Tab Bar in SwiftUI](https://www.appcoda.com/swiftui-custom-tab-bar/) — ZStack overlay architecture, ScrollViewReader pattern
- [iifx.dev — Disabling iOS 26 Liquid Glass UITabBarController](https://iifx.dev/en/articles/457706356/cross-platform-consistency-disabling-the-ios-26-liquid-glass-uitabbarcontroller-effect) — UITabBarAppearance dual-property pattern (standard + scrollEdge)
- [Donny Wals — Exploring Swift 6.2 concurrency changes](https://www.donnywals.com/exploring-concurrency-changes-in-swift-6-2/) — defaultIsolation, nonisolated(nonsending)
- [Antoine van der Lee — Approachable Concurrency in Swift 6.2](https://www.avanderlee.com/concurrency/approachable-concurrency-in-swift-6-2-a-clear-guide/) — upcoming feature flags

### Tertiary (LOW confidence)
- Multiple Medium/community articles on custom tab bar patterns — general structural approach cross-verified against AppCoda tutorial

---

## Metadata

**Confidence breakdown:**
- Standard stack: HIGH — ComponentsKit confirmed at 1.6.1 (Feb 2026); SwiftUI/Swift 6.2/iOS 26 verified; @Observable confirmed iOS 17+
- Architecture (tab bar): HIGH — ZStack + ScrollView custom overlay is a well-established pattern; Liquid Glass suppression via UITabBarAppearance confirmed from multiple sources
- Architecture (navigation): HIGH — NavigationStack per-tab with enum path is the standard iOS 17+ recommended pattern
- Architecture (concurrency): HIGH — @Observable + @MainActor is the Swift 6.2 idiomatic approach; strict concurrency "Complete" Xcode setting is verified
- Pitfalls: HIGH — scrollEdgeAppearance dual-set and NavigationStack-outside-TabView anti-pattern verified from multiple authoritative sources
- ComponentsKit components for Phase 1: MEDIUM — Phase 1 only needs the dep to resolve; actual component usage research belongs in Phase 2

**Research date:** 2026-03-10
**Valid until:** 2026-06-10 (stable APIs; ComponentsKit version may update but SPM "up to next major" handles that)
