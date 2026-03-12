---
phase: 4
slug: subscription-flow-and-celebration
status: draft
nyquist_compliant: false
wave_0_complete: false
created: 2026-03-12
---

# Phase 4 — Validation Strategy

> Per-phase validation contract for feedback sampling during execution.

---

## Test Infrastructure

| Property | Value |
|----------|-------|
| **Framework** | XCTest (Xcode built-in) |
| **Config file** | none — Wave 0 creates test target if needed |
| **Quick run command** | `xcodebuild test -scheme BlossomHubs -destination 'platform=iOS Simulator,name=iPhone 16' -only-testing:BlossomHubsTests 2>&1 \| tail -20` |
| **Full suite command** | `xcodebuild test -scheme BlossomHubs -destination 'platform=iOS Simulator,name=iPhone 16' 2>&1 \| tail -40` |
| **Estimated runtime** | ~15 seconds |

---

## Sampling Rate

- **After every task commit:** Visual verification in Simulator (most requirements are UI-driven)
- **After every plan wave:** Full build verification (`xcodebuild build`)
- **Before `/gsd:verify-work`:** Full visual walkthrough: subscribe → confetti → badge → upgrade → downgrade → cancel → restore
- **Max feedback latency:** 15 seconds

---

## Per-Task Verification Map

| Task ID | Plan | Wave | Requirement | Test Type | Automated Command | File Exists | Status |
|---------|------|------|-------------|-----------|-------------------|-------------|--------|
| 04-01-01 | 01 | 1 | SUBS-08 | unit | `xcodebuild test -only-testing:BlossomHubsTests/SubscriptionStoreTests` | ❌ W0 | ⬜ pending |
| 04-01-02 | 01 | 1 | SUBS-05 | unit | `xcodebuild test -only-testing:BlossomHubsTests/PaymentViewModelTests` | ❌ W0 | ⬜ pending |
| 04-02-01 | 02 | 2 | SUBS-04 | manual-only | Visual verification in Simulator | N/A | ⬜ pending |
| 04-02-02 | 02 | 2 | SUBS-05 | manual-only | Visual verification — spinner then success | N/A | ⬜ pending |
| 04-03-01 | 03 | 2 | SUBS-06 | manual-only | Visual verification — confetti burst | N/A | ⬜ pending |
| 04-03-02 | 03 | 2 | SUBS-07 | manual-only | Visual verification — returns to discovery with badge | N/A | ⬜ pending |
| 04-04-01 | 04 | 3 | SUBS-08 | manual-only | Visual verification — upgrade/downgrade/cancel flows | N/A | ⬜ pending |

*Status: ⬜ pending · ✅ green · ❌ red · ⚠️ flaky*

---

## Wave 0 Requirements

- [ ] `BlossomHubsTests/SubscriptionStoreTests.swift` — covers SUBS-08 (subscribe, changeTier, cancel, resetAll, persistence round-trip)
- [ ] `BlossomHubsTests/PaymentViewModelTests.swift` — covers SUBS-05 (state machine transitions: idle → processing → success)
- [ ] Test target creation in Xcode project if not already present
- [ ] Framework install: XCTest is built-in, no additional install needed

*Note: Most Phase 4 requirements are visual/interaction-based and require manual Simulator verification.*

---

## Manual-Only Verifications

| Behavior | Requirement | Why Manual | Test Instructions |
|----------|-------------|------------|-------------------|
| Mock Stripe payment sheet with card/expiry/CVC | SUBS-04 | Visual layout, Stripe branding fidelity | Present sheet, verify fields render correctly |
| Confetti burst animation with Blossom logo | SUBS-06 | Animation smoothness, particle physics | Subscribe → verify burst, colors, timing, logo |
| Post-celebration discovery badge | SUBS-07 | Navigation flow, badge visibility | Complete flow → verify badge on discovery card |
| Upgrade/downgrade/cancel UI flows | SUBS-08 | Alert dialogs, retention sheet, state changes | Test each management action through UI |

---

## Validation Sign-Off

- [ ] All tasks have `<automated>` verify or Wave 0 dependencies
- [ ] Sampling continuity: no 3 consecutive tasks without automated verify
- [ ] Wave 0 covers all MISSING references
- [ ] No watch-mode flags
- [ ] Feedback latency < 15s
- [ ] `nyquist_compliant: true` set in frontmatter

**Approval:** pending
