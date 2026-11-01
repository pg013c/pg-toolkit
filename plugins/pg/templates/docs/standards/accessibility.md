# Accessibility standards

Target: WCAG 2.2 level AA, which is also what the European Accessibility Act points to for many consumer products.

## Structure

- **A11Y-01** Native HTML elements first: `button` for actions, `a` for navigation, real `label`s for inputs, headings in order, landmarks (`header`, `nav`, `main`). ARIA only where HTML has no element for it.
- **A11Y-02** Every page has a unique, descriptive title and a language attribute.
- **A11Y-03** Images that carry meaning have alternative text; decorative ones have empty `alt`.

## Keyboard and focus

- **A11Y-10** Everything that works with a mouse works with a keyboard, in a logical order, with no keyboard traps.
- **A11Y-11** Focus is always visible. Dialogs move focus in, keep it inside while open, and return it on close.
- **A11Y-12** Targets are at least 24 by 24 CSS pixels.

## Perception

- **A11Y-20** Text contrast is at least 4.5:1 (3:1 for large text and for UI component edges). Colour is never the only way information is shown.
- **A11Y-21** Content reflows at 320 CSS pixels wide and stays usable at 200 % zoom.
- **A11Y-22** Motion and animation respect `prefers-reduced-motion`; nothing flashes more than three times a second.

## Forms and feedback

- **A11Y-30** Errors are announced, say what went wrong and how to fix it, and are tied to their field. Required fields are marked in text, not only by colour or an asterisk.
- **A11Y-31** Dynamic updates that matter (results loaded, saved, failed) are announced through a live region.

## Verification

- **A11Y-40** An automated checker (for example axe) runs in component or end-to-end tests on every page or main component, and a failure fails the build.
- **A11Y-41** A new screen is tried once with the keyboard only and once with a screen reader before release.
