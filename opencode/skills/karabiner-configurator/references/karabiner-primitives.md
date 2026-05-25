# Karabiner primitives

Use this file when deciding which Karabiner primitive best matches a request.

## `basic` manipulator

Use this for direct remaps and most complex modifications.

Best when:
- one key changes to another
- a key sets a variable
- a key triggers tap/hold behavior

Avoid reaching for variables when a single direct remap is enough.

## `set_variable`

Use this when the user wants durable mode state.

Best when:
- a key should toggle a mode on and off
- several other manipulators should become active only while a mode is enabled
- the rule needs a clean separation between trigger and gated behavior

Prefer expressions like `my_mode != 0 ? 0 : 1` for true toggles.

## `variable_if` and `variable_unless`

Use these to gate remaps by mode state.

Best when:
- the user describes a “layer” or “mode” in Karabiner
- several keys should change only while a variable is active

Karabiner does not have firmware-like layers. Variables are the right abstraction.

## `frontmost_application_if`

Use this whenever the user wants rules restricted to one app or a small set of apps.

Best when:
- the request says “only in Ghostty”
- the request should work in one editor but not globally

Bundle identifiers usually come from Karabiner-EventViewer.

## `device_if`

Use this when rules should apply only on one keyboard or one keyboard class.

Best when:
- the built-in keyboard should behave differently from an external one
- one specific external keyboard needs a custom layout

Do not use this when the real requirement is app scoping.

## `to_if_alone` and `to_if_held_down`

Use these when one physical key needs different tap and hold behavior.

Best when:
- the user wants `caps_lock` to be `escape` when tapped and `control` when held
- a trigger key should type normally on tap but act as a mode helper on hold

## `vk_none`

Use this when the user wants a key to toggle or change state without typing a character.

Best when:
- the trigger key should not leak output
- a mode key should only flip a variable

## Conditions composition

It is normal to combine:
- `variable_if`
- `frontmost_application_if`
- `device_if`

That lets a rule answer three different questions cleanly:
- Is the mode active?
- Is the correct app focused?
- Is the correct keyboard producing the event?
