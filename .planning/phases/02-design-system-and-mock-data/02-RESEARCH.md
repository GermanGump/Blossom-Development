# Phase 2: Design System and Mock Data - Research

**Researched:** 2026-03-11
**Domain:** SwiftUI design system (Asset Catalog color sets, custom fonts, ViewModifier components) and Swift @Observable mock data layer
**Confidence:** HIGH

---

<user_constraints>
## User Constraints (from CONTEXT.md)

### Locked Decisions

**Color tokens & dark mode**
- Brand accent colors (Teal #35C7B2, Violet #7361F7, Orange #FF7833) stay IDENTICAL in both light and dark mode — only backgrounds, cards, and text colors adapt
- All colors defined as Asset Catalog named color sets with light/dark variants — BlossomTheme.swift references them via Color("BlossomTeal") etc.
- Dark mode cards use elevated surface (#2A2E38) with subtle 1px border (#3A3E48), matching the light mode card pattern (white + #E2E4E9 border) but inverted
- Tab bar and nav bar keep the current systemBackground approach — auto-adapts, just swap any hardcoded colors to new semantic tokens
- Dark Navy (#1E222A) used as the dark mode background color

**Typography & Inter font**
- Bundle Inter .otf font files directly in the project (Inter-Regular, Inter-Medium, Inter-SemiBold) — register in Info.plist via UIAppFonts
- Three weights only: Regular (body text), Medium (labels/buttons), Semi-Bold (headlines)
- Create a BlossomFont caseless enum with static properties (.largeTitle, .headline, .subhead, .body, .callout, .caption) returning Font.custom() at correct sizes
- Retrofit ALL existing Phase 1 views to use BlossomFont — no SF Pro / Inter mixing

**Shared UI components — comprehensive core primitives**
- BlossomCard ViewModifier: background, border, 12px corner radius, adapts for light/dark
- Button styles: match real Blossom app exactly (study brand-guidelines screenshots for exact styles)
- VerifiedBadge: match real Blossom app exactly (study profile-sample.png for exact badge style)
- SectionHeader: title + optional trailing action
- EmptyStateView: reusable with icon (SF Symbol), title, subtitle, optional CTA button
- LockedContentOverlay: blurred content + lock icon + upgrade prompt with tier name + action button
- TagView: pill-shaped labels with configurable styles (.stock for tickers, .tier for tier badges, .category for content categories)
- Enhanced AvatarView: add size presets, keep existing ring + badge pattern
- Loading states: use simple ProgressView spinner (no shimmer/skeleton)
- Feature-specific cards (CommunityCard, TierCard, PostCard, ThreadRow) deferred to their respective feature phases

**Mock data layer**
- Single @MainActor @Observable CommunityStore class holding all mock data — injected via @Environment at app level
- 6 communities — one per ambassador (BD, Brandon, Max, Nick, Moe, Canadian in a T-shirt)
- Each community has creator-defined tiers (1-4 tiers), posts, forum threads, FAQ entries
- Realistic investing content: real stock tickers ($AAPL, $TSLA, $NVDA), trade alerts, portfolio updates, market commentary
- All 6 ambassador profile photos added to Assets.xcassets from profiles-demos/
- All 3 Blossom logo variants (light, dark, icon-square) added to Assets.xcassets from brand-guidlines/logos/
- Nick's profile photo already exists in asset catalog — add remaining 5

### Claude's Discretion
- Exact dark mode color hex values for secondary surfaces beyond the specified card background
- BlossomFont point sizes for each type scale level
- Specific community names, descriptions, and tier structures for the 6 ambassador communities
- Mock data volume (number of posts, threads, FAQ entries per community)
- TagView exact styling (padding, corner radius, font size)
- SectionHeader layout details

### Deferred Ideas (OUT OF SCOPE)
None — discussion stayed within phase scope
</user_constraints>

---

<phase_requirements>
## Phase Requirements

| ID | Description | Research Support |
|----|-------------|-----------------|
| FOUND-04 | Blossom brand design system implemented as reusable SwiftUI components (colors, fonts, button styles, card modifiers) | Asset Catalog color sets pattern, Font.custom() + BlossomFont enum, ViewModifier for BlossomCard, ButtonStyle protocol |
| FOUND-05 | Inter font registered and verified (Regular 400, Medium 500, Semi-Bold 600 weights) | UIAppFonts Info.plist registration, Font.custom() verification via UIFont.familyNames |
| FOUND-06 | Light and dark mode support with system preference detection and correct color adaptation | Asset Catalog colorset appearances array with luminosity dark variant, Color("name") lookup |
| FOUND-09 | Mock data layer with sample communities, creators, tiers, posts, and forum content | @MainActor @Observable CommunityStore, Swift structs as pure value types, @Environment injection pattern |
| FOUND-10 | Real ambassador profile photos loaded from asset catalog (BD, Brandon, Max, Nick, Moe, Canadian in a T-shirt) | imageset format in Assets.xcassets, Image("name") lookup, xcodeproj Ruby gem for file registration |
| FOUND-11 | Blossom logo assets (light mode, dark mode, icon) loaded from asset catalog | imageset format, Image("name") lookup, dark mode variant using colorScheme environment |
</phase_requirements>

---

## Summary

Phase 2 builds the complete design system and mock data layer that all feature phases (3-9) will depend on. The work divides into four concrete tracks: (1) migrate Brand colors from inline hex to Asset Catalog named colorsets with light/dark variants; (2) bundle Inter .otf files and create the BlossomFont enum; (3) implement six core UI component primitives as reusable SwiftUI ViewModifiers and Views; (4) author the CommunityStore @Observable class with six ambassador communities of rich mock data.

The existing codebase from Phase 1 gives us a clean starting point. BlossomTheme.swift currently uses Color(hex:) inline — it must be refactored to Color("BlossomTeal") etc. once colorsets are in the asset catalog. AvatarView.swift already implements the ring + bolt badge pattern correctly and only needs size presets added. All six profile photos exist on disk in profiles-demos/ and three logo variants exist in brand-guidlines/logos/ — they need imagesets created in Assets.xcassets and registered in project.pbxproj via the xcodeproj Ruby gem.

The critical constraint for this phase is the project file tooling: Xcode is not installed in the execution environment, so every new Swift source file and every new asset group must be registered in project.pbxproj using the xcodeproj Ruby gem. This is the established pattern from Phase 1 and must be followed without exception.

**Primary recommendation:** Build in wave order — colors and fonts first (enable all other work), then components (depend on colors/fonts), then mock data (standalone), then retrofit Phase 1 views. Register all new files in project.pbxproj immediately when created.

---

## Standard Stack

### Core
| Library | Version | Purpose | Why Standard |
|---------|---------|---------|--------------|
| SwiftUI | iOS 26 SDK | All UI — Color, Font, ViewModifier, ButtonStyle | Native; no alternative |
| Swift Observation (@Observable) | Swift 5.9+ / Swift 6 | CommunityStore reactive data layer | Replaces ObservableObject; @MainActor-safe; project standard |
| Assets.xcassets | Xcode native | Color sets, image sets — automatic dark/light resolution | System resolves appearances at render time — no runtime switching code needed |
| UIFont / Font.custom() | UIKit/SwiftUI | Custom font loading from bundled .otf files | Standard iOS custom font mechanism; works with .preferredFont metrics |

### Supporting
| Library | Version | Purpose | When to Use |
|---------|---------|---------|-------------|
| xcodeproj Ruby gem | 1.27.0 (established) | Register new Swift files and asset groups in project.pbxproj | Every time a new file is created — required since Xcode not installed |
| UIFont.familyNames | UIKit | Verify Inter font registration at runtime | Debug-only print during development to confirm font loaded |

### Alternatives Considered
| Instead of | Could Use | Tradeoff |
|------------|-----------|----------|
| Asset Catalog color sets | Color(hex:) with @Environment colorScheme | Asset Catalog is zero-code, correct at compile time, automatically adapts; hex+environment requires manual if/else in every view |
| Font.custom() via BlossomFont enum | SwiftUI .font(.body) with UIFont.preferredFont | System fonts ignore bundled Inter; custom enum centralizes all sizes |
| @Observable CommunityStore | ObservableObject + @Published | @Observable is the Swift 6 / iOS 17+ standard; ObservableObject is deprecated direction |

**Installation:** No new packages. All tools are native iOS SDK or the existing xcodeproj gem.

---

## Architecture Patterns

### Recommended Project Structure (additions to Phase 1)
```
BlossomHubs/
├── App/
│   └── BlossomHubsApp.swift       # Add CommunityStore @State, inject via .environment()
│   └── ContentView.swift          # Add .environment(store) — no structural changes
├── Core/
│   ├── Theme/
│   │   ├── BlossomTheme.swift     # REFACTOR: Color("BlossomTeal") refs, add semantic tokens
│   │   └── BlossomFont.swift      # NEW: caseless enum, Font.custom() at each size
│   └── Components/
│       ├── AvatarView.swift       # EXTEND: size presets enum, verifiedBadge option
│       ├── BlossomCard.swift      # NEW: ViewModifier for card surface + border
│       ├── BlossomButton.swift    # NEW: ButtonStyle implementations (primary, secondary, ghost)
│       ├── VerifiedBadge.swift    # NEW: teal shield checkmark badge (matches profile-sample.png)
│       ├── TagView.swift          # NEW: pill label with .stock / .tier / .category styles
│       ├── SectionHeader.swift    # NEW: title + optional trailing Button
│       ├── EmptyStateView.swift   # NEW: SF Symbol + title + subtitle + optional CTA
│       └── LockedContentOverlay.swift  # NEW: blur + lock icon + tier upgrade prompt
├── Models/
│   ├── Community.swift            # NEW: Community, Creator, Tier, Post, Thread, FAQ structs
│   └── CommunityStore.swift       # NEW: @MainActor @Observable, holds [Community]
├── Features/
│   ├── TabBar/
│   │   ├── BlossomTabBar.swift    # RETROFIT: use BlossomFont / BlossomTheme tokens
│   │   └── TabItem.swift          # No change needed
│   ├── Hubs/
│   │   ├── HubsView.swift         # RETROFIT: BlossomFont, read store from @Environment
│   │   └── HubsTopNavBar.swift    # No change needed
│   └── [other tabs]/
│       └── PlaceholderTabView.swift  # RETROFIT: BlossomFont
└── Assets.xcassets/
    ├── Colors/                    # NEW: BlossomTeal, BlossomViolet, BlossomOrange,
    │                              #      BlossomDarkNavy, BlossomSlate, BlossomBackground,
    │                              #      BlossomCardSurface, BlossomCardBorder, BlossomSecondaryText
    └── Images/
        ├── bd-profile-pic.imageset
        ├── brandon-profile-pic.imageset
        ├── max-profile-pic.imageset
        ├── moe-profile-pic.imageset
        ├── canada-tshirt-profile-pic.imageset  # "Canadia in a T-shirt"
        ├── blossom-logo-light.imageset
        ├── blossom-logo-dark.imageset
        └── blossom-logo-icon.imageset
```

### Pattern 1: Asset Catalog Named Color Sets (FOUND-04, FOUND-06)
**What:** JSON colorset files with "universal" (light) and "luminosity dark" appearance entries. SwiftUI resolves them automatically via `Color("name")`.
**When to use:** Every brand color, every semantic surface color (background, card, border, text).
**Example Contents.json:**
```json
{
  "colors": [
    {
      "color": {
        "color-space": "srgb",
        "components": { "alpha": "1.000", "blue": "0.698", "green": "0.780", "red": "0.208" }
      },
      "idiom": "universal"
    },
    {
      "appearances": [{ "appearance": "luminosity", "value": "dark" }],
      "color": {
        "color-space": "srgb",
        "components": { "alpha": "1.000", "blue": "0.698", "green": "0.780", "red": "0.208" }
      },
      "idiom": "universal"
    }
  ],
  "info": { "author": "xcode", "version": 1 }
}
```
The AccentColor.colorset from Phase 1 already uses this exact format — replicate it for every new color.

### Pattern 2: BlossomFont Caseless Enum (FOUND-05)
**What:** A caseless enum (pure namespace) with static computed properties returning `Font.custom("Inter-SemiBold", size: 28)` etc. One call site change in Info.plist to register fonts; one enum to update all sizes project-wide.
**When to use:** Every `.font()` modifier in the app — no `.font(.title)` system fonts, no inline `Font.custom()` calls in views.
**Example:**
```swift
// Core/Theme/BlossomFont.swift
enum BlossomFont {
    static var largeTitle: Font { Font.custom("Inter-SemiBold", size: 34) }
    static var headline:   Font { Font.custom("Inter-SemiBold", size: 17) }
    static var subhead:    Font { Font.custom("Inter-Medium",   size: 15) }
    static var body:       Font { Font.custom("Inter-Regular",  size: 17) }
    static var callout:    Font { Font.custom("Inter-Regular",  size: 16) }
    static var caption:    Font { Font.custom("Inter-Regular",  size: 12) }
}
// Usage: .font(BlossomFont.headline)
```
Inter .otf files go in BlossomHubs/ (adjacent to Assets.xcassets) and are added to the Copy Bundle Resources build phase via xcodeproj gem. Info.plist entry:
```xml
<key>UIAppFonts</key>
<array>
    <string>Inter-Regular.otf</string>
    <string>Inter-Medium.otf</string>
    <string>Inter-SemiBold.otf</string>
</array>
```
**Verification:** In BlossomHubsApp.init(), add: `print(UIFont.familyNames)` — "Inter" must appear.

### Pattern 3: BlossomCard ViewModifier (FOUND-04)
**What:** A ViewModifier that applies background, 1px border, 12px corner radius, and a 2pt shadow. Uses `@Environment(\.colorScheme)` to switch surface color and border color tokens.
**When to use:** Apply with `.modifier(BlossomCard())` or convenience `.blossomCard()` extension on View.
**Example:**
```swift
struct BlossomCard: ViewModifier {
    @Environment(\.colorScheme) var colorScheme

    func body(content: Content) -> some View {
        content
            .background(Color(colorScheme == .dark ? "BlossomCardSurface" : "BlossomCardSurface"))
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color("BlossomCardBorder"), lineWidth: 1)
            )
            .shadow(color: .black.opacity(0.06), radius: 4, x: 0, y: 2)
    }
}

extension View {
    func blossomCard() -> some View { modifier(BlossomCard()) }
}
```
The colorset BlossomCardSurface has light = #FFFFFF, dark = #2A2E38.
The colorset BlossomCardBorder has light = #E2E4E9, dark = #3A3E48.

### Pattern 4: @MainActor @Observable CommunityStore (FOUND-09)
**What:** A single class marked `@MainActor @Observable` holding `[Community]`. Injected at app level with `.environment(store)`. Feature views read it with `@Environment(CommunityStore.self)`.
**When to use:** All mock data access. No feature screen imports raw mock arrays.
**Example:**
```swift
// Models/CommunityStore.swift
@MainActor
@Observable
final class CommunityStore {
    var communities: [Community] = CommunityStore.makeMockData()

    static func makeMockData() -> [Community] {
        // returns array of 6 communities
    }
}

// BlossomHubsApp.swift — injection
@main
struct BlossomHubsApp: App {
    @State private var store = CommunityStore()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(store)
        }
    }
}

// Feature view — reading
struct HubsView: View {
    @Environment(CommunityStore.self) private var store
    // ...
}
```
**Note:** `.environment(store)` (not `.environmentObject`) — this is the Swift Observation / iOS 17+ API.

### Pattern 5: ButtonStyle Protocol (FOUND-04)
**What:** Custom `ButtonStyle` conformances for primary (Violet fill), secondary (Violet outline), and ghost (no background, teal text) variants. Match the real Blossom app screenshots.
**When to use:** All tappable buttons throughout the app — never raw `.background()` on a Button.
**Visual spec from screenshots:** Primary is rounded rectangle with Violet fill (#7361F7), white label, Semi-Bold weight. Secondary is Violet border, Violet text, clear background. Corner radius: 8px (brand spec from SKILL.md).

### Pattern 6: VerifiedBadge from App Screenshots (FOUND-04)
**What:** Teal shield with checkmark — as seen in profile-sample.png and close-up-profile-sample.png. The badge shows "Verified" text in teal alongside the shield symbol. Separate from the bolt badge on AvatarView.
**Visual spec from close-up-profile-sample.png:** Teal capsule/pill with shield.checkmark SF Symbol + "Verified" text in teal, small font, light teal background fill (tint of #35C7B2 at ~15% opacity).

### Pattern 7: xcodeproj Ruby Gem File Registration (CRITICAL)
**What:** Every new Swift file and every new asset group must be added to project.pbxproj using the xcodeproj gem. This is mandatory because Xcode is not installed in the execution environment.
**When to use:** After creating any new .swift file, .otf font file, or asset imageset/colorset directory.
**Pattern from Phase 1 (create_project.rb):**
```ruby
# Add a Swift source file
ref = group.new_file('relative/path/to/File.swift')
ref.last_known_file_type = 'sourcecode.swift'
target.source_build_phase.add_file_reference(ref)

# Add a font file to Copy Bundle Resources
font_ref = app_group.new_file('Inter-Regular.otf')
font_ref.last_known_file_type = 'file'
target.resources_build_phase.add_file_reference(font_ref)
```
**Critical:** The xcodeproj gem script must be run (not just the files written to disk) before any Swift compilation can succeed.

### Anti-Patterns to Avoid

- **Inline hex values in views:** Never `Color(hex: "#7361F7")` in a View body. Always `Color("BlossomViolet")` or `BlossomTheme.violet`. Phase 2 exists to eliminate this.
- **System font fallback:** Never `.font(.title)` or `.font(.body)` on any text that the user will see. Always `BlossomFont.headline` etc.
- **Raw mock arrays in feature views:** Never `let communities = [Community(...), ...]` inside a view. Always `@Environment(CommunityStore.self)`.
- **ObservableObject:** Never use `@Published` + `ObservableObject` for new classes. Swift 6 pattern is `@Observable`.
- **Files not registered in project.pbxproj:** Disk-only files compile as orphans. Every file written must be registered.
- **Color("name") before colorset exists:** Writing `Color("BlossomTeal")` in Swift before creating the `.colorset` directory produces a transparent color at runtime with no compile error. Create colorsets first.
- **Font name mismatch:** `Font.custom("Inter-Regular", ...)` will silently fall back to system font if the PostScript name doesn't exactly match the .otf file's internal name. Verify with: `UIFont(name: "Inter-Regular", size: 17) != nil`.

---

## Don't Hand-Roll

| Problem | Don't Build | Use Instead | Why |
|---------|-------------|-------------|-----|
| Light/dark color switching | if colorScheme == .dark { } else { } in every view | Asset Catalog colorsets | System resolves at render time; zero code in views; correct in previews too |
| Font size ramp | Per-view magic numbers | BlossomFont enum | Single source of truth; global size changes in one file |
| Card surface/border colors | Hardcoded hex in ViewModifier | BlossomCardSurface + BlossomCardBorder colorsets | Dark mode card gets correct elevated surface automatically |
| Mock data storage | File I/O, UserDefaults, Core Data | In-memory @Observable class | Prototype only needs synchronous in-memory data; no persistence complexity |
| Image asset registration | Manual Contents.json editing | Documented JSON structure (replicate nick-profile-pic.imageset pattern) | Consistent, proven format already working in the project |

**Key insight:** The Asset Catalog is the dark mode engine. All appearance adaptation must flow through it, not through runtime `colorScheme` checks in view code.

---

## Common Pitfalls

### Pitfall 1: Inter Font PostScript Name vs Filename
**What goes wrong:** `Font.custom("Inter-Regular", size: 17)` silently falls back to system font. No compile error. No runtime error. Just wrong font rendered.
**Why it happens:** Font.custom() takes the PostScript name embedded in the font file, not the filename. "Inter-Regular.otf" may have PostScript name "Inter" or "Inter-Regular" depending on version.
**How to avoid:** After adding fonts, add a debug assert in BlossomHubsApp.init():
```swift
assert(UIFont(name: "Inter-Regular", size: 17) != nil, "Inter-Regular font not loaded")
assert(UIFont(name: "Inter-Medium", size: 17) != nil, "Inter-Medium font not loaded")
assert(UIFont(name: "Inter-SemiBold", size: 17) != nil, "Inter-SemiBold font not loaded")
```
Also `print(UIFont.familyNames)` to confirm "Inter" appears.
**Warning signs:** All text renders slightly differently from the Figma/brand reference even after BlossomFont is applied.

### Pitfall 2: Font Files Missing from Copy Bundle Resources Build Phase
**What goes wrong:** .otf files are added to the Xcode project file group but NOT added to the Copy Bundle Resources build phase. UIAppFonts is set in Info.plist. The app builds and runs, but fonts don't load — falls back silently.
**Why it happens:** Forgetting to call `target.resources_build_phase.add_file_reference(font_ref)` when adding fonts via the xcodeproj gem. The gem requires explicit build phase assignment.
**How to avoid:** For each .otf file: create file reference AND add to resources_build_phase (same pattern as Assets.xcassets in create_project.rb).

### Pitfall 3: Color("name") Before Colorset Created
**What goes wrong:** `Color("BlossomBackground")` in refactored BlossomTheme.swift, but the colorset directory doesn't exist yet. Color resolves to transparent (clear) at runtime — no build error.
**Why it happens:** Asset Catalog name lookups are string-based; Xcode doesn't type-check them at build time.
**How to avoid:** Create ALL colorsets in Assets.xcassets BEFORE refactoring BlossomTheme.swift to use Color("name"). Wave order: colorsets first, theme refactor second.

### Pitfall 4: .environment() vs .environmentObject() API
**What goes wrong:** Using `.environmentObject(store)` for an `@Observable` class — compilation error or unexpected behavior in Swift 6.
**Why it happens:** @Observable (Swift Observation framework) uses `.environment()`, not `.environmentObject()`. ObservableObject used `.environmentObject()`. They are incompatible.
**How to avoid:** Always `.environment(store)` for @Observable classes. Always `@Environment(CommunityStore.self)` to read. The Phase 1 pattern for @Observable is already established.

### Pitfall 5: New Files Not Registered in project.pbxproj
**What goes wrong:** Swift files exist on disk but aren't compiled. No error on disk creation; build either ignores them or fails to find referenced types.
**Why it happens:** In Xcode, dragging a file into the navigator auto-registers it. In the script-based workflow, disk and project file are separate operations.
**How to avoid:** After each Wave, run a Ruby xcodeproj verification script to confirm all new .swift files appear in the target's source build phase.

### Pitfall 6: BlossomHubsApp Concurrency with CommunityStore
**What goes wrong:** `@State private var store = CommunityStore()` in BlossomHubsApp (a Scene-scoped struct) initializes on the main actor, which is correct. But if any property of CommunityStore is accessed from a background context, Swift 6 strict concurrency fires.
**Why it happens:** CommunityStore is @MainActor. Any access from a non-isolated context triggers a concurrency error.
**How to avoid:** CommunityStore must only return values synchronously. No async functions in CommunityStore for Phase 2. All data is static mock; no background processing needed.

### Pitfall 7: AvatarView Size Preset Enum and Existing Callers
**What goes wrong:** Adding a `SizePreset` enum to AvatarView changes the init signature. HubsTopNavBar.swift currently passes `size: 44` as a CGFloat. After refactor, it must use the preset.
**Why it happens:** Changing a struct's API while callers still use old parameter labels.
**How to avoid:** Keep `size: CGFloat` as the underlying parameter. Add a convenience `preset: AvatarSize` parameter that maps to a CGFloat. This preserves backward compatibility with HubsTopNavBar.swift which uses `size: 44`.

---

## Code Examples

Verified patterns from the existing codebase:

### Asset Colorset JSON Format (replicate AccentColor.colorset pattern)
```json
{
  "colors": [
    {
      "color": {
        "color-space": "srgb",
        "components": { "alpha": "1.000", "blue": "0.698", "green": "0.780", "red": "0.208" }
      },
      "idiom": "universal"
    },
    {
      "appearances": [{ "appearance": "luminosity", "value": "dark" }],
      "color": {
        "color-space": "srgb",
        "components": { "alpha": "1.000", "blue": "0.420", "green": "0.490", "red": "0.165" }
      },
      "idiom": "universal"
    }
  ],
  "info": { "author": "xcode", "version": 1 }
}
```
Note: sRGB components are decimal fractions (0.0–1.0), not 0–255. Convert hex to decimal: `#35C7B2` = R:0.208 G:0.780 B:0.698.

### Imageset JSON Format (replicate nick-profile-pic.imageset)
```json
{
  "images": [
    { "filename": "bd-profile-pic.png", "idiom": "universal", "scale": "1x" },
    { "idiom": "universal", "scale": "2x" },
    { "idiom": "universal", "scale": "3x" }
  ],
  "info": { "author": "xcode", "version": 1 }
}
```
Only the 1x slot needs a filename (actual file is full resolution). 2x and 3x slots remain empty — iOS uses the 1x file at all scales for portrait photos.

### xcodeproj Gem: Add Swift File to Existing Group
```ruby
require 'xcodeproj'
project = Xcodeproj::Project.open('BlossomHubs/BlossomHubs.xcodeproj')
target = project.targets.first

# Navigate to existing group (e.g., Core/Components)
app_group = project.main_group['BlossomHubs']
core_group = app_group['Core']
components_group = core_group['Components'] || core_group.new_group('Components', 'Components')

ref = components_group.new_file('Core/Components/BlossomCard.swift')
ref.last_known_file_type = 'sourcecode.swift'
target.source_build_phase.add_file_reference(ref)
project.save
```

### xcodeproj Gem: Add Font to Resources Phase
```ruby
font_ref = app_group.new_file('Inter-Regular.otf')
font_ref.last_known_file_type = 'file'
target.resources_build_phase.add_file_reference(font_ref)
```

### Swift Data Model Structures
```swift
// Models/Community.swift
struct Creator: Identifiable {
    let id: UUID
    let name: String
    let username: String
    let profileImageName: String  // Asset catalog image name
    let isVerified: Bool
    let isAmbassador: Bool
    let bio: String
}

struct Tier: Identifiable {
    let id: UUID
    let name: String
    let monthlyPrice: Decimal
    let benefits: [String]
}

struct Post: Identifiable {
    let id: UUID
    let authorId: UUID
    let content: String
    let stockTickers: [String]    // ["$AAPL", "$NVDA"]
    let requiredTierIndex: Int    // 0 = free preview, 1+ = gated
    let publishedAt: Date
}

struct ForumThread: Identifiable {
    let id: UUID
    let title: String
    let content: String
    let authorId: UUID
    let requiredTierIndex: Int
    let replyCount: Int
    let publishedAt: Date
}

struct FAQEntry: Identifiable {
    let id: UUID
    let question: String
    let answer: String?
    let isAnswered: Bool
}

struct Community: Identifiable {
    let id: UUID
    let name: String
    let description: String
    let creator: Creator
    let tiers: [Tier]
    let posts: [Post]
    let threads: [ForumThread]
    let faqEntries: [FAQEntry]
    let memberCount: Int
    let category: String
}
```

### BlossomTheme Refactor (after colorsets exist)
```swift
// Core/Theme/BlossomTheme.swift — AFTER Phase 2 colorsets created
enum BlossomTheme {
    // Brand accents — same in light and dark
    static let teal    = Color("BlossomTeal")
    static let violet  = Color("BlossomViolet")
    static let orange  = Color("BlossomOrange")

    // Semantic tokens — adapt between light/dark via colorset
    static let background      = Color("BlossomBackground")
    static let cardSurface     = Color("BlossomCardSurface")
    static let cardBorder      = Color("BlossomCardBorder")
    static let primaryText     = Color("BlossomPrimaryText")
    static let secondaryText   = Color("BlossomSecondaryText")

    // Legacy convenience (preserved for existing callers)
    static let darkNavy        = Color("BlossomDarkNavy")
    static let slate           = Color("BlossomSlate")

    // Tab bar (systemBackground still correct — auto-adapts)
    static let tabActive       = teal
    static let tabInactive     = Color(UIColor.systemGray3)
    static let tabBarBackground = Color(UIColor.systemBackground)
}
// Color(hex:) extension can be removed or retained for convenience
```

---

## Color Specification

### Colorsets Required

| Name | Light (sRGB hex) | Dark (sRGB hex) | Notes |
|------|-----------------|----------------|-------|
| BlossomTeal | #35C7B2 | #35C7B2 | Brand accent — identical both modes |
| BlossomViolet | #7361F7 | #7361F7 | Brand accent — identical both modes |
| BlossomOrange | #FF7833 | #FF7833 | Brand accent — identical both modes |
| BlossomDarkNavy | #1E222A | #1E222A | High-contrast text — same both modes |
| BlossomSlate | #565E76 | #565E76 | Body text on light — same both modes |
| BlossomBackground | #FFFFFF | #1E222A | Page background — white / dark navy |
| BlossomCardSurface | #FFFFFF | #2A2E38 | Card fill — white / elevated dark surface |
| BlossomCardBorder | #E2E4E9 | #3A3E48 | Card border — light gray / dark subtle border |
| BlossomPrimaryText | #1E222A | #FFFFFF | Headings — dark navy / white |
| BlossomSecondaryText | #565E76 | #8B92A8 | Body text — slate / muted blue-gray |

**Note on BlossomSecondaryText dark value (#8B92A8):** This is Claude's discretion — a mid-tone blue-gray that passes 4.5:1 contrast against #2A2E38 card surface. Can be adjusted if contrast fails.

### Hex to sRGB Component Conversion
Divide each hex channel by 255:
- #35C7B2 → R: 53/255=0.208, G: 199/255=0.780, B: 178/255=0.698
- #7361F7 → R: 115/255=0.451, G: 97/255=0.380, B: 247/255=0.969
- #FF7833 → R: 255/255=1.000, G: 120/255=0.471, B: 51/255=0.200
- #1E222A → R: 30/255=0.118, G: 34/255=0.133, B: 42/255=0.165
- #565E76 → R: 86/255=0.337, G: 94/255=0.369, B: 118/255=0.463
- #E2E4E9 → R: 226/255=0.886, G: 228/255=0.894, B: 233/255=0.914
- #2A2E38 → R: 42/255=0.165, G: 46/255=0.180, B: 56/255=0.220
- #3A3E48 → R: 58/255=0.227, G: 62/255=0.243, B: 72/255=0.282

---

## BlossomFont Recommended Point Sizes

These are Claude's discretion, derived from the brand type scale (SKILL.md) and iOS HIG conventions:

| Property | Font | Size | iOS HIG Equivalent | Use |
|----------|------|------|-------------------|-----|
| .largeTitle | Inter-SemiBold | 34 | largeTitle | Screen titles |
| .title | Inter-SemiBold | 28 | title | Section titles |
| .headline | Inter-SemiBold | 17 | headline | Card titles, list headers |
| .subhead | Inter-Medium | 15 | subheadline | Secondary headers, labels |
| .body | Inter-Regular | 17 | body | Post content, descriptions |
| .callout | Inter-Regular | 16 | callout | Supporting text |
| .caption | Inter-Regular | 12 | caption2 | Timestamps, fine print |
| .buttonLabel | Inter-Medium | 16 | — | Button labels (Medium weight) |

---

## Mock Data Design

### 6 Ambassador Communities (Claude's Discretion for specifics)

| Ambassador | Profile Image | Community Name | Tier Count | Content Focus |
|-----------|--------------|---------------|-----------|--------------|
| Nick | nick-profile-pic (exists) | Wealthmatica | 3 | Canadian stocks, dividend investing, market commentary |
| BD | BD-profile-pic | BD Investing | 2 | Growth stocks, tech analysis ($NVDA, $MSFT) |
| Brandon | brandon-profile-pic | Brandon's Alpha | 3 | Options strategies, swing trades ($AAPL, $TSLA) |
| Max | max-profile-pic | Max Markets | 2 | Index funds, passive investing, portfolio reviews |
| Moe | Moe-profile-pic | Moe's Watchlist | 4 | Momentum trading, small-cap alerts |
| Canadian in a T-shirt | Canadia in a T-shirt-proflie-pic | Canadian Investor | 3 | TFSA/RRSP strategies, TSX stocks |

**Minimum data per community:** 4-6 posts, 3-5 forum threads, 3-4 FAQ entries, 2-4 tiers with benefit descriptions, 50-500 member count.

### Tier Naming Patterns (authentic investing community feel)
- Tier 1 (Free preview / basic): "Free", "Observer", "Basic"
- Tier 2 (Mid): "Member", "Investor", "Core"
- Tier 3 (Premium): "Premium", "Analyst", "Pro"
- Tier 4 (Top): "VIP", "Elite", "Mentor Circle"
- Prices: $5-$9/mo (basic), $15-$25/mo (mid), $40-$75/mo (premium), $100+/mo (VIP)

---

## State of the Art

| Old Approach | Current Approach | When Changed | Impact |
|--------------|------------------|--------------|--------|
| ObservableObject + @Published | @Observable (Swift Observation) | Swift 5.9 / iOS 17, adopted in project Phase 1 | @Observable is the project standard; ObservableObject is legacy direction |
| .environmentObject() | .environment() | Swift Observation API | @Observable classes use .environment(), not .environmentObject() |
| Asset catalog light-only | Light + dark appearance entries in colorset | Always supported; just not done in Phase 1 | Full dark mode with zero code in views |
| Font.custom() inline in views | BlossomFont enum (this phase) | Pattern established in Phase 2 | Single source of truth for all font sizes and weights |

**Deprecated/outdated in this project:**
- `Color(hex:)` extension: Can be retained for utility but should not be used in feature views after Phase 2
- `.font(.title)` system fonts: Must be replaced with `BlossomFont.*` in all retrofitted Phase 1 views
- `ObservableObject` / `@Published`: Do not introduce for CommunityStore

---

## Open Questions

1. **Inter .otf PostScript names**
   - What we know: Font.custom() requires the internal PostScript name, not the filename
   - What's unclear: Whether the Inter .otf files the user has locally use PostScript names "Inter-Regular", "Inter-Medium", "Inter-SemiBold" or some variation (e.g., "Inter Regular")
   - Recommendation: In Wave 1 (font registration task), add a verification print immediately and confirm before building BlossomFont enum. If the name differs, adjust the enum.

2. **preferredColorScheme(.light) in BlossomHubsApp**
   - What we know: BlossomHubsApp.swift currently has `.preferredColorScheme(.light)` — dark mode is locked off for demo
   - What's unclear: Whether Phase 2 should remove this (to enable dark mode testing) or keep it locked and only test dark mode via Xcode Preview
   - Recommendation: Remove `.preferredColorScheme(.light)` during Phase 2 to enable real dark mode testing, then restore for demo delivery if needed. Dark mode colorsets are meaningless if the app never shows dark UI.

3. **Canadian in a T-shirt filename**
   - What we know: File is `profiles-demos/Canadia in a T-shirt-proflie-pic.png` (note: "Canadia" not "Canada", "proflie" not "profile" — these are the actual filenames)
   - What's unclear: Nothing — this is the actual file, typos included
   - Recommendation: Create imageset named `canada-tshirt-profile-pic` in Assets.xcassets (clean asset name), copy the file in as the 1x image.

---

## Validation Architecture

### Test Framework
| Property | Value |
|----------|-------|
| Framework | None detected — no test target in BlossomHubs.xcodeproj yet |
| Config file | None — see Wave 0 |
| Quick run command | Manual: build in Xcode (Cmd+B), inspect in Simulator |
| Full suite command | Manual visual validation checklist |

**Note:** The project has no automated test target (FOUND-07 requires @MainActor compliance which is verified by Swift 6 strict concurrency, not unit tests). Phase 2 validation is structural (build succeeds, colorsets resolve, fonts load) and visual (dark mode adapts, Inter renders, assets display).

### Phase Requirements → Test Map

| Req ID | Behavior | Test Type | Automated Command | File Exists? |
|--------|----------|-----------|-------------------|-------------|
| FOUND-04 | Design system components exist and compile | build | `xcodebuild build` | ❌ Wave 0 (no test target) |
| FOUND-05 | Inter font loads — UIFont.familyNames contains "Inter" | debug assertion | assert in App.init() | ❌ Wave 0 |
| FOUND-06 | Dark mode adapts — no white-on-white in dark mode | visual | Simulator dark mode toggle | manual-only |
| FOUND-09 | CommunityStore.communities has 6 entries with tiers/posts | debug assertion | assert in App.init() | ❌ Wave 0 |
| FOUND-10 | Profile photos render without placeholder | visual | Simulator + Image("name") load | manual-only |
| FOUND-11 | Logo images render without placeholder | visual | Simulator + Image("name") load | manual-only |

### Sampling Rate
- **Per task commit:** Build must succeed (zero Swift 6 concurrency errors, zero undefined symbol errors)
- **Per wave:** Manual Simulator run — verify dark mode toggle, font rendering, asset images
- **Phase gate:** All 6 success criteria from the phase description confirmed before `/gsd:verify-work`

### Wave 0 Gaps
- [ ] `BlossomHubs/App/BlossomHubsApp.swift` — add font load assertions and CommunityStore data count assertions in `init()` (debug only, `#if DEBUG`)
- [ ] No formal XCTest target needed — project validates via Swift 6 strict concurrency (compiler is the test)

*(Formal test target creation is deferred — the strict concurrency compiler enforcement + visual Simulator validation is sufficient for this prototype phase)*

---

## Sources

### Primary (HIGH confidence)
- Direct inspection of existing source files: BlossomTheme.swift, AvatarView.swift, BlossomHubsApp.swift, ContentView.swift, create_project.rb — all patterns verified from actual code
- Direct inspection of Assets.xcassets/AccentColor.colorset/Contents.json — exact colorset JSON format confirmed
- Direct inspection of Assets.xcassets/nick-profile-pic.imageset/Contents.json — exact imageset JSON format confirmed
- brand-guidlines/SKILL.md — brand colors, typography, spacing, component specs all primary source
- Direct visual inspection of brand-guidlines/app-screenshots/profile-sample.png, close-up-profile-sample.png — VerifiedBadge appearance confirmed
- Direct inspection of profiles-demos/ directory — all 6 ambassador photo filenames confirmed
- Direct inspection of brand-guidlines/logos/ — all 3 logo filenames confirmed

### Secondary (MEDIUM confidence)
- Apple Swift Observation documentation (knowledge cutoff Aug 2025): @Observable, .environment(), @Environment(Type.self) API confirmed as the Swift 6 standard
- Apple UIFont documentation: UIAppFonts Info.plist key, Font.custom() PostScript name requirement

### Tertiary (LOW confidence)
- BlossomSecondaryText dark hex (#8B92A8): Claude's discretion — derived from brand slate (#565E76) lightened for dark background; needs contrast ratio verification at 4.5:1 against #2A2E38

---

## Metadata

**Confidence breakdown:**
- Standard stack: HIGH — all established from Phase 1 codebase, Apple-native APIs only
- Architecture: HIGH — patterns directly observable in existing files, extended conservatively
- Color specifications: HIGH — all brand colors from SKILL.md; dark surface/border from CONTEXT.md locked decisions
- Font point sizes: MEDIUM — derived from brand type scale + iOS HIG conventions; Claude's discretion
- Mock data content: MEDIUM — Claude's discretion for specifics; structure dictated by requirements
- Pitfalls: HIGH — all derived from direct code inspection of Phase 1 and known SwiftUI font/color loading behavior

**Research date:** 2026-03-11
**Valid until:** 2026-06-11 (stable Apple APIs; font loading behavior doesn't change)
