# pi-live-theme

A pi extension that adds a `/theme` slash command with **live theme preview**. Scroll through available themes and see them applied in real time as your cursor moves over each one.

## Features

- 🎨 **Live preview** — themes are applied as you scroll, no need to commit first
- ⏱️ **Debounced loading** — rapid arrow-key navigation won't thrash; only the final selection loads
- ◌ **Loading indicator** — a spinner shows which theme is being loaded
- ↩️ **Safe cancel** — Escape reverts to your original theme
- 🏷️ **Current theme indicator** — the active theme is marked `(current)` and pre-selected

## Install

```bash
pi install npm:pi-live-theme
```

Or from git:

```bash
pi install git:github.com/viraniaman94/pi-live-theme
```

## Demo

![walkthrough](walkthrough.gif)

## Usage

Type `/theme` in pi to open the theme selector:

- **↑↓** — navigate themes (live preview on cursor move)
- **Enter** — commit the highlighted theme
- **Escape** — cancel and revert to the previous theme

## Requirements

- pi (any recent version)
- TUI mode (`/theme` requires interactive terminal)

## License

MIT
