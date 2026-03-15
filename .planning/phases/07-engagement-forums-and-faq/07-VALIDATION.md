---
phase: 7
slug: engagement-forums-and-faq
status: draft
nyquist_compliant: true
wave_0_complete: true
created: 2026-03-15
---

# Phase 7 — Validation Strategy

> Per-phase validation contract for feedback sampling during execution.

---

## Test Infrastructure

| Property | Value |
|----------|-------|
| **Framework** | Manual Simulator verification (SwiftUI prototype — no unit test target) |
| **Config file** | none |
| **Quick run command** | `xcodebuild build -project BlossomHubs/BlossomHubs.xcodeproj -scheme BlossomHubs -destination 'platform=iOS Simulator,name=iPhone 17 Pro'` |
| **Full suite command** | Build + visual walkthrough in Simulator |
| **Estimated runtime** | ~30 seconds (build) + manual verification |

---

## Sampling Rate

- **After every task commit:** Build succeeds, launch in Simulator, verify target view renders
- **After every plan wave:** Full app flow: discovery → subscribe → community hub → discussions/FAQ sections
- **Before `/gsd:verify-work`:** Full suite must build clean + visual walkthrough of all 6 ENGR requirements
- **Max feedback latency:** 30 seconds (build time)

---

## Per-Task Verification Map

| Task ID | Plan | Wave | Requirement | Test Type | Automated Command | File Exists | Status |
|---------|------|------|-------------|-----------|-------------------|-------------|--------|
| 07-01-01 | 01 | 1 | ENGR-01, ENGR-03 | manual | Build + Simulator visual | N/A | ⬜ pending |
| 07-01-02 | 01 | 1 | ENGR-02, ENGR-06 | manual | Build + Simulator visual | N/A | ⬜ pending |
| 07-02-01 | 02 | 2 | ENGR-04, ENGR-05 | manual | Build + Simulator visual | N/A | ⬜ pending |
| 07-02-02 | 02 | 2 | ENGR-06 | manual | Build + Simulator visual | N/A | ⬜ pending |

*Status: ⬜ pending · ✅ green · ❌ red · ⚠️ flaky*

---

## Wave 0 Requirements

Existing infrastructure covers all phase requirements. No test framework changes needed — this is a UI prototype validated visually via Simulator.

---

## Manual-Only Verifications

| Behavior | Requirement | Why Manual | Test Instructions |
|----------|-------------|------------|-------------------|
| Forum thread list with tier gating | ENGR-01 | SwiftUI visual layout | Navigate to Discussions tab, verify compact rows with tier badges, check locked state for non-subscribed |
| Create thread, reply, like | ENGR-02 | In-memory state interactions | Tap FAB to create thread, tap into thread to reply, tap heart to like — verify immediate UI updates |
| Tier badges on forum posts | ENGR-03 | Visual styling verification | Check TagView(.tier) pill appears inline with author name on every post and reply |
| FAQ tier-gated submission | ENGR-04 | Permission gating visual | Navigate to FAQ tab, verify inline Ask field enabled/disabled based on tier |
| Creator answers as persistent FAQ | ENGR-05 | Answered/unanswered sort order | Verify answered entries appear first with checkmark, unanswered below with clock icon |
| Creator reply visual distinction | ENGR-06 | Teal tint + role badge styling | Verify creator/ambassador replies have teal background + "Creator"/"Ambassador" badge in both forums and FAQ |

---

## Validation Sign-Off

- [x] All tasks have manual verify instructions
- [x] Sampling continuity: build after every task commit
- [x] Wave 0 covers all MISSING references — none needed
- [x] No watch-mode flags
- [x] Feedback latency < 30s
- [x] `nyquist_compliant: true` set in frontmatter

**Approval:** approved 2026-03-15
