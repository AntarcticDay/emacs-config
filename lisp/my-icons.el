;;; my-icons.el --- Icone: nerd-icons e i suoi ponti -*- lexical-binding: t -*-

;;; Commentary:

;; Purely decorative layer: icons in the minibuffer, in the corfu popup,
;; in dired and in ibuffer.  No command, no key binding, no behaviour is
;; changed anywhere -- removing the `require' of this module from init.el
;; restores the previous appearance and nothing else.
;;
;; The module cuts across several others (my-minibuffer.el, my-completion.el,
;; my-dired.el, my-core.el) which is exactly why the icons live here instead of
;; being scattered among them: one place to read, tune or drop the whole thing.
;;
;; External dependency: a Nerd Font must be installed on the system.  Here it
;; comes from Homebrew; `M-x nerd-icons-install-fonts' is the alternative for
;; machines without it -- note that it asks for a full "yes", not just "y".
;; The font family looked up in GUI frames is `nerd-icons-font-family',
;; "Symbols Nerd Font Mono" by default.  Quick check: M-x nerd-icons-insert
;;
;; Every package here comes from MELPA only, so none of them benefits from the
;; GNU/NonGNU ELPA priority set in my-packages.el.  They are all actively
;; maintained and licensed under the GPL.

;;; Code:
;; nerd-icons is the library the four bridges below build on: it maps file
;; types, modes and completion categories to glyphs.  Nothing else here calls
;; it directly, so `:defer t' keeps it out of the startup path -- the first
;; bridge that needs it pulls it in.  Declaring it anyway is what makes the
;; setup reproducible: on a fresh machine the package gets installed from this
;; file, instead of relying on a manual M-x package-install.

(use-package nerd-icons
  :defer t)

;;; ---

;; Icons next to minibuffer completion candidates, by category: a command, a
;; file, a buffer, a face all get their own glyph.  Works through an advice on
;; `completion-metadata-get', the same mechanism marginalia uses, so the two
;; have to be layered in the right order -- hence `:after marginalia'.
;;
;; Pulls in `compat' (GNU ELPA) as a dependency: a compatibility library, new
;; to this configuration but a dependency of many packages anyway.
;;
;; The two lines in :config do different jobs, and both are needed:
;; - the explicit call enables the mode here and now.  Necessary because
;;   marginalia-mode is switched on at startup in my-minibuffer.el: relying on
;;   the hook alone would mean waiting for an event that has already happened;
;; - the hook keeps the two modes in sync afterwards, so that turning
;;   marginalia off also turns the icons off.
;; Enabling the mode twice is harmless: it installs an advice, and adding the
;; same advice twice is a no-op.

(use-package nerd-icons-completion
  :after marginalia
  :config
  (nerd-icons-completion-mode 1)
  (add-hook 'marginalia-mode-hook #'nerd-icons-completion-marginalia-setup))

;;; ---

;; Icons in the corfu popup, by kind of candidate: function, variable, snippet,
;; keyword.  The package provides a "margin formatter", i.e. a function corfu
;; calls to fill the strip to the left of the candidates, so it is added to the
;; list corfu already consults rather than replacing anything.
;; `:after corfu' is what guarantees `corfu-margin-formatters' exists by then.

(use-package nerd-icons-corfu
  :after corfu
  :config
  (add-to-list 'corfu-margin-formatters #'nerd-icons-corfu-formatter))

;;; ---

;; Icons for each entry in a dired listing, by file type.
;; Drawn as overlays on top of the listing: the buffer text is untouched, so
;; every dired command keeps operating on the real file names.
;; Note: the mode sets `tab-width' to 1 in dired buffers, because a tab is what
;; separates the icon from the file name.

(use-package nerd-icons-dired
  :hook (dired-mode . nerd-icons-dired-mode))

;;; ---

;; Icons in the ibuffer listing (C-x C-b, see my-core.el), by major mode.

(use-package nerd-icons-ibuffer
  :hook (ibuffer-mode . nerd-icons-ibuffer-mode))


(provide 'my-icons)
;;; my-icons.el ends here
