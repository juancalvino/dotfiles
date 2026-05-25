---
name: kanata-configurator
description: >
  Designs and explains minimal Kanata keyboard configuration snippets for remaps,
  layers, tap-hold behaviors, and Vim-aware layouts, with a macOS-first bias.
  Use this skill whenever the user wants to configure Kanata, compare Kanata
  primitives, design keyboard layers or modes, adapt Vim navigation to a custom
  layout, or asks for a `.kbd` snippet instead of a full config.
license: Apache-2.0
metadata:
  author: gentle-orchestrator
  version: "1.0"
---

## Purpose

Use this skill to produce small, correct Kanata configuration fragments for keyboard behavior changes.

Scope for v1:
- Kanata configuration design only
- macOS-first guidance
- Vim-aware recommendations
- Minimal snippets, not full configs

Out of scope for v1:
- Installation
- Drivers
- Permissions
- Launch agents
- Background service setup

## First Response

Ask for the minimum context needed before proposing a snippet:
- Goal: what behavior should change?
- Platform confirmation: macOS unless the user says otherwise
- Layout context: QWERTY, Colemak, or another layout
- Scope: one key remap, a layer, a mode, tap-hold behavior, or a Vim profile
- Trigger key: user-chosen if a trigger is needed

If the user already gave enough context, do not ask again. Move straight to the design.

## Diagnosis Framework

Classify the request into exactly one primary shape first:

| Request shape | Prefer | Why |
|---|---|---|
| Simple remap | `deflayermap` | Sparse changes are shorter and safer when most keys stay unchanged |
| Sparse layer | `deflayermap` | It avoids copying a full source layer just to change a few keys |
| Whole layer / highly readable layer | `deflayer` | Full layer definitions are easier to scan when many positions matter |
| Momentary layer | `layer-while-held` | The layer exists only while the chosen trigger is held |
| Persistent mode toggle | `layer-toggle` or `toggle-vkey` | Persistent state should be explicit rather than inferred from hold timing |
| Tap-hold key | `tap-hold` | One physical key needs distinct tap and hold meanings |
| One-time modifier or one-time mode helper | `one-shot` | The effect should expire after the next keypress |
| Vim profile | Base remap plus mode/layer primitive | Vim-oriented behavior usually combines layout adaptation with a mode boundary |

## Primitive Selection Rules

Always explain why the chosen primitive fits better than the closest alternative.

Required comparisons:
- `deflayermap` vs `deflayer`
- `layer-while-held` vs `layer-toggle`
- `tap-hold` vs a dedicated layer trigger
- `toggle-vkey` with `defvirtualkeys` vs toggling a physical key directly
- `_` transparent vs `use-defsrc`

Selection defaults:
- Prefer `deflayermap` for sparse remaps.
- Prefer `deflayer` for whole layers or when visual readability matters more than brevity.
- Use `_` when inheriting from the active lower layer is the clearest mental model.
- Use `use-defsrc` when you want explicit fallback to the physical source mapping across a full layer.
- Keep `defcfg` minimal, but mention `process-unmapped-keys` when passthrough behavior matters.
- On macOS, mention `macos-dev-names-include` when device targeting matters.

## Output Contract

Return these sections in this order:

1. `Diagnosis:` one short sentence naming the request shape.
2. `Design decision:` one short sentence naming the primitive choice and why.
3. `Minimal .kbd snippet:` a focused snippet only.
4. `Explanation:` 2-4 short bullets.
5. `Validation checklist:` short actionable bullets.
6. `Rollback note:` one short conceptual note.

Do not output a full standalone config unless the user explicitly asks for it.
Do not pick a canonical trigger key. Use a placeholder like `<your-trigger-key>` or the user's chosen key.

## Snippet Rules

- Include only the forms needed for the requested change.
- Use official Kanata concepts and names consistently: `defsrc`, `deflayer`, `deflayermap`, `defcfg`, `process-unmapped-keys`, `_`, `use-defsrc`, `layer-switch`, `layer-while-held`, `layer-toggle`, `tap-hold`, `one-shot`, `defvirtualkeys`, `toggle-vkey`, `lrld`, `kanata --check`, `kanata --list`, `macos-dev-names-include`.
- If a snippet depends on an existing `defsrc`, say so instead of recreating unrelated keys.
- Keep examples generic and user-editable.

## Safety Expectations

Always mention validation and rollback conceptually:
- Validate syntax before switching to the config in real use.
- Prefer testing one change at a time.
- Keep a known-good config or reversible edit path.
- Mention `kanata --check` for syntax validation.
- Mention `kanata --list` when device naming or discovery matters.
- Mention `lrld` as the conceptual live-reload path when the user is already using reload-based iteration.

Do not provide operational setup instructions for validation tooling beyond the config-design context.

## Response Patterns

### Pattern 1: Simple sparse remap

Use `deflayermap` when only a few keys change.

```kbd
(deflayermap base
  caps esc
)
```

Explain that `deflayermap` is better than `deflayer` here because copying an entire layer would add noise without adding clarity.

### Pattern 2: Momentary navigation layer

Use a user-chosen trigger with `layer-while-held`.

```kbd
(deflayermap base
  <your-trigger-key> (layer-while-held nav)
)

(deflayer nav
  _ _ _ _ _
  _ left down up right
  _ _ _ _ _
)
```

Explain that `layer-while-held` is better than `layer-toggle` because navigation is usually transient and should end when the trigger is released.

### Pattern 3: Persistent Vim mode toggle

If the user wants a durable mode boundary, prefer an explicit toggle.

```kbd
(defvirtualkeys
  vim_mode (layer-toggle vim)
)

(deflayermap base
  <your-trigger-key> (toggle-vkey vim_mode)
)
```

Explain that `defvirtualkeys` plus `toggle-vkey` keeps the mode semantics separate from the physical trigger key and is easier to evolve later.

### Pattern 4: Tap-hold behavior

```kbd
(deflayermap base
  <your-trigger-key> (tap-hold 200 esc (layer-while-held nav))
)
```

Explain that `tap-hold` is appropriate because one key has two meanings, while a plain layer trigger would lose the tap behavior.

### Pattern 5: Colemak on macOS with Vim-aware remaps

Use minimal Vim-targeted changes instead of remapping the whole editor model unless the user asks for a broader profile.

```kbd
(defcfg
  process-unmapped-keys yes
  macos-dev-names-include ("Your Keyboard Name")
)

(deflayermap base
  n j
  e k
  i l
)
```

Explain that the snippet is intentionally minimal: it adapts the most important navigation motions without forcing a full Vim remap strategy.

## Reference Files

Read these as needed:
- `references/kanata-primitives.md`: primitive-by-primitive selection guidance
- `references/kanata-patterns.md`: common configuration shapes and decision rules
- `references/macos-notes.md`: macOS-specific notes, especially device targeting
- `references/vim-colemak-patterns.md`: Vim-aware and Colemak-oriented patterns
- `references/safety-and-rollback.md`: validation, reload, and rollback concepts
