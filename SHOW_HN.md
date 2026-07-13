**Show HN: pi-live-theme — live theme preview for pi coding agent**

Built a `/theme` slash command for [pi](https://pi.dev) that previews themes as you scroll. Move the cursor over a theme in the list and the entire TUI re-renders instantly — no commit-then-check loop. 50ms debounce keeps rapid arrow-key nav from thrashing, and Escape reverts back to whatever you had before.

Install:
```
pi install npm:pi-live-theme
```

Source: https://github.com/viraniaman94/pi-live-theme

Took about an afternoon. The pi extension API makes this surprisingly clean — `ctx.ui.getAllThemes()` for discovery, `ctx.ui.setTheme(name)` for application, and `SelectList.onSelectionChange` for the live preview hook. Happy to answer questions.
