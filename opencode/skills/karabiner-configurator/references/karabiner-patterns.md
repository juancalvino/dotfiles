# Common Karabiner patterns

Use this file when the user describes a mode, app-specific rule, or modal editor flow.

## Pattern: simple remap

Use one `basic` manipulator.

Good for:
- `caps_lock -> escape`
- `right_option -> right_command`

## Pattern: app-scoped remap

Use one `basic` manipulator plus `frontmost_application_if`.

Good for:
- rule only in Ghostty
- rule only in Finder

## Pattern: persistent mode

Use a toggle manipulator that flips a variable and separate variable-gated manipulators for the actual remaps.

Why this works:
- the trigger key does not need to duplicate every target remap
- the remaps stay readable
- app scope can be added later without redesigning the mode

## Pattern: app-scoped persistent mode

Use:
- one variable toggle manipulator
- multiple remap manipulators gated by both `variable_if` and `frontmost_application_if`

This is the standard answer for “I want a Vim mode only in Ghostty.”

## Pattern: tap-hold helper key

Use `to_if_alone` and `to_if_held_down` when the same key should still have a normal tap meaning.

Good for:
- `caps_lock` tap = `escape`, hold = `left_control`
- a helper key that types itself when tapped but enables a command chord when held

## Pattern: physical vs logical layout adaptation

When the user says things like:
- “my Colemak `n` should behave like `h`”

translate the request into the physical key code that generates the logical letter under the current macOS layout.

Do not assume Karabiner remaps logical glyphs. It remaps physical key events.
