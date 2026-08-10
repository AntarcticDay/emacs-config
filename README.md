# emacs-config

Personal GNU Emacs configuration.

Follows the XDG convention: it lives in `~/.config/emacs/`, not in
`~/.emacs.d/`.

## Requirements

- GNU Emacs 30 or later.
- On macOS, [Emacs Plus](https://github.com/d12frosted/homebrew-emacs-plus).
  Automatic light/dark theme switching relies on the
  `ns-system-appearance-change-functions` hook, which only Emacs Plus
  provides; on any other build the configuration falls back to a fixed
  light theme.
- Optional external tools:
  - `ripgrep`, required by `consult-ripgrep`;
  - the JetBrains Mono font, with Menlo as a fallback;
  - one language server per language (`pyright`, `gopls`,
    `rust-analyzer`, ...), required by Eglot.

## Contents

- `early-init.el` — initial frame appearance: transparent title bar,
  inner border, window size.
- `init.el` — the main configuration, extensively commented:
  - core behaviour: backups and auto-saves collected into dedicated
    directories, auto-revert, save-place, winner-mode, repeat-mode,
    recentf, savehist, so-long;
  - macOS integration: pixel-precision scrolling, context menu,
    `exec-path-from-shell`, deletion to the system Trash;
  - appearance: Modus themes following the system light/dark
    appearance, font and line spacing;
  - minibuffer and navigation: vertico, orderless, marginalia, consult,
    embark, which-key;
  - in-buffer completion: corfu;
  - git: magit and diff-hl;
  - programming: tree-sitter (via treesit-auto) and eglot;
  - modal editing: meow, standard QWERTY layout;
  - utilities: helpful, casual, vundo.

## Installation

    git clone <URL-CODEBERG> ~/.config/emacs

On first launch Emacs downloads and installs the packages into `elpa/`
by itself.

## Repository

- Primary: Codeberg — <URL-CODEBERG>
- Mirror: GitHub — https://github.com/AntarcticDay/emacs-config
  (mirror only; all work is pushed to Codeberg)

## Notes

- `.gitignore` is a *whitelist*: everything is ignored except the files
  listed explicitly. A new file must be whitelisted there first, or
  `git add` will refuse it.
- Generated and machine-local content (`elpa/`, `backups/`,
  `auto-saves/`, `custom.el`) is not tracked.
  