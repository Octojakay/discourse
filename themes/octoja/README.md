# octoja Discourse Theme

A Discourse theme shaped to feel closer to the octoja RMM product without taking ownership of core forum behavior that Discourse already does well.

## Goals

- Reuse octoja brand tokens, density, status semantics, and calm monitoring-oriented visual language.
- Keep the theme maintainable across Discourse updates by preferring color schemes, CSS custom properties, native theme entrypoints, and additive overrides.
- Make the highest-traffic Discourse surfaces feel closer to an RMM: sidebar, discovery lists, topic view, composer, and notifications.

## Native Theme Architecture

This repo now uses Discourse's native theme entrypoints instead of a monolithic stylesheet plus duplicate JS implementations.

- `about.json`
  Defines the paired `octoja Dark` and `octoja Light` color schemes.
- `common/color_definitions.scss`
  Defines custom color variables that need to switch correctly across light and dark schemes.
- `common/common.scss`
  Imports shared SCSS modules from the root `scss/shared` directory.
- `desktop/desktop.scss`
  Imports desktop-first discovery and topic-page modules from `scss/desktop`.
- `mobile/mobile.scss`
  Imports mobile overrides from `scss/mobile`.
- `common/head_tag.html`
  Loads the product fonts.

## RMM Surface Mapping

| octoja / RMM surface | Discourse surface | First-pass implementation |
| --- | --- | --- |
| App sidebar / module rail | Discourse sidebar | Compact row heights, neutral surfaces, stronger section labels, utility-like hover states |
| Overview tables (devices, alerts, checks) | Topic lists on Latest, Categories, Tags | Dense table styling, mono metrics, row-state accents, calmer spacing, module-chip styling |
| Device detail / event stream | Topic page and topic timeline | Panel-like topic posts, cleaner event separators, status-oriented notices |
| Notes / runbook editor | Composer | Compact utility controls, stronger focus state, reduced decoration |
| Alert tray | Notifications / user menu | Dense panel styling with clear unread state |
| Technical article / KB | Cooked topic content | Better tables, mono for machine values, restrained callouts |

## Best-Practice Decisions In This Refactor

- Native Discourse light/dark mode is now the source of truth.
  The theme no longer ships a custom color-mode toggle or custom `data-octo-mode` state.
- The repo is now the source of truth for packaging.
  `build-discourse-theme.js` packages this directory directly instead of generating a second copy of the theme in code.
- CSS is split by concern.
  Imported SCSS lives under the root `scss/` directory, which is the structure Discourse expects for multi-file theme stylesheets.
- Additive overrides only.
  The refactor avoids replacing core templates or taking ownership of full topic-row markup.

## Development Workflow

1. Use the Discourse Theme CLI for live iteration against a dev forum.
2. Keep the paired `octoja Dark` and `octoja Light` palettes assigned in Discourse admin.
3. Use `/styleguide` on the target Discourse instance to validate color variables, controls, and component states.
4. Use `node build-discourse-theme.js` when you need a tarball for import.

## Recommended Next Phases

1. Add category-specific module accents for support, docs, alerts, and release streams.
2. Add optional topic-list transformers for small metadata enhancements if the UI needs more operational context.
3. Split stable parts of this theme into reusable Discourse theme components once the first-pass design settles.
