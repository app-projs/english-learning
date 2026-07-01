---
name: Lumina Learning
colors:
  surface: '#f8f9fe'
  surface-dim: '#d8dadf'
  surface-bright: '#f8f9fe'
  surface-container-lowest: '#ffffff'
  surface-container-low: '#f2f3f8'
  surface-container: '#eceef3'
  surface-container-high: '#e7e8ed'
  surface-container-highest: '#e1e2e7'
  on-surface: '#191c1f'
  on-surface-variant: '#484555'
  inverse-surface: '#2e3134'
  inverse-on-surface: '#eff0f5'
  outline: '#797587'
  outline-variant: '#c9c4d8'
  surface-tint: '#603ce2'
  primary: '#5e39e0'
  on-primary: '#ffffff'
  primary-container: '#7757fa'
  on-primary-container: '#fffbff'
  inverse-primary: '#cabeff'
  secondary: '#904d00'
  on-secondary: '#ffffff'
  secondary-container: '#fe9c41'
  on-secondary-container: '#6b3800'
  tertiary: '#00647c'
  on-tertiary: '#ffffff'
  tertiary-container: '#007f9d'
  on-tertiary-container: '#fafdff'
  error: '#ba1a1a'
  on-error: '#ffffff'
  error-container: '#ffdad6'
  on-error-container: '#93000a'
  primary-fixed: '#e6deff'
  primary-fixed-dim: '#cabeff'
  on-primary-fixed: '#1c0062'
  on-primary-fixed-variant: '#4816cb'
  secondary-fixed: '#ffdcc2'
  secondary-fixed-dim: '#ffb77c'
  on-secondary-fixed: '#2e1500'
  on-secondary-fixed-variant: '#6d3900'
  tertiary-fixed: '#b7eaff'
  tertiary-fixed-dim: '#5bd5fc'
  on-tertiary-fixed: '#001f28'
  on-tertiary-fixed-variant: '#004e61'
  background: '#f8f9fe'
  on-background: '#191c1f'
  surface-variant: '#e1e2e7'
typography:
  headline-xl:
    fontFamily: Plus Jakarta Sans
    fontSize: 28px
    fontWeight: '800'
    lineHeight: 36px
    letterSpacing: -0.02em
  headline-lg:
    fontFamily: Plus Jakarta Sans
    fontSize: 24px
    fontWeight: '700'
    lineHeight: 32px
  headline-md:
    fontFamily: Plus Jakarta Sans
    fontSize: 20px
    fontWeight: '700'
    lineHeight: 28px
  body-lg:
    fontFamily: Plus Jakarta Sans
    fontSize: 16px
    fontWeight: '500'
    lineHeight: 24px
  body-md:
    fontFamily: Plus Jakarta Sans
    fontSize: 14px
    fontWeight: '500'
    lineHeight: 20px
  label-lg:
    fontFamily: Plus Jakarta Sans
    fontSize: 14px
    fontWeight: '700'
    lineHeight: 18px
  label-md:
    fontFamily: Plus Jakarta Sans
    fontSize: 12px
    fontWeight: '600'
    lineHeight: 16px
  headline-xl-mobile:
    fontFamily: Plus Jakarta Sans
    fontSize: 24px
    fontWeight: '800'
    lineHeight: 32px
rounded:
  sm: 0.5rem
  DEFAULT: 1rem
  md: 1.5rem
  lg: 2rem
  xl: 3rem
  full: 9999px
spacing:
  base: 4px
  margin-page: 20px
  gutter-card: 16px
  stack-sm: 8px
  stack-md: 16px
  stack-lg: 24px
  stack-xl: 32px
---

## Brand & Style
The brand personality is vibrant, encouraging, and educationally playful. It is designed for learners who benefit from a gamified, low-pressure environment. The visual style is a blend of **Corporate Modern** efficiency and **Tactile Playfulness**, utilizing high-quality 3D assets and soft depth to make the interface feel like a physical, interactive toy.

The goal is to evoke a sense of "productive fun," reducing the cognitive load of language learning through friendly metaphors, generous whitespace, and an approachable character-driven aesthetic.

## Colors
The palette uses high-chroma, "candy-toned" hues against a pristine, cool-neutral background.
- **Primary (Lavender/Purple):** Used for main actions, active states, and core branding. It suggests intelligence and creativity.
- **Secondary (Sunset Orange):** Reserved for motivational elements like streaks, progress highlights, and rewards.
- **Tertiary (Sky Blue):** Used for informational accents and secondary categorization (e.g., listening or vocabulary modules).
- **Surface & Backgrounds:** We use very light tinted greys (#F8F9FE) and pure white to maintain a "clean" feel despite the high color usage.
- **Functional Colors:** Success is represented by a bright mint green (#00D995), and Error by a soft coral (#FF6B6B).

## Typography
We utilize **Plus Jakarta Sans** for its modern, geometric construction and soft terminals, which align with our "friendly" brand pillar. 
- **Headlines:** Use Bold or ExtraBold weights to create a strong visual hierarchy.
- **Body Text:** Kept at Medium (500) weight rather than Regular to ensure high legibility against colorful backgrounds.
- **Letter Spacing:** Headlines use a slight negative tracking (-0.02em) to appear tighter and more impactful, like professional editorial layouts.

## Layout & Spacing
The layout follows a **Fluid Grid** model with generous margins. 
- **Safe Zones:** A standard 20px margin is applied to the left and right of all mobile screens.
- **Rhythm:** We use a 4px base unit. Component spacing should favor "loose" configurations (16px or 24px) to emphasize a breezy, easy-to-read interface.
- **Grouping:** Use 32px or 40px spacing between major sections to clearly separate learning modules.

## Elevation & Depth
This design system avoids harsh black shadows. Depth is created through:
- **Soft Ambient Occlusion:** Shadows are very large, very blurry, and tinted with the Primary or Neutral-Dark color (e.g., `rgba(124, 92, 255, 0.1)`).
- **Tonal Layering:** Interactive cards sit on a #F8F9FE background using a pure #FFFFFF fill to "pop."
- **Inner Glows:** To mimic the 3D illustrations, primary buttons may feature a subtle top-down inner highlight to look "squishy" or tactile.
- **Backdrop Blurs:** Used sparingly on overlays and navigation bars (20px blur) to maintain context.

## Shapes
Shapes are defined by extreme roundness to maximize "approachability."
- **Standard Cards:** Use a 24px corner radius.
- **Buttons:** Use a fully pill-shaped (100px) radius for primary actions.
- **Small Elements:** Chips and tags use a 12px radius.
- **Visual Continuity:** Icons and illustrations should also feature rounded caps and corners to match the UI container language.

## Components
- **Primary Buttons:** High-saturation fills (Primary Purple or Mint Green) with white text. They should feel "thick" with 16px vertical padding.
- **Cards:** White background with a 1px soft-tinted border or a very light shadow. Content inside should have 20px internal padding.
- **Progress Bars:** Thick (12px height) with rounded caps. Use the Secondary Orange for the fill to indicate energy.
- **Input Fields:** Large 24px rounded corners, background fill of #F0F2F9, and clear 16px typography.
- **Interactive Chips:** Used for multiple choice or tags. These should have a "pressed" state that shifts background color slightly, providing tactile feedback.
- **Illustrations:** Use 3D-rendered characters or icons with soft lighting to act as focal points in cards.