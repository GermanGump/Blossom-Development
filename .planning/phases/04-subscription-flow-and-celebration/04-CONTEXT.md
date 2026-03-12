# Phase 4: Subscription Flow and Celebration - Context

**Gathered:** 2026-03-12
**Status:** Ready for planning

<domain>
## Phase Boundary

A subscriber taps "Subscribe" on any tier, completes a mock Stripe payment, experiences a confetti celebration, and returns to discovery with their subscription reflected. The app tracks subscription state across multiple communities with persistence, and provides upgrade/downgrade/cancel flows. Covers: mock payment sheet, payment processing simulation, confetti animation, subscription state management, and subscription lifecycle (upgrade/downgrade/cancel).

</domain>

<decisions>
## Implementation Decisions

### Mock payment sheet
- Stripe-accurate design — closely mimics Stripe's actual checkout sheet styling (dark input fields, card brand icon, "Powered by Stripe" with logo)
- Visual validation on card input — auto-format card number with spaces, show card brand icon (Visa/MC), validate MM/YY range — but payment always succeeds regardless of input
- Full tier summary shown above card fields — tier name, price, and benefit list so user sees what they're paying for
- Stripe logo + "Powered by Stripe" text at bottom of sheet
- Presented as a stacked sheet on top of the existing tier bottom sheet — both sheets visible
- Once "Pay" is tapped, no cancel — spinner runs to completion, always succeeds
- No error/decline flow — every payment succeeds in the demo

### Payment loading state
- After tapping Pay, button becomes a spinner with "Processing..." text
- Runs for 1-2 seconds, then transitions to success
- No cancel possible during processing

### Confetti celebration
- Confetti bursts outward from center where Blossom logo is displayed
- Blossom brand colors for confetti pieces (violet, orange, teal)
- "Welcome to [Community Name]!" text below the centered logo
- Tap to continue — a "Continue" or "Enter Community" button appears after confetti burst
- Not auto-dismissing — user controls when they proceed
- Haptic feedback on confetti burst moment

### Post-payment transition
- After tapping "Continue" on confetti screen, user returns to discovery screen
- Subscribed community card shows a "Subscribed" badge on the discovery screen
- Phase 5 later adds the real community landing page as the destination
- Haptic feedback at key moments: payment success, confetti burst, button taps

### Tier sheet post-subscription behavior
- "View Tiers" CTA becomes "Your Subscription" after subscribing
- Same sheet shows current tier highlighted with "Current Plan" label
- Other tiers show "Upgrade" or "Downgrade" buttons
- Upgrade/downgrade triggers a simple alert dialog: "Upgrade to [Tier] for $X/mo?" with Confirm/Cancel

### Subscription management
- Quick actions in tier sheet (upgrade/downgrade) + separate "My Subscriptions" screen for full management
- Cancel flow uses a retention bottom sheet — asks why they're leaving (too expensive, not enough content, etc.) before confirming cancellation
- After canceling, user returns to the community preview page in its pre-subscribed state with "View Tiers" CTA restored

### Subscription state model
- Subscriptions persist across app restarts (resettable) — a hidden debug toggle can reset all subscriptions for demo purposes
- Multiple simultaneous subscriptions supported — user can subscribe to BD, Brandon, Max, etc. each at their own tier (matches Patreon)
- Mock logged-in user — pre-set user (e.g., "Alex") with profile photo, subscription map, join dates — makes the demo feel lived-in
- Architecture: Claude's discretion on whether to extend CommunityStore or create a separate UserStore

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

</decisions>

<specifics>
## Specific Ideas

- Stripe-accurate payment sheet — should genuinely look like Stripe's checkout, not a generic form
- Confetti should burst from center, not rain from top — dramatic celebratory moment
- "Welcome to [Community Name]!" personalizes the celebration
- Retention flow on cancel — asking "why are you leaving?" before confirming adds realism
- Multiple subscriptions modeled like Patreon — each community is independent
- Mock user "Alex" with profile to make the demo feel lived-in
- Resettable persistence — persist by default, debug toggle to reset for re-demo

</specifics>

<code_context>
## Existing Code Insights

### Reusable Assets
- BlossomPrimaryButton: Full-width violet button style — use for "Pay" and "Continue" buttons
- BlossomSecondaryButton: Outlined violet button — use for "Cancel" and secondary actions
- BlossomGhostButton: Tertiary text-only style — use for "Cancel subscription" or dismiss actions
- TierCardView: Existing accordion card with Subscribe button placeholder — wire up the action
- TiersBottomSheet: Container for tier cards — modify to show "Current Plan" state when subscribed
- CommunityPreviewView: Has `showTiers` @State and .sheet presentation — extend for payment flow
- TagView: .tier style — could be used for "Subscribed" badge on discovery cards
- PhaseAnimator pattern from CommunityHeroCardView — reference for confetti animation approach
- BlossomTheme color tokens: violet, orange, teal available for confetti colors

### Established Patterns
- @MainActor @Observable for view models with lazy init in .onAppear
- Bottom sheet via .sheet(isPresented:) with .presentationDetents
- Spring animations (.spring(response:dampingFraction:)) for expansion/transitions
- @AppStorage for persistent one-time state (splash screen pattern) — extend for subscription persistence
- CommunityStore injected via .environment() — new store would follow same pattern
- withAnimation { } completion: { } for chained animation sequences

### Integration Points
- TierCardView Subscribe button: currently `{ // Phase 4 wires this }` — wire to payment flow
- CommunityPreviewView showTiers: state that presents TiersBottomSheet — extend to manage subscription state
- HubsRoute enum: may need new routes for payment/celebration screens
- CommunityHeroCardView and CommunityCardView: add subscribed badge overlay
- ContentView: inject new UserStore/UserSession into environment alongside CommunityStore

</code_context>

<deferred>
## Deferred Ideas

None — discussion stayed within phase scope

</deferred>

---

*Phase: 04-subscription-flow-and-celebration*
*Context gathered: 2026-03-12*
