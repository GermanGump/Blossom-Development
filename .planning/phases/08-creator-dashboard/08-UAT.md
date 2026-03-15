---
phase: 08-creator-dashboard
type: uat
session_start: 2026-03-15
status: in-progress
---

# Phase 8: Creator Dashboard — UAT

## Test Results

| # | Test | Status | Notes |
|---|------|--------|-------|
| 1 | Manage my Hub Entry Point | - | |
| 2 | Dashboard Home & Stats | - | |
| 3 | Community Edit Form | - | |
| 4 | Tier Editor List & Add | - | |
| 5 | Tier Edit Sheet | - | |
| 6 | Permissions Matrix | - | |
| 7 | Compose Post (Text) | - | |
| 8 | Compose Post (Trade Highlight) | - | |
| 9 | Compose Post (YouTube Link) | - | |
| 10 | Verified Badge Audit | - | |

## Tests

### Test 1: Manage my Hub Entry Point
**What to do:** Open the Hubs tab and look at the Discovery feed. Above the "My Hubs" section, you should see a "Manage my Hub" card with a gear icon and violet accent.
**What to expect:** The card is visible (since Nick is a creator). Tapping it navigates to the Creator Dashboard screen.

### Test 2: Dashboard Home & Stats
**What to do:** From the "Manage my Hub" card, tap into the Creator Dashboard.
**What to expect:** You see two stat cards at the top (subscriber count and estimated revenue). Below them are 5 section links: Edit Community, Manage Tiers, Permissions, Publish Content, and Earnings (grayed out placeholder).

### Test 3: Community Edit Form
**What to do:** From the Creator Dashboard, tap "Edit Community".
**What to expect:** A form appears with fields for community name, description, logo image, banner image, and category. Changes should propagate immediately — if you edit the name and go back, the updated name should appear in discovery cards.

### Test 4: Tier Editor List & Add
**What to do:** From the Creator Dashboard, tap "Manage Tiers".
**What to expect:** You see a list of tier cards showing name, price, and benefit count. An "Add Tier" button should be visible if fewer than 4 tiers exist. Tapping "Add Tier" creates a new tier and opens the edit sheet.

### Test 5: Tier Edit Sheet
**What to do:** In the Tier Editor, tap on any existing tier card.
**What to expect:** A modal sheet opens with fields for tier name, monthly price, and a benefits list. You can add/remove benefits. Cancel dismisses without saving; Save writes changes back.

### Test 6: Permissions Matrix
**What to do:** From the Creator Dashboard, tap "Permissions".
**What to expect:** A grid appears with rows for sections (Posts, Discussions, FAQ Submit, Videos) and columns for each tier. Toggle switches control access. Toggling a switch should update immediately.

### Test 7: Compose Post (Text)
**What to do:** From the Creator Dashboard, tap "Publish Content". Leave the post type as "Text". Type some content, optionally select a collection and tier gate, then tap Publish.
**What to expect:** A success indicator appears. The post should be published (would appear at top of content feed).

### Test 8: Compose Post (Trade Highlight)
**What to do:** In the Publish Content form, switch the post type to "Trade". Enter some content and type tickers like "$AMD, $TSLA" in the ticker field. Publish.
**What to expect:** The form shows a ticker input field when Trade is selected. Publishing succeeds with parsed tickers.

### Test 9: Compose Post (YouTube Link)
**What to do:** In the Publish Content form, switch the post type to "YouTube". Enter content and a YouTube URL. Publish.
**What to expect:** The form shows a URL field when YouTube is selected. Publishing succeeds.

### Test 10: Verified Badge Audit
**What to do:** Check these surfaces for verified badge visibility: (1) Discovery cards — community creator avatars, (2) Forum thread rows and reply rows — creator/ambassador posts, (3) FAQ entries — answered-by attribution.
**What to expect:** Verified checkmark badges appear on creator/ambassador profiles across all surfaces.
