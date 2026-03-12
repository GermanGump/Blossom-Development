# Phase 4: Subscription Flow and Celebration - Research

**Researched:** 2026-03-12
**Domain:** SwiftUI payment UI, particle animation, subscription state management, haptic feedback
**Confidence:** HIGH

## Summary

Phase 4 transforms the existing tier browsing experience into a full subscription flow: mock Stripe payment sheet, payment state machine, confetti celebration, and subscription lifecycle management (upgrade/downgrade/cancel). The codebase already has all the foundation pieces in place -- TierCardView with a wired `// Phase 4 wires this` placeholder, TiersBottomSheet with accordion expansion, CommunityPreviewView with `.sheet` presentation, and BlossomTheme color tokens for confetti colors (violet, orange, teal).

The primary technical challenges are: (1) building a Canvas + TimelineView confetti burst animation that fires once and cleans up (STATE.md flagged this as MEDIUM confidence), (2) creating a UserSession/SubscriptionStore that persists across restarts via UserDefaults/AppStorage with a debug reset toggle, and (3) stacking a payment sheet on top of the existing tier sheet without dismissal conflicts. All of these are achievable with native SwiftUI -- no third-party libraries are needed beyond what is already integrated.

**Primary recommendation:** Build the confetti animation as a standalone reusable view first (STATE.md explicitly recommends this), then integrate it into the payment success flow. Use a separate `SubscriptionStore` (not extending CommunityStore) to hold subscription state, injected via `.environment()` alongside the existing CommunityStore.

<user_constraints>
## User Constraints (from CONTEXT.md)

### Locked Decisions
- Stripe-accurate design -- closely mimics Stripe's actual checkout sheet styling (dark input fields, card brand icon, "Powered by Stripe" with logo)
- Visual validation on card input -- auto-format card number with spaces, show card brand icon (Visa/MC), validate MM/YY range -- but payment always succeeds regardless of input
- Full tier summary shown above card fields -- tier name, price, and benefit list so user sees what they're paying for
- Stripe logo + "Powered by Stripe" text at bottom of sheet
- Presented as a stacked sheet on top of the existing tier bottom sheet -- both sheets visible
- Once "Pay" is tapped, no cancel -- spinner runs to completion, always succeeds
- No error/decline flow -- every payment succeeds in the demo
- After tapping Pay, button becomes a spinner with "Processing..." text
- Runs for 1-2 seconds, then transitions to success
- No cancel possible during processing
- Confetti bursts outward from center where Blossom logo is displayed
- Blossom brand colors for confetti pieces (violet, orange, teal)
- "Welcome to [Community Name]!" text below the centered logo
- Tap to continue -- "Continue" or "Enter Community" button appears after confetti burst
- Not auto-dismissing -- user controls when they proceed
- Haptic feedback on confetti burst moment
- After tapping "Continue" on confetti screen, user returns to discovery screen
- Subscribed community card shows a "Subscribed" badge on the discovery screen
- Phase 5 later adds the real community landing page as the destination
- Haptic feedback at key moments: payment success, confetti burst, button taps
- "View Tiers" CTA becomes "Your Subscription" after subscribing
- Same sheet shows current tier highlighted with "Current Plan" label
- Other tiers show "Upgrade" or "Downgrade" buttons
- Upgrade/downgrade triggers a simple alert dialog: "Upgrade to [Tier] for $X/mo?" with Confirm/Cancel
- Quick actions in tier sheet (upgrade/downgrade) + separate "My Subscriptions" screen for full management
- Cancel flow uses a retention bottom sheet -- asks why they're leaving (too expensive, not enough content, etc.) before confirming cancellation
- After canceling, user returns to the community preview page in its pre-subscribed state with "View Tiers" CTA restored
- Subscriptions persist across app restarts (resettable) -- a hidden debug toggle can reset all subscriptions for demo purposes
- Multiple simultaneous subscriptions supported -- user can subscribe to BD, Brandon, Max, etc. each at their own tier (matches Patreon)
- Mock logged-in user -- pre-set user (e.g., "Alex") with profile photo, subscription map, join dates -- makes the demo feel lived-in

### Claude's Discretion
- Exact confetti particle count, size, physics, and animation duration
- Spinner animation implementation details
- Card brand detection logic (first digits)
- "My Subscriptions" screen location in navigation hierarchy
- UserStore vs CommunityStore extension decision
- Stripe sheet exact color values and field styling
- Haptic intensity and pattern choices
- Mock user profile details (name, avatar, etc.)
- Debug reset toggle location and presentation

### Deferred Ideas (OUT OF SCOPE)
None -- discussion stayed within phase scope
</user_constraints>

<phase_requirements>
## Phase Requirements

| ID | Description | Research Support |
|----|-------------|-----------------|
| SUBS-04 | Mocked Stripe payment screen (card number, expiry, CVC fields) presented as a sheet -- no real processing | Mock payment sheet architecture, card formatting patterns, stacked sheet presentation |
| SUBS-05 | Payment validation simulation (brief loading state, then success) | Payment state machine pattern, ProgressView spinner, Task.sleep for delay simulation |
| SUBS-06 | Confetti celebration animation with Blossom logo centered on screen upon successful subscription | Canvas + TimelineView confetti burst, haptic feedback integration, one-shot animation cleanup |
| SUBS-07 | After celebration, user transitions into the subscribed community landing page | Navigation flow (returns to discovery with badge for now; Phase 5 adds real landing page) |
| SUBS-08 | Subscription management: user can upgrade tier, downgrade tier, or cancel subscription in-app | SubscriptionStore architecture, tier sheet dual-mode, retention sheet, alert dialogs |
</phase_requirements>

## Standard Stack

### Core
| Library | Version | Purpose | Why Standard |
|---------|---------|---------|--------------|
| SwiftUI (native) | iOS 26 | All UI -- sheets, Canvas, TimelineView, animations | Project standard -- no third-party UI libraries except ComponentsKit |
| Foundation | iOS 26 | UserDefaults, JSONEncoder/Decoder for subscription persistence | Native persistence, no external dependencies |
| UIKit (UINotificationFeedbackGenerator) | iOS 26 | Haptic feedback at payment success and confetti burst | Standard iOS haptic API, or use .sensoryFeedback modifier (iOS 17+) |

### Supporting
| Library | Version | Purpose | When to Use |
|---------|---------|---------|-------------|
| ComponentsKit (already integrated) | SPM | Only if any Stripe-like styling components exist there | Check before building custom -- likely not needed for this phase |

### Alternatives Considered
| Instead of | Could Use | Tradeoff |
|------------|-----------|----------|
| Hand-rolled confetti | ConfettiSwiftUI package | Third-party dependency violates project rule (ComponentsKit only). Hand-roll with Canvas + TimelineView instead |
| Hand-rolled confetti | Vortex particle system | Same third-party concern. Overkill for a one-shot burst |
| @AppStorage raw | SwiftData | Too heavy for simple subscription map. UserDefaults via Codable is sufficient |

**No additional packages required.** Everything is achievable with native SwiftUI + Foundation.

## Architecture Patterns

### Recommended Project Structure
```
BlossomHubs/
├── Models/
│   ├── Community.swift              (existing -- no changes)
│   ├── CommunityStore.swift         (existing -- no changes)
│   ├── Subscription.swift           (NEW -- Subscription model + UserSession)
│   └── SubscriptionStore.swift      (NEW -- @MainActor @Observable, persists via UserDefaults)
├── Features/Hubs/
│   ├── Payment/
│   │   ├── MockPaymentSheetView.swift    (NEW -- Stripe-styled payment form)
│   │   ├── PaymentViewModel.swift        (NEW -- state machine: idle -> processing -> success)
│   │   └── ConfettiCelebrationView.swift (NEW -- Canvas confetti + Blossom logo + CTA)
│   ├── Subscription/
│   │   ├── MySubscriptionsView.swift     (NEW -- full subscription management list)
│   │   └── CancelRetentionSheet.swift    (NEW -- retention bottom sheet)
│   ├── Preview/
│   │   ├── TierCardView.swift            (MODIFY -- wire Subscribe button, add upgrade/downgrade/current plan states)
│   │   ├── TiersBottomSheet.swift        (MODIFY -- dual-mode: browse vs manage, pass subscription context)
│   │   ├── CommunityPreviewView.swift    (MODIFY -- CTA changes based on subscription state, present payment sheet)
│   │   └── CommunityPreviewViewModel.swift (MODIFY -- subscription awareness)
│   ├── Discovery/
│   │   ├── CommunityCardView.swift       (MODIFY -- add "Subscribed" badge)
│   │   └── CommunityHeroCardView.swift   (MODIFY -- add "Subscribed" badge)
│   └── HubsNavigation.swift             (MODIFY -- add routes for MySubscriptions)
├── App/
│   ├── BlossomHubsApp.swift              (MODIFY -- create and inject SubscriptionStore)
│   └── ContentView.swift                 (MODIFY -- inject SubscriptionStore into environment)
└── Core/Components/
    └── TagView.swift                     (MODIFY -- add .subscribed TagStyle)
```

### Pattern 1: SubscriptionStore with UserDefaults Persistence
**What:** A separate `@MainActor @Observable` class holding a `[UUID: Subscription]` dictionary mapping community IDs to active subscriptions. Persisted as JSON in UserDefaults.
**When to use:** Subscription state is cross-cutting -- needed by discovery cards, preview pages, tier sheets, and management screens.
**Why separate from CommunityStore:** CommunityStore holds immutable mock data (communities, tiers, posts). SubscriptionStore holds mutable user state (what the user has subscribed to). Different concerns, different lifecycles.

```swift
// Models/Subscription.swift
import Foundation

struct Subscription: Codable, Identifiable {
    let id: UUID
    let communityID: UUID
    let tierID: UUID
    let tierName: String
    let monthlyPrice: Decimal
    let subscribedAt: Date

    init(id: UUID = UUID(), communityID: UUID, tierID: UUID,
         tierName: String, monthlyPrice: Decimal, subscribedAt: Date = .now) {
        self.id = id
        self.communityID = communityID
        self.tierID = tierID
        self.tierName = tierName
        self.monthlyPrice = monthlyPrice
        self.subscribedAt = subscribedAt
    }
}

struct UserSession: Codable {
    let name: String
    let username: String
    let profileImageName: String
    var subscriptions: [UUID: Subscription] // keyed by communityID
}
```

```swift
// Models/SubscriptionStore.swift
import Foundation

@MainActor
@Observable
final class SubscriptionStore {
    var session: UserSession

    private static let storageKey = "blossom_user_session"

    init() {
        if let data = UserDefaults.standard.data(forKey: Self.storageKey),
           let saved = try? JSONDecoder().decode(UserSession.self, from: data) {
            self.session = saved
        } else {
            self.session = UserSession(
                name: "Alex",
                username: "@alex_investor",
                profileImageName: "alex-profile",
                subscriptions: [:]
            )
        }
    }

    func subscribe(to community: Community, tier: Tier) {
        let sub = Subscription(
            communityID: community.id,
            tierID: tier.id,
            tierName: tier.name,
            monthlyPrice: tier.monthlyPrice
        )
        session.subscriptions[community.id] = sub
        persist()
    }

    func changeTier(for communityID: UUID, to tier: Tier) {
        guard var sub = session.subscriptions[communityID] else { return }
        // Create new subscription with updated tier
        session.subscriptions[communityID] = Subscription(
            communityID: communityID,
            tierID: tier.id,
            tierName: tier.name,
            monthlyPrice: tier.monthlyPrice,
            subscribedAt: sub.subscribedAt
        )
        persist()
    }

    func cancel(communityID: UUID) {
        session.subscriptions.removeValue(forKey: communityID)
        persist()
    }

    func isSubscribed(to communityID: UUID) -> Bool {
        session.subscriptions[communityID] != nil
    }

    func currentTier(for communityID: UUID) -> UUID? {
        session.subscriptions[communityID]?.tierID
    }

    #if DEBUG
    func resetAll() {
        session.subscriptions = [:]
        persist()
    }
    #endif

    private func persist() {
        if let data = try? JSONEncoder().encode(session) {
            UserDefaults.standard.set(data, forKey: Self.storageKey)
        }
    }
}
```

### Pattern 2: Payment State Machine
**What:** An enum-driven state machine in PaymentViewModel that guarantees no stuck spinner.
**When to use:** Any multi-step async flow (idle -> processing -> success -> dismissed).

```swift
enum PaymentState: Equatable {
    case idle
    case processing
    case success
}

@MainActor
@Observable
final class PaymentViewModel {
    var state: PaymentState = .idle
    let community: Community
    let tier: Tier

    init(community: Community, tier: Tier) {
        self.community = community
        self.tier = tier
    }

    func submitPayment() async {
        state = .processing
        // Simulate 1-2 second processing
        try? await Task.sleep(for: .seconds(Double.random(in: 1.0...2.0)))
        state = .success
    }
}
```

### Pattern 3: Canvas + TimelineView Confetti Burst
**What:** A one-shot particle system using Canvas for efficient rendering and TimelineView for animation timing. Particles burst outward from center with gravity, spin, and fade.
**When to use:** The celebration screen after payment success.

```swift
struct ConfettiParticle: Identifiable {
    let id = UUID()
    var x: CGFloat          // position
    var y: CGFloat
    var velocityX: CGFloat  // initial burst velocity
    var velocityY: CGFloat
    var rotation: Double
    var rotationSpeed: Double
    var scale: CGFloat
    var opacity: Double
    var color: Color
    var shape: ConfettiShape

    enum ConfettiShape: CaseIterable {
        case circle, rectangle, strip
    }
}

struct ConfettiView: View {
    @State private var particles: [ConfettiParticle] = []
    @State private var startTime: Date?
    let colors: [Color] = [BlossomTheme.violet, BlossomTheme.orange, BlossomTheme.teal]

    var body: some View {
        TimelineView(.animation) { timeline in
            Canvas { context, size in
                let elapsed = startTime.map { timeline.date.timeIntervalSince($0) } ?? 0
                let gravity: CGFloat = 800

                for particle in particles {
                    let t = CGFloat(elapsed)
                    let x = size.width / 2 + particle.x + particle.velocityX * t
                    let y = size.height / 2 + particle.y + particle.velocityY * t + 0.5 * gravity * t * t
                    let opacity = max(0, particle.opacity - elapsed * 0.4)

                    guard opacity > 0 else { continue }

                    var contextCopy = context
                    contextCopy.opacity = opacity
                    contextCopy.translateBy(x: x, y: y)
                    contextCopy.rotate(by: .degrees(particle.rotation + particle.rotationSpeed * elapsed))

                    let rect = CGRect(x: -4, y: -4, width: 8, height: 8)
                    contextCopy.fill(Path(ellipseIn: rect), with: .color(particle.color))
                }
            }
        }
        .onAppear {
            spawnParticles()
            startTime = .now
        }
        .allowsHitTesting(false) // pass-through taps to content below
    }

    private func spawnParticles() {
        // ~80-120 particles for a satisfying burst
        particles = (0..<100).map { _ in
            let angle = Double.random(in: 0...(2 * .pi))
            let speed = CGFloat.random(in: 200...600)
            return ConfettiParticle(
                x: 0, y: 0,
                velocityX: cos(angle) * speed,
                velocityY: sin(angle) * speed - 300, // bias upward
                rotation: Double.random(in: 0...360),
                rotationSpeed: Double.random(in: -360...360),
                scale: CGFloat.random(in: 0.5...1.5),
                opacity: 1.0,
                color: colors.randomElement()!,
                shape: ConfettiParticle.ConfettiShape.allCases.randomElement()!
            )
        }
    }
}
```

### Pattern 4: Stacked Sheet Presentation
**What:** Payment sheet presented from within the TiersBottomSheet using a nested `.sheet()` modifier. Both sheets remain visible (stacked).
**When to use:** The CONTEXT.md specifies "presented as a stacked sheet on top of the existing tier bottom sheet."

```swift
// Inside TiersBottomSheet or TierCardView, when Subscribe is tapped:
.sheet(item: $selectedTierForPayment) { tier in
    MockPaymentSheetView(community: community, tier: tier)
        .presentationDetents([.large])
        .presentationDragIndicator(.visible)
        .interactiveDismissDisabled() // no swipe dismiss during payment
}
```

**Important:** iOS supports nested sheet presentation natively. The parent sheet stays visible behind the child sheet. No workaround needed.

### Pattern 5: Haptic Feedback
**What:** Use `.sensoryFeedback()` modifier (iOS 17+) for declarative haptics, falling back to UINotificationFeedbackGenerator for programmatic triggers.
**When to use:** Payment success, confetti burst, button taps.

```swift
// Declarative (preferred for SwiftUI):
.sensoryFeedback(.success, trigger: paymentState) { old, new in
    new == .success
}

// Programmatic (for confetti burst timing):
let generator = UINotificationFeedbackGenerator()
generator.prepare()
generator.notificationOccurred(.success)
```

### Anti-Patterns to Avoid
- **Mutating CommunityStore for subscription state:** CommunityStore is immutable mock data. Subscription state is mutable user state. Mixing them creates tight coupling and makes the debug reset toggle messy.
- **Using fullScreenCover for confetti:** The celebration should be a full-screen view presented modally, but `fullScreenCover` conflicts with the existing sheet stack. Use a ZStack overlay or navigation push instead.
- **Re-triggering confetti on navigation:** The confetti view must fire once and not re-trigger when the user navigates back. Use a `@State` flag that is set to true after the animation completes and checked before spawning.
- **Permanent spinner:** The PaymentState enum makes it impossible to get stuck -- the state machine always transitions from `.processing` to `.success` after the delay.

## Don't Hand-Roll

| Problem | Don't Build | Use Instead | Why |
|---------|-------------|-------------|-----|
| Card number formatting | Custom string parser | Simple function that inserts space every 4 digits after stripping non-digits | Only need visual formatting, not real validation |
| Card brand detection | Full BIN database lookup | First-digit check: 4=Visa, 5=Mastercard, 3=Amex | Demo only needs 2-3 brands, not production-grade detection |
| Confetti physics engine | Full physics simulation | Canvas with simple gravity + initial velocity + opacity fade | A handful of equations covers burst + fall + fade |
| Persistence framework | Core Data / SwiftData | UserDefaults with JSONEncoder/Decoder | Subscription map is tiny (max 6 communities), JSON is sufficient |

**Key insight:** This is a demo app. Every "payment" succeeds, every "card" is fake. The visual fidelity matters (Stripe look), but the logic should be simple.

## Common Pitfalls

### Pitfall 1: Sheet Dismissal Cascade
**What goes wrong:** Dismissing the payment sheet also dismisses the tier sheet underneath, leaving the user stranded.
**Why it happens:** SwiftUI's nested sheet dismissal can cascade if `.dismiss()` is called on the wrong environment.
**How to avoid:** Use `@Binding` or callback closures to control dismissal explicitly. When payment succeeds, dismiss the payment sheet first, then after the confetti flow completes, dismiss the tier sheet. Use `interactiveDismissDisabled()` on the payment sheet during processing.
**Warning signs:** User taps "Pay", both sheets disappear simultaneously.

### Pitfall 2: Confetti Re-triggering on Navigation
**What goes wrong:** Confetti animation replays every time the user navigates back to a screen.
**Why it happens:** SwiftUI recreates views on navigation, and `.onAppear` fires again.
**How to avoid:** Track `hasCelebrated` as a `@State` bool in the parent view that presents the celebration. Once the user taps "Continue", set it to true and never show confetti again for that session.
**Warning signs:** Confetti plays when swiping back or when a sheet re-appears.

### Pitfall 3: @AppStorage for Complex Types
**What goes wrong:** Trying to use `@AppStorage` directly with a Codable struct fails at compile time.
**Why it happens:** @AppStorage only supports primitive types (Bool, Int, Double, String, URL, Data) natively.
**How to avoid:** Use UserDefaults directly with JSONEncoder/JSONDecoder in the SubscriptionStore. The store is `@Observable`, so SwiftUI views update automatically when properties change. No need for @AppStorage.
**Warning signs:** Compile errors about RawRepresentable conformance.

### Pitfall 4: Decimal Codable Precision
**What goes wrong:** Decimal values lose precision during JSON encode/decode round-trips.
**Why it happens:** JSONEncoder encodes Decimal as a number, which can lose precision.
**How to avoid:** For demo purposes this is negligible (prices are whole numbers or simple decimals). If needed, encode as String. But this is LOW risk for this use case.
**Warning signs:** $19.00 becomes $18.99999999.

### Pitfall 5: Canvas Performance with Many Particles
**What goes wrong:** Confetti animation stutters on older devices with too many particles.
**Why it happens:** Canvas redraws every frame, and 500+ particles with complex shapes can lag.
**How to avoid:** Keep particle count at 80-120. Use simple shapes (circles, rectangles). Remove particles once opacity reaches 0. The animation only runs for 2-3 seconds.
**Warning signs:** Frame drops visible on iPhone SE or older simulators.

### Pitfall 6: Environment Injection Order
**What goes wrong:** SubscriptionStore is not available when views try to access it.
**Why it happens:** The new SubscriptionStore must be injected at the same level as CommunityStore in BlossomHubsApp.
**How to avoid:** Add `@State private var subscriptionStore = SubscriptionStore()` in BlossomHubsApp and chain `.environment(subscriptionStore)` alongside `.environment(store)`.
**Warning signs:** Runtime crash: "No observable object of type SubscriptionStore found."

## Code Examples

### Card Number Formatting
```swift
// Simple card number formatter -- demo quality
func formatCardNumber(_ input: String) -> String {
    let digits = input.filter(\.isNumber).prefix(16)
    var result = ""
    for (index, char) in digits.enumerated() {
        if index > 0 && index % 4 == 0 { result += " " }
        result.append(char)
    }
    return result
}

// Card brand detection from first digit
func cardBrand(for number: String) -> String? {
    guard let first = number.filter(\.isNumber).first else { return nil }
    switch first {
    case "4": return "visa"
    case "5": return "mastercard"
    case "3": return "amex"
    default: return nil
    }
}
```

### Expiry Validation (Visual Only)
```swift
func formatExpiry(_ input: String) -> String {
    let digits = input.filter(\.isNumber).prefix(4)
    if digits.count > 2 {
        return String(digits.prefix(2)) + "/" + String(digits.dropFirst(2))
    }
    return String(digits)
}
```

### Stacked Sheet with Payment Flow
```swift
// In TierCardView, replace the placeholder:
Button("Subscribe") {
    onSubscribe(tier)  // callback to parent
}
.buttonStyle(BlossomPrimaryButton())

// In TiersBottomSheet or CommunityPreviewView:
.sheet(item: $tierForPayment) { tier in
    MockPaymentSheetView(
        community: community,
        tier: tier,
        onSuccess: { handlePaymentSuccess() }
    )
    .presentationDetents([.large])
    .interactiveDismissDisabled(viewModel.isProcessing)
}
```

### TagStyle Extension for Subscribed Badge
```swift
// Extend existing TagStyle enum:
enum TagStyle {
    case stock
    case tier
    case category
    case subscribed  // NEW

    var foregroundColor: Color {
        switch self {
        // ... existing cases ...
        case .subscribed: return .white
        }
    }

    var backgroundColor: Color {
        switch self {
        // ... existing cases ...
        case .subscribed: return BlossomTheme.teal
        }
    }
}
```

### Debug Reset Toggle
```swift
// Hidden in "My Subscriptions" screen or long-press on profile
#if DEBUG
Button("Reset All Subscriptions") {
    subscriptionStore.resetAll()
}
.buttonStyle(BlossomGhostButton())
.foregroundStyle(.red)
#endif
```

## State of the Art

| Old Approach | Current Approach | When Changed | Impact |
|--------------|------------------|--------------|--------|
| UIFeedbackGenerator programmatic calls | `.sensoryFeedback()` SwiftUI modifier | iOS 17 (2023) | Declarative haptics, cleaner code |
| Timer-based animation | TimelineView + Canvas | iOS 15 (2021) | GPU-accelerated particle rendering |
| @AppStorage with RawRepresentable hacks | UserDefaults + @Observable | iOS 17 (2023) | @Observable eliminates need for property wrapper gymnastics |
| NavigationLink(destination:) | NavigationLink(value:) + navigationDestination | iOS 16 (2022) | Already adopted in project |

**Deprecated/outdated:**
- `UIApplication.shared.windows` -- project already uses `connectedScenes` (Phase 1 decision)
- `ObservableObject` + `@Published` -- project uses `@Observable` macro throughout

## Open Questions

1. **Confetti burst vs. rain direction**
   - What we know: CONTEXT.md says "bursts outward from center, not rain from top"
   - What's unclear: Exact particle lifetime, when to stop the TimelineView animation loop
   - Recommendation: 2.5-3 second animation, particles fade to 0 opacity, TimelineView stops rendering when all particles are invisible. Build and iterate.

2. **"My Subscriptions" navigation location**
   - What we know: Needs a dedicated screen for full subscription management
   - What's unclear: Where in the nav hierarchy -- HubsRoute case? Profile section?
   - Recommendation: Add `HubsRoute.mySubscriptions` and access it from the Hubs top nav bar (user avatar or gear icon). This keeps it within the Hubs tab navigation stack.

3. **Mock user profile photo**
   - What we know: Mock user "Alex" needs a profile image
   - What's unclear: Whether to use an existing ambassador photo or add a new asset
   - Recommendation: Add a generic user avatar to the asset catalog (could be a simple SF Symbol-based placeholder initially, or a stock photo). Name it "alex-profile".

## Validation Architecture

### Test Framework
| Property | Value |
|----------|-------|
| Framework | XCTest (Xcode built-in) |
| Config file | none -- see Wave 0 |
| Quick run command | `xcodebuild test -scheme BlossomHubs -destination 'platform=iOS Simulator,name=iPhone 16' -only-testing:BlossomHubsTests 2>&1 \| tail -20` |
| Full suite command | `xcodebuild test -scheme BlossomHubs -destination 'platform=iOS Simulator,name=iPhone 16' 2>&1 \| tail -40` |

### Phase Requirements to Test Map
| Req ID | Behavior | Test Type | Automated Command | File Exists? |
|--------|----------|-----------|-------------------|-------------|
| SUBS-04 | Mock payment sheet presents with card/expiry/CVC fields | manual-only | Visual verification in Simulator | N/A |
| SUBS-05 | Payment processing shows loading then success | unit | Test PaymentViewModel state transitions | No -- Wave 0 |
| SUBS-06 | Confetti animation plays with Blossom logo | manual-only | Visual verification in Simulator | N/A |
| SUBS-07 | Post-celebration lands on discovery with badge | manual-only | Visual verification in Simulator | N/A |
| SUBS-08 | Upgrade/downgrade/cancel update SubscriptionStore | unit | Test SubscriptionStore subscribe/changeTier/cancel methods | No -- Wave 0 |

### Sampling Rate
- **Per task commit:** Visual verification in Simulator (most requirements are UI-driven)
- **Per wave merge:** Full build verification (`xcodebuild build`)
- **Phase gate:** Full visual walkthrough: subscribe -> confetti -> badge -> upgrade -> downgrade -> cancel -> restore

### Wave 0 Gaps
- [ ] `BlossomHubsTests/SubscriptionStoreTests.swift` -- covers SUBS-08 (subscribe, changeTier, cancel, resetAll, persistence round-trip)
- [ ] `BlossomHubsTests/PaymentViewModelTests.swift` -- covers SUBS-05 (state machine transitions: idle -> processing -> success)
- [ ] Test target creation in Xcode project if not already present
- [ ] Framework install: XCTest is built-in, no additional install needed

## Sources

### Primary (HIGH confidence)
- Project codebase inspection -- TierCardView.swift line 67 `// Phase 4 wires this`, CommunityPreviewView.swift `.sheet` presentation, BlossomTheme color tokens
- STATE.md blocker note: "Confetti PhaseAnimator + Canvas implementation is MEDIUM confidence -- build standalone prototype early"
- Apple SwiftUI documentation -- Canvas, TimelineView, .sensoryFeedback(), .sheet(), .presentationDetents()

### Secondary (MEDIUM confidence)
- [Hacking with Swift -- TimelineView + Canvas custom drawings](https://www.hackingwithswift.com/quick-start/swiftui/how-to-create-custom-animated-drawings-with-timelineview-and-canvas)
- [Hacking with Swift -- Haptic Feedback](https://www.hackingwithswift.com/example-code/uikit/how-to-generate-haptic-feedback-with-uifeedbackgenerator)
- [Daniel Saidi -- Storing Codable types in AppStorage](https://danielsaidi.com/blog/2023/08/23/storing-codable-types-in-swiftui-appstorage)
- [Nerdyak -- Particle Effects with SwiftUI Canvas](https://nerdyak.tech/development/2024/06/27/particle-effects-with-SwiftUI-Canvas.html)

### Tertiary (LOW confidence)
- Confetti particle count and physics tuning (80-120 particles recommendation) -- based on general particle system best practices, needs runtime validation

## Metadata

**Confidence breakdown:**
- Standard stack: HIGH -- all native SwiftUI, no new dependencies, matches established project patterns
- Architecture: HIGH -- SubscriptionStore follows CommunityStore @MainActor @Observable pattern exactly, UserDefaults persistence is straightforward
- Confetti animation: MEDIUM -- Canvas + TimelineView approach is well-documented but the exact burst physics (velocity, gravity, fade timing) need runtime tuning. STATE.md flagged this explicitly.
- Payment sheet UI: HIGH -- standard SwiftUI sheet with TextFields, no complex API integration
- Pitfalls: HIGH -- sheet cascading and @AppStorage limitations are well-documented Swift gotchas

**Research date:** 2026-03-12
**Valid until:** 2026-04-12 (stable -- all native APIs, no fast-moving dependencies)
