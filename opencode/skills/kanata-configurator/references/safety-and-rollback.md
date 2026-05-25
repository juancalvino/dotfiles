## Safety And Rollback

Use this file whenever you present a Kanata snippet.

## Validation Mindset

The skill should always frame configuration changes as reversible experiments.

Always mention:
- Validate syntax before relying on the change.
- Test one behavior at a time.
- Keep a known-good config available.
- Prefer a rollback path that does not depend on remembering the broken mapping.

## Validation Checklist

Good checklist items:
- Run `kanata --check` against the edited config.
- If device scoping matters, inspect names with `kanata --list`.
- If using live iteration, reload deliberately with `lrld` only after syntax looks correct.
- Confirm the trigger, exit path, and unaffected keys still behave as expected.

## Rollback Note

The rollback note in the main answer should stay conceptual and short.

Good examples:
- "Keep the previous working mapping nearby so you can revert this snippet quickly if the mode boundary feels wrong."
- "Apply this as a small isolated edit so rollback is just removing the new mapping."

Avoid:
- Long operational recovery procedures
- Setup instructions unrelated to the snippet

## Why This Matters

Keyboard configs can fail in ways that block input confidence.
That is why the skill should always connect the design choice to a validation step and a rollback idea.
