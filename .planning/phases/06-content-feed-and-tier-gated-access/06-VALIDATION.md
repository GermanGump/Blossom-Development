---
phase: 6
slug: content-feed-and-tier-gated-access
status: draft
nyquist_compliant: false
wave_0_complete: false
created: 2026-03-14
---

# Phase 6 — Validation Strategy

> Per-phase validation contract for feedback sampling during execution.

---

## Test Infrastructure

| Property | Value |
|----------|-------|
| **Framework** | Xcode Previews + manual Simulator verification |
| **Config file** | none — SwiftUI preview-based validation |
| **Quick run command** | `xcodebuild build -project BlossomHubs/BlossomHubs.xcodeproj -scheme BlossomHubs -destination 'platform=iOS Simulator,name=iPhone 17 Pro'` |
| **Full suite command** | Full Simulator walkthrough: subscribe → navigate to Posts tab → verify all 3 card types → test locked content → test collection filter → test YouTube deep link |
| **Estimated runtime** | ~30 seconds (build) + 3 minutes (manual verification) |

---

## Sampling Rate

- **After every task commit:** Run `xcodebuild build` to verify compilation
- **After every plan wave:** Full Simulator walkthrough
- **Before `/gsd:verify-work`:** Full suite must be green
- **Max feedback latency:** 30 seconds

---

## Per-Task Verification Map

| Task ID | Plan | Wave | Requirement | Test Type | Automated Command | File Exists | Status |
|---------|------|------|-------------|-----------|-------------------|-------------|--------|
| 06-01-01 | 01 | 1 | HUB-03, HUB-04 | manual | Simulator: navigate to Posts section, verify card types render | N/A | ⬜ pending |
| 06-01-02 | 01 | 1 | HUB-05 | manual | Simulator: tap YouTube card, verify external app opens | N/A | ⬜ pending |
| 06-02-01 | 02 | 1 | HUB-06 | manual | Simulator: subscribe at lowest tier, verify locked overlay | N/A | ⬜ pending |
| 06-02-02 | 02 | 1 | HUB-07 | manual | Simulator: tap filter dropdown, select collection, verify filter | N/A | ⬜ pending |

*Status: ⬜ pending · ✅ green · ❌ red · ⚠️ flaky*

---

## Wave 0 Requirements

*Existing infrastructure covers all phase requirements — no new test framework needed.*

---

## Manual-Only Verifications

| Behavior | Requirement | Why Manual | Test Instructions |
|----------|-------------|------------|-------------------|
| Feed shows 3 post types chronologically | HUB-03 | Visual UI verification required | Navigate to subscribed community Posts tab, verify text/trade/YouTube cards render in date order |
| Trade highlight cards show ticker metrics | HUB-04 | Visual layout verification | Find trade highlight post, verify orange ticker tags and price/change row |
| YouTube card opens YouTube app | HUB-05 | Requires external app interaction | Tap YouTube card, verify YouTube app or Safari opens |
| Lower-tier posts show blurred lock overlay | HUB-06 | Visual overlay verification | Subscribe at lowest tier, verify higher-tier posts show blur + lock icon + upgrade prompt |
| Collection filter narrows feed | HUB-07 | Interactive UI verification | Tap filter dropdown, select collection, verify feed updates |

---

## Validation Sign-Off

- [ ] All tasks have `<automated>` verify or Wave 0 dependencies
- [ ] Sampling continuity: no 3 consecutive tasks without automated verify
- [ ] Wave 0 covers all MISSING references
- [ ] No watch-mode flags
- [ ] Feedback latency < 30s
- [ ] `nyquist_compliant: true` set in frontmatter

**Approval:** pending
