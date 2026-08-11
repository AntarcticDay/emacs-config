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
  - the JetBrains Mono and IBM Plex Sans fonts, with Menlo and Helvetica
    Neue as respective fallbacks;
  - a Nerd Font, required to render the icons — `Symbols Nerd Font Mono`
    by default, see `nerd-icons-font-family`. Installed here through
    Homebrew; `M-x nerd-icons-install-fonts` is the alternative;
  - one language server per language (`pyright`, `gopls`,
    `rust-analyzer`, ...), required by Eglot.

## Layout

    early-init.el      frame appearance, before the GUI exists
    init.el            index: loads the modules below, nothing else
    lisp/              one module per topic
    themes/            personal themes, tracked by git

`early-init.el` sets the transparent title bar, the inner border and the
initial window size. The inner border width must be kept in sync with
`spacious-padding-widths` in `lisp/my-appearance.el`, or the margin
visibly jumps at startup.

`init.el` holds no settings of its own: it adds `lisp/` to `load-path`
and `require`s the modules. Only the order of the first one matters —
`my-packages` defines `use-package`, which almost every other module
uses. The rest is thematic, not technical.

Every module is extensively commented, including the options that were
considered and deliberately left at their default: the comments are part
of the point of this repository. To open one without hunting for the
file: `M-x find-library RET my-core RET`.

## Modules

| Module              | Contents                                                                                         |
| ------------------- | ------------------------------------------------------------------------------------------------ |
| `my-packages.el`    | package.el archives, MELPA, archive priorities, `use-package`                                     |
| `my-core.el`        | backups and auto-saves in dedicated directories, auto-revert, winner-mode, repeat-mode, so-long, visual wrapping |
| `my-persistence.el` | save-place, recentf, savehist, bookmarks                                                          |
| `my-macos.el`       | pixel-precision scrolling, context menu, deletion to the system Trash, `exec-path-from-shell`      |
| `my-appearance.el`  | themes following the system light/dark appearance, typography, `spacious-padding`                  |
| `my-minibuffer.el`  | vertico, orderless, marginalia, consult, embark, which-key                                        |
| `my-completion.el`  | corfu and the built-in options governing in-buffer completion                                     |
| `my-dired.el`       | dired                                                                                             |
| `my-tools.el`       | helpful, casual, vundo                                                                            |
| `my-icons.el`       | nerd-icons and its bridges to the minibuffer, corfu, dired and ibuffer                            |
| `my-git.el`         | magit, diff-hl                                                                                    |
| `my-prog.el`        | tree-sitter (via treesit-auto), eglot                                                             |
| `my-meow.el`        | meow modal editing, standard QWERTY layout                                                        |

## Themes

`themes/` holds personal themes derived from the
[Modus themes](https://protesilaos.com/emacs/modus-themes), which the
configuration installs from GNU ELPA on top of the copy bundled with
Emacs: version 5 is what provides the palette machinery the derivative
themes are built on.

`chaun-bay` and `chaun-bay-dark` are selected automatically according to
the macOS system appearance.

## Installation

    git clone https://codeberg.org/AntarcticNight/emacs-config ~/.config/emacs

On first launch Emacs downloads and installs the packages into `elpa/`
by itself.

## Repository

- Primary: Codeberg — https://codeberg.org/AntarcticNight/emacs-config
- Mirror: GitHub — https://github.com/AntarcticDay/emacs-config
  (mirror only; all work is pushed to Codeberg)

## Notes

- `.gitignore` is a *whitelist*: everything is ignored except the files
  listed explicitly. A new file must be whitelisted there first, or
  `git add` will refuse it. This applies to every new module under
  `lisp/` and every new theme under `themes/`.
- Generated and machine-local content (`elpa/`, `backups/`,
  `auto-saves/`, `custom.el`) is not tracked.
