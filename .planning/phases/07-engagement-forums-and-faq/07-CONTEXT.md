---
phase: 07-engagement-forums-and-faq
created: 2026-03-15
status: complete
areas_discussed: 3
---

# Phase 7 Context: Engagement — Forums and FAQ

## Phase Goal
Subscribed users can participate in tier-gated discussion forums — creating threads, replying, and liking — and access the FAQ zone to submit questions that creators can answer, with all creator replies visually distinguished.

## Requirements
- ENGR-01: Discussion forums with threaded conversations — tier-based access per forum
- ENGR-02: Full post interaction: create threads, reply, like
- ENGR-03: Visible tier badges on forum posts
- ENGR-04: FAQ zone with tier-gated question submission
- ENGR-05: Creator answers become persistent discoverable FAQ entries
- ENGR-06: Creator/ambassador replies have distinct visual treatment

## Area 1: Forum Thread Layout & Interaction Design

### Thread List (Discussions Section)
- **Compact list rows** — dense rows showing thread title, author, tier badge, reply count, like count, and relative timestamp
- NOT card-based like the content feed — forums should feel distinct and fit more threads on screen
- Locked threads (above user's tier) show the same LockedContentOverlay pattern from Phase 6

### Thread Detail View
- **Flat reply list** — all replies in chronological order, no nesting/indentation
- Discord/Slack thread style — simple, easy to scroll on mobile
- Original post (OP) at the top, replies below separated by dividers

### Like Interaction
- **Heart icon + count** — tap to toggle like, count updates immediately in-memory
- Outline heart = not liked, filled red heart = liked
- Same interaction on both thread list rows and individual replies

### New Thread Entry Point
- **Floating action button (FAB)** — bottom-right "+" button, always accessible while scrolling
- Tapping opens a compose sheet with title and body text fields
- FAB only visible if user has forum access for this community's tier

### Reply Flow
- Reply text field at bottom of thread detail view (like a chat input)
- Submit adds reply to flat list immediately

## Area 2: Tier Badge & Creator Reply Visual Treatment

### Tier Badges on Forum Posts
- **Inline with author name** — TagView(.tier) pill displayed right after the author name on the same row
- Example: `👤 BD ✓  [Gold]  2h ago`
- Uses existing TagView component with .tier style (violet color)
- Every forum post and reply shows the poster's tier badge

### Creator/Ambassador Reply Distinction
- **Highlighted background + role badge** — subtle teal tint background on the entire reply row
- Role badge pill next to the tier badge: "Creator" or "Ambassador" label
- Both creator and ambassador use the **same teal tint treatment, different label text**
- Creator shows "Creator" badge, ambassador shows "Ambassador" badge — same visual weight
- Verified checkmark on avatar still shows via AvatarView.showVerifiedBadge

### Visual Stack on Creator Reply
```
┌── teal tint background ──────────────┐
│ 👤 BD ✓  [Gold]  [Creator]     2h    │
│                                       │
│ @Nick great point about the yield...  │
│ ❤️ 8                                  │
└───────────────────────────────────────┘
```

## Area 3: FAQ Zone UX & Question Lifecycle

### FAQ Layout
- **Accordion / expandable list** — questions as tappable rows that expand inline to show the answer
- Compact and scannable, familiar FAQ pattern
- Chevron indicator: ▶ collapsed, ▼ expanded
- Uses expandedEntryID UUID? state for single-expansion (same pattern as TiersBottomSheet expandedTierID)

### Ask a Question Flow
- **Inline text field at top** of the FAQ list — always visible
- "Ask a question..." placeholder text with a Send button
- Tapping and typing, then submit adds the question to the pending list
- Text field only enabled if user's tier has FAQ submission permission
- If no permission: show a prompt naming the required tier (same upgrade pattern as locked content)

### Answered vs Unanswered Visual Distinction
- **Checkmark + creator attribution** for answered entries
  - Green checkmark icon (✅) next to the question text
  - Creator's name shown below the answer with verified badge
  - Answer text uses the same teal tint background as creator forum replies (ENGR-06 consistency)
- **Clock/pending icon** (⏳) for unanswered entries
  - Shows "Asked by [name] · [time ago]"
  - No expandable content (nothing to expand yet)

### FAQ Ordering
- **Answered first** — answered entries surface at top (most useful content first)
- Unanswered/pending entries appear below in a separate visual group
- Within each group, sorted by most recent first

## Code Context

### Existing Assets to Reuse
- `ForumThread` model already defined in Community.swift with title, content, authorId, requiredTierIndex, replyCount, likeCount, publishedAt
- `FAQEntry` model already defined with question, answer (optional), isAnswered, askedBy, answeredBy
- `CommunitySectionPager` has EmptyStateView placeholders for .discussions and .faq — replace these
- `TagView(.tier)` for tier badges (violet pill)
- `AvatarView(showVerifiedBadge:)` for creator identity
- `LockedContentOverlay` for tier-gated locked state
- `TiersBottomSheet` for upgrade prompts
- `SubscriptionStore.currentTier(for:)` for tier access checks
- Mock data: 3-4 forum threads and 3 FAQ entries per community already in CommunityStore

### Patterns to Follow
- No own ScrollView in forum/FAQ views — participate in outer CommunityHubView scroll (Phase 6 pattern)
- VStack + Spacer for top-alignment within CommunitySectionPager pages
- Lazy init ViewModel as @State optional in .onAppear (Phase 3/6 pattern)
- @MainActor @Observable for ViewModels
- Binding(get:set:) for @Observable property bindings
- `.clipShape(RoundedRectangle(...))` on any view using LockedContentOverlay

### New Components Needed
- `ForumThreadRow` — compact list row for thread list
- `ForumThreadDetailView` — pushed via navigation, flat reply list with reply input
- `ForumReplyRow` — individual reply with tier badge and creator highlight
- `ForumComposeSheet` — sheet for creating new thread (title + body)
- `ForumViewModel` — thread list, like toggling, reply adding, tier access
- `FAQListView` — accordion list with inline ask field
- `FAQEntryRow` — expandable row with answered/unanswered states
- `FAQViewModel` — question submission, answer display, ordering logic
- `DiscussionsFeedView` — top-level view for Discussions section (like ContentFeedView)

## Deferred Ideas
- Trade highlight card UI/UX improvement (noted during Phase 6 UAT)
- Search within forums and FAQ (future phase)
- Pinned threads (creator tool — Phase 8)
