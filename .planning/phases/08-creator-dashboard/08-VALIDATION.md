---
phase: 8
slug: creator-dashboard
status: draft
nyquist_compliant: false
wave_0_complete: false
created: 2026-03-15
---

# Phase 8 — Validation Strategy

> Per-phase validation contract for feedback sampling during execution.

---

## Test Infrastructure

| Property | Value |
|----------|-------|
| **Framework** | Manual Simulator verification (consistent with Phases 1-7) |
| **Config file** | None — UI prototype, no test target |
| **Quick run command** | `xcodebuild build -project BlossomHubs/BlossomHubs.xcodeproj -scheme BlossomHubs -destination 'platform=iOS Simulator,name=iPhone 17 Pro' -derivedDataPath BlossomHubs/Build` |
| **Full suite command** | Build + install + visual verification in Simulator |
| **Estimated runtime** | ~30 seconds (build) |

---

## Sampling Rate

- **After every task commit:** Build succeeds with zero errors
- **After every plan wave:** Visual verification in Simulator
- **Before `/gsd:verify-work`:** Full subscriber + creator flow walkthrough
- **Max feedback latency:** 30 seconds (build time)

---

## Per-Task Verification Map

| Task ID | Plan | Wave | Requirement | Test Type | Automated Command | File Exists | Status |
|---------|------|------|-------------|-----------|-------------------|-------------|--------|
| 08-01-01 | 01 | 1 | CRTR-01, CRTR-02 | manual | Build + visual | N/A | pending |
| 08-01-02 | 01 | 1 | CRTR-03, CRTR-04 | manual | Build + visual | N/A | pending |
| 08-02-01 | 02 | 2 | CRTR-05 | manual | Build + visual | N/A | pending |
| 08-02-02 | 02 | 2 | CRTR-07 | manual | Build + visual | N/A | pending |

*Status: pending / green / red / flaky*

---

## Wave 0 Requirements

Existing infrastructure covers all phase requirements. No test framework setup needed — this is a UI prototype validated through manual Simulator verification, consistent with Phases 1-7.

---

## Manual-Only Verifications

| Behavior | Requirement | Why Manual | Test Instructions |
|----------|-------------|------------|-------------------|
| Creator entry point visibility | CRTR-01 | UI gating based on user role | Check "Manage my Hub" visible for Nick, hidden for non-creator |
| Community edit reflection | CRTR-02 | Cross-view state propagation | Edit title in dashboard, verify on landing page |
| Tier CRUD with 1-4 constraint | CRTR-03 | Form interaction and constraint | Add/edit/remove tiers, verify across surfaces |
| Permissions matrix drives access | CRTR-04 | Cross-view permission propagation | Toggle permission off, verify subscriber view locks |
| Published post in feed | CRTR-05 | Content creation and gating | Publish post, check feed and tier gate |
| Verified badge audit | CRTR-07 | Visual audit across surfaces | Check discovery cards, forum posts, FAQ entries |

---

## Validation Sign-Off

- [x] All tasks have manual verify instructions
- [x] Sampling continuity: build verification after every commit
- [x] No watch-mode flags
- [x] Feedback latency < 30s
- [ ] `nyquist_compliant: true` set in frontmatter

**Approval:** pending
