;;; my-prog.el --- Programmazione: tree-sitter ed eglot -*- lexical-binding: t -*-

;;; Commentary:

;; Evidenziazione della sintassi via tree-sitter e client LSP integrato.

;;; Code:
;; Tree-sitter: Emacs 30 include il supporto ai modi *-ts-mode (es. python-ts-mode), con evidenziazione della sintassi molto più precisa di quella classica.
;; treesit-auto: quando si apre un file, propone di installare la grammatica mancante e attiva automaticamente il modo tree-sitter corrispondente.

(use-package treesit-auto
  :custom
  (treesit-auto-install 'prompt)   ; chiede conferma prima di scaricare una grammatica
  :config
  (treesit-auto-add-to-auto-mode-alist 'all)
  (global-treesit-auto-mode 1))

;;; ---

;; Eglot: client LSP INTEGRATO in Emacs (diagnostica, documentazione, rinomina, vai-a-definizione...).
;; Non si avvia da solo: in un buffer di codice, eseguire M-x eglot.
;; Richiede il language server del linguaggio, installato a parte (es. via Homebrew: pyright per Python, gopls per Go, rust-analyzer per Rust...).
;; Grazie a exec-path-from-shell, i server installati via Homebrew vengono trovati.

(use-package eglot
  :ensure nil)                ; integrato

;; Avvio automatico di eglot per linguaggio: decommentare la riga corrispondente
;; DOPO aver installato il language server (es. via Homebrew).
;; Nota: con treesit-auto i modi attivi sono quelli *-ts-mode.
;; (add-hook 'python-ts-mode-hook #'eglot-ensure)   ; richiede pyright
;; (add-hook 'go-ts-mode-hook     #'eglot-ensure)   ; richiede gopls
;; (add-hook 'rust-ts-mode-hook   #'eglot-ensure)   ; richiede rust-analyzer


(provide 'my-prog)
;;; my-prog.el ends here
