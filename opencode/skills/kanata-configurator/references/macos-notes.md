## macOS Notes

This skill is macOS-first, so mention macOS-specific configuration concerns only when they affect the snippet design.

## Device Targeting

### `macos-dev-names-include`

Use this in `defcfg` when the user wants the config scoped to one or more keyboards.

Why include it:
- macOS users often have multiple keyboards or laptop-plus-external setups.
- Device scoping prevents accidental application to every keyboard.

Why not include it by default in every answer:
- A minimal snippet should not assume device pinning unless the user needs it.

Example:

```kbd
(defcfg
  macos-dev-names-include ("Your Keyboard Name")
)
```

## Unmapped Keys

### `process-unmapped-keys`

Mention `process-unmapped-keys` when passthrough behavior or partial remaps are relevant.

Typical use:

```kbd
(defcfg
  process-unmapped-keys yes
)
```

Why it matters:
- Sparse remaps are common on macOS.
- The user may expect untouched keys to keep working normally.

## Device Discovery And Validation

Mention these conceptually when relevant:
- `kanata --list` to inspect available device names
- `kanata --check` to validate syntax before broader use
- `lrld` if the user already works with live reload

Do not turn this file into an installation or service guide.

## macOS-First Design Bias

- Prefer minimal snippets that can be dropped into an existing config.
- Avoid assumptions about one universal Apple keyboard layout.
- Treat the trigger key as user-chosen.
- When discussing Vim or Colemak patterns, talk about motion intent before key legends.
