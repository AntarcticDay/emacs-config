
# emacs-config

Personal configuration for GNU Emacs.

XDG convention: lives in `~/.config/emacs/`, not in `~/.emacs.d/`.

## Contents

- `early-init.el`: initial frame appearance (transparent title bar, inner margin, window size).
- `init.el`: main configuration, extensively commented
  - core behaviours: backups and auto-saves gathered into dedicated directories, auto-revert, save-place, winner-mode, repeat-mode, and more;
  - minibuffer and navigation: vertico, orderless, marginalia, consult, embark;
  - git: magit and diff-hl;
  - programming: tree-sitter (via treesit-auto) and eglot;
  - modal editing: meow (standard QWERTY layout).

## Installation

```sh
git clone https://codeberg.org/Antarctic_Day/emacs-config.git ~/.config/emacs
```

On first launch, Emacs downloads and installs the packages into `elpa/` by itself.

External dependencies (via Homebrew): `ripgrep` for `consult-ripgrep`; the language servers for eglot (e.g. `pyright`, `gopls`, `rust-analyzer`) must be installed separately.

## Notes

- The `.gitignore` works as a *whitelist*: everything is ignored except the files listed explicitly. Generated content (`elpa/`, `backups/`,
  `auto-saves/`, `custom.el`, ...) is not tracked.
- `custom.el` stays local to the machine.
