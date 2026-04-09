# Image Asset Workflow

This guide documents how to source, isolate, and prepare image assets for Meta Box image fields and MB View templates.

## Purpose

Use a repeatable pipeline for isolated product images, icons, decorative elements, and other assets that often need background removal before they can be placed cleanly in a layout.

## The Pipeline

1. Source or generate the base image
2. Isolate the specific element needed
3. Remove the background to produce a transparent PNG
4. Upload the result through a Meta Box image field
5. Position and scale the asset in MB View CSS

## Tool Options By Capability

| Need | Tool | Cost | Notes |
|------|------|------|-------|
| Generate mockup | Midjourney, DALL-E, Flux, Qwen Image | Varies | Any current AI image tool is acceptable |
| Generate with transparent background directly | Qwen Image Edit or newer tools with native transparency | Varies | Fastest path when supported |
| Extract element from a larger composition | Qwen Image Edit, Photoshop, Photopea | Free to paid | AI or manual crop-isolation both work |
| Remove background from isolated element | Remove.bg | Free tier or paid | Strong default for clean product shots |
| Manual precision background removal | Photopea | Free | Useful for metallic or reflective objects |
| All-in-one workflow | modern AI image tools that both isolate and export transparency | Varies | Preferred when reliable |

## Recommended Workflow (2026)

1. Generate the mockup in an AI image tool or source the original asset
2. Ask the tool to isolate the exact element you want to keep
3. If the tool can export transparent PNG directly, use that output
4. If it cannot, pass the isolated image through Remove.bg
5. Download the final transparent PNG
6. Upload it to WordPress through the relevant Meta Box image field
7. Use MB View CSS to position, scale, and, when useful, bleed the asset outside the section bounds

## CSS Patterns For Positioned Hero Images

### Product image overlapping the right edge of a hero

```css
.mv-hero {
  position: relative;
  overflow: visible;
}

.mv-hero--product {
  position: absolute;
  right: calc(var(--space-lg) * -1);
  bottom: 0;
  width: min(28rem, 42vw);
}

@media (max-width: 900px) {
  .mv-hero--product {
    position: static;
    width: min(20rem, 80vw);
    margin: 0 auto;
  }
}
```

### Product image centered above a headline

```css
.mv-hero--media {
  display: grid;
  justify-items: center;
  gap: var(--space-md);
}

.mv-hero--media img {
  width: min(18rem, 60vw);
}
```

### Icon grid using transparent PNG icons

```css
.mv-features--grid {
  display: grid;
  grid-template-columns: repeat(3, 1fr);
  gap: var(--space-lg);
}

.mv-features--icon {
  width: 3rem;
  aspect-ratio: 1;
  object-fit: contain;
}
```

### Decorative element bleeding off the section edge

```css
.mv-section {
  position: relative;
  overflow: hidden;
}

.mv-section--flare {
  position: absolute;
  top: calc(var(--space-xl) * -1);
  left: calc(var(--space-lg) * -1);
  width: min(16rem, 30vw);
  pointer-events: none;
  opacity: 0.9;
}
```

## Fallback Workflows

- if Remove.bg struggles with edges, especially with metallic objects or low-contrast surfaces, use Photopea's pen tool for manual cleanup
- if no AI image tool is available, crop the source manually first and then run background removal on the tighter crop

## What The Stack Does Not Handle

- image generation itself, which happens outside the stack
- complex photo retouching or color correction
- vector illustration creation, which belongs in a vector design tool before export or inline SVG use

## Cross-Reference

See `DESIGN_SYSTEM_GUIDE.md` when the asset is part of a hero, product card, or other section that must still obey the shared spacing, layout, and naming rules.