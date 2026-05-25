---
name: karabiner-configurator
description: Designs and explains minimal Karabiner-Elements JSON rules for macOS. Use this skill whenever the user wants Karabiner remaps, complex modifications, modal toggles with variables, app-specific rules (for example Ghostty-only behavior), device-specific rules, Caps/Esc behavior, or Vim-aware keyboard flows on macOS.
---

# Skill: karabiner-configurator

## Purpose

Use this skill to produce small, correct Karabiner-Elements rule snippets for macOS keyboard behavior changes.

Scope for v1:
- Karabiner rule design only
- macOS-only guidance
- Vim-aware recommendations
- Minimal JSON snippets, not full `karabiner.json`

Out of scope for v1:
- Installation
- Permissions
- Applying or merging rules into `karabiner.json`
- Launch or startup automation
- Editing files automatically unless the user explicitly asks

## First Response

Ask for the minimum context needed before proposing a rule:
- Goal: what behavior should change?
- Scope: global, app-specific, or device-specific?
- Layout context: QWERTY, Colemak, or another layout?
- Trigger style: simple remap, hold behavior, persistent mode toggle, or app-scoped mode?
- Trigger key: user-chosen if needed

If the user already gave enough context, do not ask again. Move straight to the design.

## Diagnosis Framework

Classify the request into exactly one primary shape first:

| Request shape | Prefer | Why |
|---|---|---|
| Simple remap | one `basic` manipulator | Shortest and clearest rule when one key changes |
| Sparse modal remap | variable-gated manipulators | Karabiner models modes with variables, not native layers |
| App-specific remap | `frontmost_application_if` | Scope stays local to the intended app |
| Device-specific remap | `device_if` | Restricts the rule to one keyboard or class of keyboards |
| Persistent mode toggle | `set_variable` + `variable_if` | Explicit state is more reliable than trying to infer mode |
| Tap vs hold behavior | `to_if_alone` / `to_if_held_down` | One physical key needs two meanings |
| Vim profile | variable-gated remaps, often with app scope | Vim-like behavior needs a clear mode boundary |

## Primitive Selection Rules

Always explain why the chosen primitive fits better than the closest alternative.

Required comparisons:
- simple manipulator vs variable-gated manipulators
- `frontmost_application_if` vs global rules
- `device_if` vs app scoping
- `set_variable` + `variable_if` vs trying to fake a layer implicitly
- `to_if_alone` / `to_if_held_down` vs a dedicated trigger key

Selection defaults:
- Prefer one `basic` manipulator for a single remap.
- Prefer `set_variable` with `variable_if` or `variable_unless` for persistent modes.
- Prefer `frontmost_application_if` whenever the user mentions a specific app such as Ghostty.
- Prefer `device_if` only when hardware targeting matters more than app targeting.
- Use `vk_none` when you need a key event to toggle state without also typing a character.
- Use `to_if_alone` and `to_if_held_down` when the same physical key needs tap and hold meanings.

## Karabiner Mental Model

Always remind the user of these points when relevant:
- Karabiner works on physical key codes and modifier events.
- Karabiner does not have native firmware-like layers; “layers” are modeled through conditional rules.
- App-specific behavior should usually be expressed with `frontmost_application_if`.
- Persistent modes should usually be expressed with variables rather than duplicated profiles.
- On non-QWERTY system layouts, target output still has to be reasoned about in terms of physical key codes.

## Output Contract

Return these sections in this order:

1. `Diagnosis:` one short sentence naming the request shape.
2. `Design decision:` one short sentence naming the primitive choice and why.
3. `Minimal JSON snippet:` a focused snippet only.
4. `Explanation:` 2-4 short bullets.
5. `Validation checklist:` short actionable bullets.
6. `Rollback note:` one short conceptual note.

Do not output a full `karabiner.json` unless the user explicitly asks for it.

## Snippet Rules

- Include only the manipulators and conditions needed for the request.
- Use official Karabiner names consistently: `type: basic`, `from`, `to`, `conditions`, `frontmost_application_if`, `device_if`, `set_variable`, `variable_if`, `variable_unless`, `to_if_alone`, `to_if_held_down`, `to_after_key_up`, `to_delayed_action`, `vk_none`.
- If the snippet depends on an existing profile, say so instead of inventing unrelated top-level JSON.
- Keep examples generic and user-editable.

## Safety Expectations

Always mention validation and rollback conceptually:
- Test rules in small increments.
- Use Karabiner-EventViewer to confirm frontmost app identifiers and physical key events.
- Keep the old complex modification disabled or removable.
- Prefer one toggle variable and a few gated rules before expanding into a full mode.

## Response Patterns

### Pattern 1: Simple remap

```json
{
  "description": "Change caps_lock to escape",
  "manipulators": [
    {
      "type": "basic",
      "from": {
        "key_code": "caps_lock",
        "modifiers": { "optional": ["any"] }
      },
      "to": [{ "key_code": "escape" }]
    }
  ]
}
```

Explain that a single `basic` manipulator is better than introducing a variable because there is no real mode state to track.

### Pattern 2: App-specific remap

```json
{
  "description": "Change caps_lock to escape only in Ghostty",
  "manipulators": [
    {
      "type": "basic",
      "from": {
        "key_code": "caps_lock",
        "modifiers": { "optional": ["any"] }
      },
      "to": [{ "key_code": "escape" }],
      "conditions": [
        {
          "type": "frontmost_application_if",
          "bundle_identifiers": ["^com\\.mitchellh\\.ghostty$"]
        }
      ]
    }
  ]
}
```

Explain that app scoping should be attached directly to the manipulator instead of creating a global rule and trying to work around it later.

### Pattern 3: Persistent mode toggle

```json
{
  "description": "Toggle a Vim mode with right_command",
  "manipulators": [
    {
      "type": "basic",
      "from": {
        "key_code": "right_command",
        "modifiers": { "optional": ["any"] }
      },
      "to": [
        {
          "set_variable": {
            "name": "vim_mode",
            "expression": "vim_mode != 0 ? 0 : 1"
          }
        },
        { "key_code": "vk_none" }
      ]
    }
  ]
}
```

Explain that Karabiner modes are not native layers, so the durable state belongs in a variable.

### Pattern 4: Variable-gated remap

```json
{
  "description": "Map n to h when vim_mode is active",
  "manipulators": [
    {
      "type": "basic",
      "from": {
        "key_code": "j",
        "modifiers": { "optional": ["any"] }
      },
      "to": [{ "key_code": "h" }],
      "conditions": [
        {
          "type": "variable_if",
          "name": "vim_mode",
          "value": 1
        }
      ]
    }
  ]
}
```

Explain that on Colemak-like setups the user may describe logical letters, but Karabiner still has to target the physical key codes that produce those letters.

### Pattern 5: App-scoped Vim mode

```json
{
  "description": "Apply Vim mode only in Ghostty",
  "manipulators": [
    {
      "type": "basic",
      "from": {
        "key_code": "j",
        "modifiers": { "optional": ["any"] }
      },
      "to": [{ "key_code": "h" }],
      "conditions": [
        {
          "type": "variable_if",
          "name": "vim_mode",
          "value": 1
        },
        {
          "type": "frontmost_application_if",
          "bundle_identifiers": ["^com\\.mitchellh\\.ghostty$"]
        }
      ]
    }
  ]
}
```

Explain that variable state answers “is the mode on?” and app scope answers “where should it apply?”; those are separate concerns and should stay separate.

## Reference Files

Read these as needed:
- `references/karabiner-primitives.md`: primitive-by-primitive selection guidance
- `references/karabiner-patterns.md`: common configuration shapes and decision rules
- `references/app-scoping.md`: app-specific conditions and bundle identifier guidance
- `references/vim-colemak-patterns.md`: Vim-aware and Colemak-oriented patterns
- `references/safety-and-rollback.md`: validation and rollback concepts
