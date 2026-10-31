---
name: Nocturne Survey
colors:
  surface: '#0b1326'
  surface-dim: '#0b1326'
  surface-bright: '#31394d'
  surface-container-lowest: '#060e20'
  surface-container-low: '#131b2e'
  surface-container: '#171f33'
  surface-container-high: '#222a3d'
  surface-container-highest: '#2d3449'
  on-surface: '#dae2fd'
  on-surface-variant: '#cbc3d7'
  inverse-surface: '#dae2fd'
  inverse-on-surface: '#283044'
  outline: '#958ea0'
  outline-variant: '#494454'
  surface-tint: '#d0bcff'
  primary: '#d0bcff'
  on-primary: '#3c0091'
  primary-container: '#a078ff'
  on-primary-container: '#340080'
  inverse-primary: '#6d3bd7'
  secondary: '#c0c1ff'
  on-secondary: '#1000a9'
  secondary-container: '#3131c0'
  on-secondary-container: '#b0b2ff'
  tertiary: '#adc6ff'
  on-tertiary: '#002e6a'
  tertiary-container: '#4d8eff'
  on-tertiary-container: '#00285d'
  error: '#ffb4ab'
  on-error: '#690005'
  error-container: '#93000a'
  on-error-container: '#ffdad6'
  primary-fixed: '#e9ddff'
  primary-fixed-dim: '#d0bcff'
  on-primary-fixed: '#23005c'
  on-primary-fixed-variant: '#5516be'
  secondary-fixed: '#e1e0ff'
  secondary-fixed-dim: '#c0c1ff'
  on-secondary-fixed: '#07006c'
  on-secondary-fixed-variant: '#2f2ebe'
  tertiary-fixed: '#d8e2ff'
  tertiary-fixed-dim: '#adc6ff'
  on-tertiary-fixed: '#001a42'
  on-tertiary-fixed-variant: '#004395'
  background: '#0b1326'
  on-background: '#dae2fd'
  surface-variant: '#2d3449'
typography:
  headline-lg:
    fontFamily: Space Grotesk
    fontSize: 30px
    fontWeight: '600'
    lineHeight: 38px
    letterSpacing: -0.02em
  headline-md:
    fontFamily: Space Grotesk
    fontSize: 22px
    fontWeight: '600'
    lineHeight: 28px
    letterSpacing: -0.015em
  headline-sm:
    fontFamily: Space Grotesk
    fontSize: 18px
    fontWeight: '600'
    lineHeight: 24px
    letterSpacing: -0.01em
  title-md:
    fontFamily: Inter
    fontSize: 16px
    fontWeight: '600'
    lineHeight: 22px
    letterSpacing: -0.005em
  body-lg:
    fontFamily: Inter
    fontSize: 16px
    fontWeight: '400'
    lineHeight: 24px
  body-md:
    fontFamily: Inter
    fontSize: 14px
    fontWeight: '400'
    lineHeight: 20px
  body-sm:
    fontFamily: Inter
    fontSize: 12px
    fontWeight: '400'
    lineHeight: 16px
  label-lg:
    fontFamily: Inter
    fontSize: 14px
    fontWeight: '500'
    lineHeight: 18px
    letterSpacing: 0.01em
  label-md:
    fontFamily: Inter
    fontSize: 12px
    fontWeight: '500'
    lineHeight: 16px
    letterSpacing: 0.02em
  label-sm:
    fontFamily: Inter
    fontSize: 10px
    fontWeight: '600'
    lineHeight: 14px
    letterSpacing: 0.05em
rounded:
  sm: 0.25rem
  DEFAULT: 0.5rem
  md: 0.75rem
  lg: 1rem
  xl: 1.5rem
  full: 9999px
spacing:
  gutter: 1rem
  margin: 1rem
  space-xs: 0.25rem
  space-sm: 0.5rem
  space-md: 1rem
  space-lg: 1.25rem
  space-xl: 1.75rem
---

## Brand & Style

This design system pairs the utilitarian clarity of structured survey design with an atmospheric dark mode aesthetic. Designed for technical professionals, creators, and modern enterprise teams participating in high-velocity data gathering and feedback loops, the aesthetic merges technical rigor with subtle digital illumination.

### Visual Aesthetic
The style is **Atmospheric Precision**:
- Layered deep navy and slate planes create structured architectural hierarchy without blinding white sheets.
- Google Forms–inspired single-focus modularity: discrete, carded inquiry blocks, highlighted active states, and unmistakable progression signifiers.
- Restrained luminescent accents (electric indigo, glowing violet, and vivid royal blue) that act as functional beacons rather than decorative clutter.
- High contrast legibility: sharp, bright white for primary questions and response values, paired with subdued slate tones for secondary hints, validation instructions, and metadata.

## Colors

The palette relies on deep oceanic darks accented by luminescent violet-indigo spectrums, engineered specifically for OLED/mobile legibility and low-light eye comfort.

### Surfaces & Backgrounds
- **Canvas Base (`#0a0f1d`)**: The root canvas background, grounding the entire interface in deep abyss navy.
- **Card / Surface Default (`#0f172a`)**: Slate navy applied to standard question containers and persistent cards.
- **Surface Raised / Active (`#1e293b`)**: Elevated containers, expanded selection items, bottom sheets, and elevated overlays.
- **Surface Inset (`#080d19`)**: Input field wells and inactive checkbox/radio track beds.

### Accents & Luminescence
- **Primary Violet (`#8b5cf6`)**: Key focal point indicator. Used for active selection rings, primary interactive toggles, selected radio centroids, and focus indicators.
- **Secondary Indigo (`#6366f1`)**: Supporting structural action tone. Used for global submit controls, progress bars, and header active tabs.
- **Tertiary Royal Blue (`#3b82f6`)**: Informational accents, badge highlights, active drag handles, and external links.

### Text & Feedback
- **Text Primary (`#f8fafc`)**: 97% pure white for questions, typed entries, and primary action labels.
- **Text Secondary (`#94a3b8`)**: Cool slate for question descriptions, helper instructions, timestamps, and placeholder copy.
- **Text Disabled (`#475569`)**: Muted slate for non-interactive indicators and inactive controls.
- **Border Subtle (`#1e293b`)**: Structural boundaries for resting cards.
- **Border Active (`#8b5cf6`)**: Glowing focal border identifying the active question card.
- **Error State (`#f43f5e`)**: Vibrant rose red for required field omissions and input validation errors.

## Typography

The type scale combines the technical precision of **Space Grotesk** for form headers and section demarcations with the neutral, high-legibility qualities of **Inter** for questions, inputs, and feedback messages.

### Hierarchy & Usage
- **Space Grotesk**: Reserved for form titles, section markers, progress indicators, and confirmation screens. It conveys structural precision without compromising space efficiency.
- **Inter**: Drives the core survey mechanics. Its generous x-height and clear apertures ensure zero misinterpretation of dense option lists, complex question descriptions, and microcopy on compact mobile touchscreens.
- Form question titles use `title-md` with semibold weight to establish distinct separation from option labels, which use `body-md` in regular weight.
- Dynamic placeholders and helper texts adhere strictly to `body-sm` in secondary slate (`#94a3b8`).

## Layout & Spacing

The layout model is optimized for single-column, thumb-driven interaction on mobile devices, standardizing touch zones while keeping vertical scroll fatigue minimal.

### Mobile Grid & Canvas Model
- **Canvas Margins**: Fixed `1rem` (16px) margins flank the screen on compact viewports, allowing input containers to span full bleed within the safe area.
- **Card Flow**: Questions sit inside discrete modular blocks stacked with a strict `1.25rem` (`space-lg`) vertical cadence, establishing unmistakable separation between discrete questions.
- **Internal Density**:
  - Question card interiors utilize `1.25rem` padding on top and sides, relaxing to `1rem` at the bottom to balance spacing around action buttons.
  - Interactive radio and checkbox hit targets provide a minimum vertical touch height of `48px` with `0.75rem` vertical spacing between selectable rows.

## Elevation & Depth

Visual hierarchy uses tonal surface layering combined with low-radius, colored luminescent halos to mark focus and activity.

### Hierarchy Layers
- **Level 0 (Canvas Base)**: `#0a0f1d` with zero shadow.
- **Level 1 (Default Question Card)**: Surface `#0f172a` wrapped in a crisp 1px stroke of `#1e293b`. No drop shadow. Blends securely into background hierarchy.
- **Level 2 (Active Question Focus)**: Elevates with a subtle background shift to `#141f36`, a vivid `1.5px` border of primary violet (`#8b5cf6`), and an ambient exterior glow: `box-shadow: 0 0 16px -2px rgba(139, 92, 246, 0.25)`. A solid 4px accent stripe hugs the left card perimeter.
- **Level 3 (Sticky Bottom Bar & Overlays)**: Surface `#0f172a` at 90% opacity with a `16px` backdrop-filter blur, sealed with a 1px top border of `#1e293b` and an ambient directional shadow: `0 -8px 24px -4px rgba(0, 0, 0, 0.6)`.

## Shapes

The design uses a balanced `rounded-md` base (8px) for input containers and structural cards, transitioning to full pill geometry for standalone micro-elements.

### Geometry Specifications
- **Cards & Question Blocks**: `0.75rem` (12px) exterior radius for a smooth, modern surface contour.
- **Text Inputs & Option Plates**: `0.5rem` (8px) interior corner radius.
- **Checkboxes**: `0.375rem` (6px) rounded corners, avoiding sharp boxiness while preserving a squarish identity distinct from circular radio controls.
- **Radio Buttons & Pills**: 9999px full circular and pill curvature for option chips, status badges, and progression pills.

## Components

### 1. Question Cards (Google Forms Adaptation)
- **Resting Card**: Background `#0f172a`, border 1px solid `#1e293b`, 12px corner radius. Title in `title-md` (`#f8fafc`). Helper description in `body-sm` (`#94a3b8`).
- **Focused Card**: Background `#141f36`, 1.5px solid `#8b5cf6`, left edge features an integrated 4px primary violet vertical pill tab. Radiates a subtle ambient purple glow.
- **Required Indicator**: Asterisk colored in vibrant rose `#f43f5e`.

### 2. Form Inputs (Text & Textarea)
- **Inline Single-Line Field**: Google Forms style clean bottom rule or boxed well. Preferred mobile variant is an inset well (`#080d19`) with a 1px border `#1e293b`, transitioning to an animated 2px `#8b5cf6` bottom border upon keyboard focus.
- **Typography**: Typed text in `body-md` (`#f8fafc`); placeholder text in `body-md` (`#475569`).

### 3. Radio Buttons & Checkboxes
- **Radio Buttons**:
  - Unchecked: 20px outer circle, 2px border `#334155`, transparent fill.
  - Checked: 20px outer circle with border `#8b5cf6`, fill `#8b5cf6` with a crisp 8px center dot of pure white `#ffffff`, accompanied by a 4px soft purple glow outline (`rgba(139, 92, 246, 0.3)`).
- **Checkboxes**:
  - Unchecked: 20px square with 5px radius, 2px border `#334155`, transparent fill.
  - Checked: Fill `#8b5cf6`, border `#8b5cf6`, housing a sharp `#ffffff` checkmark icon.
- **Interactive Option Row**: Entire row is wrapped in a full-width touch cell (`min-height: 48px`). When selected, the container gains a tinted surface overlay of `rgba(139, 92, 246, 0.08)` and a subtle border highlight.

### 4. Buttons
- **Primary Action (Submit / Continue)**: Full-width or auto-width pill/rounded-md with solid `#6366f1` transitioning across a diagonal gradient to `#8b5cf6`. Text `#ffffff`, weight `label-lg`. Pressed state scales subtly to `0.98`.
- **Secondary / Clear**: Ghost style with `#94a3b8` text, hover/active surface of `rgba(255, 255, 255, 0.05)`, no border.

### 5. Chips & Scale Rating
- **Linear Scale (1–5 / 1–10)**: Horizontal row of pill chips. Unselected chips have `#0f172a` fill and `#1e293b` border with `#94a3b8` text. Selected chip ignites in `#8b5cf6` fill, `#ffffff` bold text, and a distinct purple luminescent glow.

### 6. Progress Header
- Pinned beneath the status bar or form title. A continuous 4px track (`#1e293b`) filled by a vibrant gradient bar (`#3b82f6` to `#8b5cf6`) denoting completion percentage, accompanied by a clean `label-sm` counter (`#94a3b8`).
