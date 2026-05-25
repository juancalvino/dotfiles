## Kanata Patterns

Use this file when the question is about choosing a configuration shape rather than a single primitive.

## Pattern Selection

### Simple Remap

Definition:
- One or a few key substitutions with no separate mode boundary.

Default choice:
- `deflayermap`

Why:
- Sparse edits stay short.
- It matches the user's request for a minimal snippet.

### Sparse Layer

Definition:
- A logical layer exists, but only a handful of positions differ.

Default choice:
- `deflayermap`

Why:
- Full `deflayer` matrices add noise if most positions are unchanged.

### Whole Layer

Definition:
- Many positions matter, or the user needs a visual matrix to reason about the layer.

Default choice:
- `deflayer`

Why:
- Visual readability outweighs verbosity.

Use `_` for transparent positions and explain why that is clearer than forcing full repetition.

### Momentary Layer

Definition:
- A layer should exist only while the trigger is held.

Default choice:
- `layer-while-held`

Why:
- The release boundary matches the transient intent.

Common examples:
- Navigation
- Symbols
- Window movement

### Persistent Mode Toggle

Definition:
- A mode must stay active until explicitly changed.

Default choice:
- `layer-toggle`, often behind `defvirtualkeys` and `toggle-vkey`

Why:
- Explicit persistent state is easier to reason about than hold timing.

### Tap-Hold Key

Definition:
- A single key should do one thing on tap and another on hold.

Default choice:
- `tap-hold`

Why:
- The design centers on dual-role behavior, not on a separate mode trigger.

Validation note:
- Timing should be treated as a parameter to tune, not a fixed constant.

### Vim Profile

Definition:
- Keyboard behavior is being adapted around Vim motions, modes, or layout-aware navigation.

Default choice:
- Combine a minimal remap or layer strategy with an explicit explanation of motion semantics.

Why:
- Vim requests are rarely only about key positions; they are about preserving editing intent.

## Decision Heuristics

Ask yourself:
- Is this sparse or dense?
- Is the mode transient or persistent?
- Is the behavior positional, semantic, or both?
- Does the user need readability or the shortest valid snippet?

Then explain the tradeoff directly.

## Example Decisions

### `deflayermap` vs `deflayer`

Prefer `deflayermap` when:
- The snippet changes only a few keys.
- The user wants the shortest correct answer.

Prefer `deflayer` when:
- The user is designing an entire layer.
- The layer matrix itself is the explanation.

### `layer-while-held` vs `layer-toggle`

Prefer `layer-while-held` when:
- The user says "while I hold".
- The target task is brief and bursty.

Prefer `layer-toggle` when:
- The user says "mode", "stay on", or "toggle".
- The mode spans many keypresses.

### `_` vs `use-defsrc`

Prefer `_` when:
- You are already in a `deflayer` and want transparent fallthrough.

Prefer `use-defsrc` when:
- You want to state that the source layout is the explicit fallback reference.

## Output Reminder

Default output should be:
- Short diagnosis
- Design decision with primitive rationale
- Minimal `.kbd` snippet
- Short explanation
- Validation checklist
- Rollback note
