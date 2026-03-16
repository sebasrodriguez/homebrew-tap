# Homebrew Tap

Homebrew formulae for [Claudometer](https://github.com/sebasrodriguez/claudometer) and other tools.

## Install

```bash
brew tap sebasrodriguez/tap
brew install claudometer
```

Then launch:

```bash
open $(brew --prefix)/opt/claudometer/Claudometer.app
```

Or link to Applications:

```bash
ln -sf $(brew --prefix)/opt/claudometer/Claudometer.app /Applications/Claudometer.app
```

## Available Formulae

| Formula | Description |
|---------|-------------|
| `claudometer` | macOS menu bar app that monitors Claude Pro/Max session and weekly usage |
