# Vim and Colemak patterns in Karabiner

Use this file when the user wants modal editor ergonomics, especially on Colemak.

## Core mental model

Vim users usually think in logical letters such as `h`, `j`, `k`, `l`.
Karabiner still needs physical key codes.

On macOS system layouts like Colemak, always translate the logical target back to the physical key code that produces it.

## Pattern: modal Vim remaps

Best structure:
- one toggle key flips `vim_mode`
- several `basic` manipulators are gated by `variable_if`
- optional `frontmost_application_if` restricts them to Ghostty or another terminal

## Pattern: Ghostty-only Vim mode

Use both:
- `variable_if` for mode state
- `frontmost_application_if` for Ghostty scope

This avoids global remaps leaking into normal typing.

## Pattern: Caps to Esc

For Vim-heavy workflows, `caps_lock -> escape` is usually a plain direct remap.

If the user wants it only inside a mode or app, add the appropriate conditions.

## Pattern: shifted home-row block

If the user wants a special cluster such as:
- Colemak logical `hneio`
- becoming Vim-like `ghjkl`

explain explicitly that Karabiner will still need the corresponding physical key codes, not just the visible letters.

## Good explanation style

When giving a snippet, state all three layers of reasoning:
- what the user wants logically
- which physical key codes Karabiner must match
- why the conditions or variable gates are attached where they are
