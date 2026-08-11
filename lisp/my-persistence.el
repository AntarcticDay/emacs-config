;;; my-persistence.el --- Memoria tra le sessioni -*- lexical-binding: t -*-

;;; Commentary:

;; Cio' che Emacs ricorda da una sessione all'altra: posizione nei file,
;; file recenti, cronologia del minibuffer, segnalibri.
;; Tutto integrato: nessun pacchetto esterno.

;;; Code:
;; Riapre ogni file esattamente nel punto in cui l'avevamo lasciato.

(save-place-mode 1)

;;; ---

;; Alza il limite dei file ricordati (il default è 20).

;; (setq recentf-max-saved-items 100)

;; Per il momento, mantengo l'impostazione di default.

;;; ---

;; Ricorda i file aperti di recente.
;; Di default C-x C-r è find-file-read-only, quindi lo riassegno all'elenco dei file recenti.

(recentf-mode 1)
(keymap-global-set "C-x C-r" #'recentf-open)

;;; ---

;; Ricorda la cronologia del minibuffer (comandi M-x, ricerche...) tra un riavvio e l'altro.

(savehist-mode 1)

;;; ---

;; I segnalibri (C-x r m per crearne uno, C-x r b per saltarci, C-x r l per elencarli) vengono salvati su disco a ogni modifica, invece che solo alla chiusura di Emacs.
;; Rete di sicurezza contro i crash: rende i bookmark affidabili tra sessioni.

(setq bookmark-save-flag 1)


(provide 'my-persistence)
;;; my-persistence.el ends here
