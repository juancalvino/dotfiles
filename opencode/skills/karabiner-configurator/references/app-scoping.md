# App scoping in Karabiner

Use this file when the user mentions Ghostty or any app-specific behavior.

## Core rule

Use `frontmost_application_if` for app-specific rules.

Example shape:

```json
{
  "conditions": [
    {
      "type": "frontmost_application_if",
      "bundle_identifiers": ["^com\\.mitchellh\\.ghostty$"]
    }
  ]
}
```

## Why app scoping belongs in conditions

Do not mix app awareness into the variable name or description alone.

Keep concerns separate:
- variable = mode state
- app condition = where the rule applies

## How to get the correct bundle identifier

Use Karabiner-EventViewer and inspect the frontmost application tab.

Do not guess if the user needs production-ready JSON.

## Multiple apps

The array is joined as logical OR.

Example:

```json
"bundle_identifiers": [
  "^com\\.mitchellh\\.ghostty$",
  "^com\\.googlecode\\.iterm2$"
]
```

## Good design advice

If the user wants a mode only in Ghostty:
- keep the toggle variable generic, e.g. `vim_mode`
- scope the actual remaps to Ghostty

That makes it easy to reuse the mode in another terminal later.
