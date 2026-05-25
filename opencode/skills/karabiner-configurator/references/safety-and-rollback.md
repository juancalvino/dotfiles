# Safety and rollback

Use this file when explaining how to test Karabiner rules safely.

## Safety principles

- Change one behavior at a time.
- Prefer one toggle variable and a few gated manipulators before expanding into a full mode.
- Keep app-specific conditions narrow when testing.
- Keep the old rule disabled but available for comparison.

## Validation guidance

Recommend these checks conceptually:
- confirm the physical key code in Karabiner-EventViewer
- confirm the frontmost application bundle identifier in EventViewer
- enable one new manipulator or one new rule block at a time
- test the trigger key separately before adding many remaps

## Rollback guidance

- Remove or disable the new rule block if behavior is wrong.
- Prefer isolated rule snippets over rewriting the whole profile.
- Keep toggle rules and remap rules separate so one can be disabled without losing the other.

## Common failure modes

- wrong physical key code due to confusion between layout glyphs and key positions
- wrong bundle identifier for app scoping
- mode toggle works but gated remaps are missing the matching `variable_if`
- app scope works but the toggle itself is global when the user expected both pieces to be app-scoped
