## Kanata Primitives

Use this file when the main question is which Kanata building block fits the request.

## Core Structure

### `defsrc`

Use `defsrc` to establish the physical source positions the rest of the config refers to.

Why it matters:
- It gives positional meaning to later layer definitions.
- It prevents snippets from drifting into symbolic remaps without a source model.

Use it when:
- The snippet depends on source-key positions.
- The user is defining or clarifying a base layout.

### `deflayer`

Use `deflayer` when many positions in a layer matter or when the user needs a visually readable matrix.

Prefer it over `deflayermap` when:
- The layer is dense.
- Readability of the whole layer is more important than brevity.
- Transparent inheritance with `_` is part of the design.

Tradeoff:
- More verbose for small changes.

### `deflayermap`

Use `deflayermap` for sparse remaps and focused edits to an existing layer.

Prefer it over `deflayer` when:
- Only a few keys change.
- The base behavior should remain implicit.
- The user asked for a minimal snippet.

Tradeoff:
- Less visually complete than a full layer matrix.

### `defcfg`

Use `defcfg` only for config-level behavior relevant to the requested snippet.

Relevant v1 items:
- `process-unmapped-keys`
- `macos-dev-names-include`

Keep it minimal. Do not expand into setup or runtime instructions.

## Inheritance And Fallback

### `_` transparent

Use `_` inside `deflayer` when the key should fall through to the lower layer stack.

Choose `_` when:
- You are thinking in terms of layer inheritance.
- Only a few positions in a full layer should differ.

Why not `use-defsrc`:
- `_` describes transparency in the active layer stack.
- `use-defsrc` describes fallback to the physical source mapping.

### `use-defsrc`

Use `use-defsrc` when a layer should explicitly reuse the `defsrc` mapping for unspecified behavior.

Choose it when:
- You want explicit source-based fallback.
- The layer should stay tied to the physical source arrangement.

Why not `_`:
- `_` depends on lower active layers.
- `use-defsrc` expresses a more direct, source-oriented baseline.

## Layer Control

### `layer-switch`

Use `layer-switch` when the user wants to jump into a different layer as the active context rather than momentarily holding it.

Why not `layer-while-held`:
- `layer-switch` changes the current layer state.
- `layer-while-held` is inherently transient.

### `layer-while-held`

Use this for temporary access to a layer while a chosen key is held.

Best for:
- Navigation layers
- Symbols on hold
- Temporary editing helpers

Why prefer it over `layer-toggle` for transient tasks:
- Release ends the mode automatically.
- Lower cognitive overhead for short bursts.

### `layer-toggle`

Use this when the user wants a persistent mode that stays active across multiple keypresses.

Best for:
- Vim-like modes
- Long-lived symbol or app-control modes

Why not `layer-while-held`:
- Hold-based access is wrong for durable modes.

## Dual-Role And Temporary State

### `tap-hold`

Use `tap-hold` when one physical key needs a tap action and a hold action.

Best for:
- Escape on tap, layer on hold
- Space on tap, modifier on hold

Why not a dedicated trigger key:
- The user wants two meanings on one key.

Tradeoff:
- Timing sensitivity needs validation.

### `one-shot`

Use `one-shot` when the effect should apply to the next keypress and then expire.

Best for:
- One-time modifiers
- One-time helper states

Why not `layer-toggle`:
- Toggle is persistent.
- One-shot expires automatically.

## Virtual Keys

### `defvirtualkeys`

Use `defvirtualkeys` to name reusable virtual behaviors separate from physical keys.

Why it helps:
- It decouples behavior from the trigger key.
- It improves reuse and future refactoring.

### `toggle-vkey`

Use `toggle-vkey` with a `defvirtualkeys` entry when the user wants a named persistent mode toggle.

Why prefer it over embedding `layer-toggle` directly in a physical mapping:
- The virtual key becomes a stable semantic handle.
- The physical trigger remains user-chosen and swappable.

## Validation Concepts

- Mention `kanata --check` for syntax validation.
- Mention `kanata --list` if device names matter.
- Mention `lrld` when the user is iterating with reloads.
- Always mention rollback as keeping a known-good config path.
