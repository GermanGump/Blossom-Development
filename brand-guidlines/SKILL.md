# Blossom Brand Guidelines

You are working on a project for **Blossom**. You MUST follow these brand guidelines strictly when generating any UI, styling, or design-related code.

## Brand Identity

**Blossom** is a social investing platform for Canadians. The tagline is **"the future of investing is social."**

**Mission:** Break down the barriers to investing by creating an accessible community for all Canadians to learn and share knowledge, promoting financial literacy around the stock market and changing the culture of investing.

**What Blossom does:** Users view verified public portfolios and trades of other users, gain insights from other investors, and share opinions in a safe community. The app shows portfolio data, stock prices, and social feeds.

### Brand Personality

Blossom's personality is defined by these keywords: **transparency, fun, community, welcoming, easy, trustworthy, social, casual, modern, simple.**

The brand leans toward:
- **Personal & Friendly** (not corporate/professional)
- **Spontaneous & Energetic** (not overly careful/planned)
- **Fun** (not serious)
- **Accessible to All** (not exclusive)
- **Modern & High-Tech** (not classic/traditional)
- **Cutting Edge** (not established/legacy)

### Target Audience

Two core personas — both Gen-Z/Millennial Canadians:

**"Tom Trader"** — Age 28, Toronto. Young professional (ex-Deloitte), 70k+ salary. Interested in investing, finance, and retiring early. Data-oriented.

**"Lisa Learner"** — Age 23, Calgary. Graphic designer in tech, early career. Beginning to save and invest. Loves learning, reads books and Reddit.

### Visual Identity

The logomark is a flower shape composed of overlapping rounded petals in Violet and Teal, with white petals and an Orange circular accent at the center. The wordmark uses a bold, rounded serif typeface in dark navy.

The brand also uses a playful **astronaut-on-a-rocket mascot** illustration for fun, energetic moments (e.g., "to the moon!" messaging, onboarding, success states, social graphics).

## Color Palette

Use ONLY these brand colors. Do not introduce outside colors unless explicitly asked.

| Name        | Hex       | CSS Variable   | Usage                                                  |
|-------------|-----------|----------------|--------------------------------------------------------|
| Violet      | `#7361F7` | `--color-1`    | Primary brand color. CTAs, links, primary buttons, key accents, hero sections |
| Orange      | `#FF7833` | `--color-2`    | Secondary accent. Highlights, warnings, hover states, energy elements |
| Teal        | `#35C7B2` | `--color-3`    | Tertiary accent. Success states, illustrations, secondary actions |
| Slate       | `#565E76` | `--color-4`    | Body text, secondary text, muted UI elements           |
| Dark Navy   | `#1E222A` | `--color-5`    | Headings, high-contrast text, dark backgrounds (use instead of pure black) |
| White       | `#FFFFFF` | `--color-6`    | Backgrounds, card surfaces, light text on dark          |

Each brand color has a tint/shade ramp for subtle UI variations (hover states, disabled states, backgrounds). Derive tints by mixing with white, shades by mixing with Dark Navy.

### Color Rules

- **Primary actions** (buttons, links, focus rings): Violet `#7361F7`
- **Secondary actions** (outlines, toggles): Teal `#35C7B2`
- **Destructive/attention actions**: Orange `#FF7833`
- **Body text**: Slate `#565E76` on light backgrounds
- **Headings**: Dark Navy `#1E222A`
- **Backgrounds**: White `#FFFFFF` as default; use Violet or Black for hero/dark sections
- Maintain a minimum contrast ratio of **4.5:1** for text (WCAG AA)
- Never place Orange text on White — use it only for icons, badges, or large display elements
- Teal and Violet should not be used adjacent without a neutral separator

### CSS Variables

Always define and use these CSS custom properties:

```css
:root {
  --color-1: #7361F7;
  --color-2: #FF7833;
  --color-3: #35C7B2;
  --color-4: #565E76;
  --color-5: #1E222A;
  --color-6: #FFFFFF;
}
```

## Typography

Blossom uses a five-font system. **Matter** is the original brand typeface (used in print, brand materials, and social graphics). The remaining four are the web/app implementation stack.

### Original Brand Font: Matter

The primary brand typeface from the official brand guide (V.01.23).

- **Matter Heavy** — Headlines. Kerning: Optical, Tracking: -16, Case: lowercase, Leading: = point size
- **Matter Regular** — Subheads and body copy
  - Subhead: Size headline/3, Tracking: +50, Case: ALL CAPS, Leading: size x 1.5
  - Body: Size headline/4, Tracking: 0, Case: sentence, Leading: size x 1.5

Use Matter for brand collateral, print, pitch decks, and social graphics. For web/app, use the web font stack below.

### Web/App Font Stack

| Role | Font | Category | CSS Variable | Source |
|------|------|----------|--------------|--------|
| Body / UI | Inter | Geometric Sans-Serif | `--font-body` | [Google Fonts](https://fonts.google.com/specimen/Inter) |
| Marketing Headers | Instrument Sans | Modern Sans-Serif | `--font-header` | [Google Fonts](https://fonts.google.com/specimen/Instrument+Sans) |
| Social / Display | Montserrat | Geometric Sans-Serif | `--font-display` | [Google Fonts](https://fonts.google.com/specimen/Montserrat) |
| Brand Accent | Playfair Display | Serif | `--font-brand` | [Google Fonts](https://fonts.google.com/specimen/Playfair+Display) |

### Font CSS Variables

```css
:root {
  --font-body: 'Inter', sans-serif;
  --font-header: 'Instrument Sans', sans-serif;
  --font-display: 'Montserrat', sans-serif;
  --font-brand: 'Playfair Display', serif;
}
```

### Tailwind Config

```js
// tailwind.config.js
module.exports = {
  theme: {
    extend: {
      fontFamily: {
        sans: ['Inter', 'ui-sans-serif', 'system-ui'],
        header: ['Instrument Sans', 'sans-serif'],
        display: ['Montserrat', 'sans-serif'],
        serif: ['Playfair Display', 'serif'],
      },
    },
  },
}
```

Use Tailwind classes: `font-sans` (body/UI), `font-header` (marketing headings), `font-display` (social/display), `font-serif` (brand accent).

### 1. Inter — Primary UI Font

The default font for the entire app interface.

- **App interface**: All portfolio data, stock prices, user social feeds
- **Body copy**: Long-form articles and "Learn" sections
- **Why**: Optimized for high-legibility on mobile screens and complex numerical data

**Weights:**
- `Regular (400)` — General body text and comments
- `Medium (500)` — Navigation items and sub-headers
- `Semi-Bold (600)` — Buttons and highlighted data points

### 2. Instrument Sans — Marketing & Editorial Font

Used on the marketing site, not in the app UI.

- **Website headers**: Landing page hero sections and section titles
- **Brand storytelling**: Marketing copy that requires a more "premium" feel than standard app UI
- **Why**: Offers a sophisticated, editorial look that bridges tech and finance

### 3. Montserrat — Social Media & Display Font

Reserved for social graphics and high-impact visuals.

- **Social graphics**: Instagram carousels, Twitter headers, YouTube thumbnails
- **Impact headlines**: Used primarily in **Extra Bold (800)** or **Black (900)** weights
- **Why**: Wide character set and geometric shapes make it highly visible in busy social feeds
- Do NOT use Montserrat in the web app — it is for social/marketing assets only

### 4. Playfair Display — Brand Accent Serif

Used sparingly for brand identity moments.

- **Brand logomark**: Used for the "Blossom" wordmark
- **Premium moments**: Occasional use in high-end reports or investor relations documents
- **Why**: Establishes trust and maturity
- Do NOT use for body text or general UI headings

### Type Scale

- Display/Hero: 3rem+ (48px+), bold — use `--font-header` or `--font-display`
- H1: 2.25rem (36px), bold — use `--font-header` in marketing, `--font-body` in app
- H2: 1.75rem (28px), bold
- H3: 1.25rem (20px), semibold
- Body: 1rem (16px), regular — always `--font-body`
- Small/Caption: 0.875rem (14px), regular
- **Monospace** (code blocks): `'JetBrains Mono'`, `'Fira Code'`, `monospace`

## Logo Usage

Three logo formats exist — use the appropriate one for the context:

| Format | When to use | File |
|--------|------------|------|
| **Horizontal** (flower + wordmark side by side) | Default — use this most of the time | `brand-guidlines/logos/Blossom-Logo.png` |
| **Stacked** (flower above wordmark) | When vertical space is available and it feels right | — |
| **Icon only** (flower mark alone) | When space is tight (favicons, app icons, avatars) | — |

- Minimum clear space: equal to the height of the flower mark on all sides
- Do NOT stretch, rotate, recolor, or add effects to the logo
- On dark backgrounds, use a white version of the wordmark
- Minimum display width: 120px for horizontal, 48px for icon only

## Spacing and Layout

- Base unit: **4px** grid system
- Component padding: multiples of 8px (8, 16, 24, 32, 48)
- Section spacing: 64px–96px vertical rhythm
- Border radius: **8px** default for cards/buttons, **50%** for avatars/circular elements
- Max content width: **1200px** for main content areas

## Component Patterns

### Buttons

```css
/* Primary */
.btn-primary {
  background: var(--color-1);
  color: var(--color-6);
  border-radius: 8px;
  padding: 12px 24px;
  font-weight: 600;
}

/* Secondary */
.btn-secondary {
  background: transparent;
  color: var(--color-1);
  border: 2px solid var(--color-1);
  border-radius: 8px;
  padding: 12px 24px;
}

/* Accent */
.btn-accent {
  background: var(--color-3);
  color: var(--color-6);
  border-radius: 8px;
  padding: 12px 24px;
}
```

### Cards

- Background: White (`--color-6`)
- Border: `1px solid #E2E4E9` (subtle gray, derived from Slate)
- Border-radius: 12px
- Shadow: `0 2px 8px rgba(0, 0, 0, 0.06)`
- Padding: 24px

### Forms

- Input border: `1px solid #C4C8D4` (light Slate)
- Focus ring: `0 0 0 3px rgba(115, 97, 247, 0.25)` (Violet glow)
- Error state: Orange `--color-2`
- Success state: Teal `--color-3`
- Border-radius: 8px

## Tone and Voice

- **Friendly** and approachable, never corporate or stiff
- **Clear** and concise — short sentences, simple words
- **Encouraging** — positive framing, growth-oriented language
- **Casual and fun** — use playful language, emojis are welcome in social contexts
- Avoid jargon unless the audience is technical
- Use **lowercase** for display headlines (matching brand guide style)
- Use sentence case for UI text and body copy

### Brand Catchphrases

Use these established phrases where appropriate:
- **"the future of investing is social"** — primary tagline
- **"it's not luck"** — confidence/empowerment messaging
- **"to the moon!"** — playful, community energy (pair with astronaut mascot)
- **"Your next best investment awaits."** — onboarding/CTA
- **"See what stocks others are investing in."** — feature-driven messaging

## Illustration and Imagery

- **Astronaut mascot**: Cartoon astronaut riding a rocket. Use for success states, onboarding, empty states, social graphics, and fun brand moments.
- **Photography**: Real people, diverse, young (Gen-Z/Millennial), candid and natural. Avoid stock photo aesthetics.
- **App mockups**: Show the actual Blossom app on device mockups (phones in Violet, Teal, or Orange cases) to reinforce the product.
- **Social graphics**: Bold headlines in lowercase on solid brand-color backgrounds (Violet, Teal, Orange). Mix with photography. Four short words per frame for maximum impact. Swap colors and text alignment to create layout variety.

## Social Media Templates

Social posts follow a grid-based system with these rules:
- **Backgrounds**: Solid Violet, Teal, or Orange fills
- **Text**: White, bold, lowercase Matter Heavy (or Montserrat Extra Bold for web)
- **Layout**: Large type, 4 short words max per visual. Text can overlay photos with semi-transparent color blocks
- **Formats**: Instagram carousels, Twitter headers, YouTube thumbnails, story templates
- Mix app screenshots, photography, and bold text-only frames

## Do's and Don'ts

**Do:**
- Use the brand color palette consistently
- Maintain generous whitespace
- Keep UI clean and uncluttered
- Use the flower motif sparingly as a decorative element
- Ensure all interactive elements have visible focus states

**Don't:**
- Use gradients unless specifically approved
- Mix more than 3 brand colors in a single component
- Use pure black (`#000`) for large background areas — use Dark Navy `#1E222A` or Violet instead
- Add drop shadows heavier than the card shadow spec above
- Use rounded-full (pill) buttons — stick to 8px radius
