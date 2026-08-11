;;; init.el -*- lexical-binding: t -*-

;; Configurazione principale, caricata dopo early-init.el.
;; Questo file non contiene impostazioni: fa da indice ai moduli.

;;; --- Dove vive questa configurazione (promemoria) ---

;; Seguiamo la convenzione XDG: la cartella di configurazione è ~/.config/emacs/ (valore di user-emacs-directory) e NON ~/.emacs.d/.
;; Percorsi principali:
;; - questo file:              ~/.config/emacs/init.el
;; - early-init.el:            ~/.config/emacs/early-init.el
;; - moduli:                   ~/.config/emacs/lisp/
;; - temi personali:           ~/.config/emacs/themes/
;; - pacchetti installati:     ~/.config/emacs/elpa/
;; - indici degli archivi:     ~/.config/emacs/elpa/archives/  (gnu, nongnu, melpa)
;; - custom.el, backups/, auto-saves/: sempre qui dentro (via locate-user-emacs-file)
;; Ogni comando da Terminale (backup, ls, cp...) va quindi indirizzato a ~/.config/emacs/
;; Verifica rapida in Emacs:  M-:  (list user-emacs-directory package-user-dir)

;;; --- File delle personalizzazioni ---

;; Le personalizzazioni fatte da menu/interfaccia finiscono nel file separato (custom.el) invece di sporcare questo init.el.
;; Nota: il file viene caricato in fondo a questo init.el, così le sue impostazioni non entrano in conflitto con quanto configurato dai moduli.

(setq custom-file (locate-user-emacs-file "custom.el"))

;;; --- Percorso dei moduli ---

;; La configurazione è divisa in moduli, raccolti in ~/.config/emacs/lisp/.
;; Questa riga aggiunge quella cartella a load-path, l'elenco delle cartelle
;; in cui Emacs cerca le librerie: è ciò che permette a `require' (più sotto)
;; di trovare i moduli per nome invece che per percorso.

(add-to-list 'load-path (locate-user-emacs-file "lisp"))

;;; --- Moduli ---

;; L'ordine conta solo per my-packages, che deve venire per primo: definisce
;; use-package, usato da quasi tutti gli altri moduli.
;; Il resto dell'ordine qui sotto è tematico, non tecnico: i moduli non
;; dipendono l'uno dall'altro.
;; Per aprire un modulo senza cercarlo a mano: M-x find-library RET my-core RET

(require 'my-packages)     ; archivi dei pacchetti e use-package
(require 'my-core)         ; comportamenti di base
(require 'my-persistence)  ; memoria tra le sessioni
(require 'my-macos)        ; integrazione con macOS
(require 'my-appearance)   ; temi, caratteri, spaziatura
(require 'my-minibuffer)   ; vertico, consult, embark e famiglia
(require 'my-completion)   ; completamento dentro il buffer
(require 'my-dired)        ; gestione dei file
(require 'my-tools)        ; utilità
(require 'my-git)          ; magit e diff-hl
(require 'my-prog)         ; tree-sitter ed eglot
(require 'my-meow)         ; editing modale

;;; --- Caricamento di custom.el (per ultimo) ---

;; Caricato in fondo, così le personalizzazioni salvate da M-x customize non vengono sovrascritte dai moduli.

(when (file-exists-p custom-file)
  (load custom-file))
