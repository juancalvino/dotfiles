## Vim And Colemak Patterns

Use this file when the request mentions Vim, modal editing, Colemak, or layout-aware navigation.

## Core Principle

Vim-aware keyboard configuration is about preserving motion intent, not blindly mirroring letter positions.

That means the skill should ask:
- Is the user preserving classic Vim letters?
- Is the user preserving physical movement?
- Is the user mixing the two only for high-frequency motions?

## Minimal Vim Profile

Default to the smallest change that preserves the user's main editing flow.

Good default:
- Remap only the highest-frequency navigation keys first.
- Avoid inventing a full modal ecosystem unless requested.

Why:
- Minimal remaps are easier to validate.
- Large Vim remap sets can create cognitive conflict across tools.

## Colemak Classic On macOS With Minimal Vim Remaps

A small pattern for users who want classic navigation intent without rewriting everything:

```kbd
(defcfg
  process-unmapped-keys yes
)

(deflayermap base
  n j
  e k
  i l
)
```

Why this pattern works:
- It preserves a small set of high-value motions.
- It avoids turning every editor command into a layout project.
- `deflayermap` is better than `deflayer` because the change set is sparse.

## Momentary Vim Navigation Layer

If the user wants Vim-like motions only while holding a trigger, prefer a momentary layer.

```kbd
(deflayermap base
  <your-trigger-key> (layer-while-held vim-nav)
)

(deflayer vim-nav
  _ _ _ _ _
  _ h j k l
  _ _ _ _ _
)
```

Why this is useful:
- It creates a clear modal boundary without persistent state.
- It is often easier to learn than a full toggle mode.

## Persistent Vim Mode

If the user explicitly wants a real mode that stays active, use a persistent toggle.

```kbd
(defvirtualkeys
  vim_mode (layer-toggle vim)
)

(deflayermap base
  <your-trigger-key> (toggle-vkey vim_mode)
)
```

Why prefer this over direct physical toggling:
- The virtual key names the concept.
- The trigger remains replaceable.

## Decision Hints

Choose minimal Vim remaps when:
- The user mostly wants navigation fixed.
- They already have strong editor habits.

Choose a momentary layer when:
- They want modal access without sticky state.

Choose a persistent mode when:
- They explicitly think in terms of "enter mode" and "leave mode".

## Common Mistake To Avoid

Do not assume one canonical trigger key for Vim behavior.
Always treat the trigger as user-chosen.
