;;; my-dired.el --- Gestione dei file (dired) -*- lexical-binding: t -*-

;;; Commentary:

;; Impostazioni di dired.  Il menu casual-dired-tmenu su C-c o e'
;; dichiarato in my-tools.el, insieme al resto di casual.

;;; Code:
;; In dired, con due finestre dired affiancate, copia (C) e sposta (R) propongono automaticamente l'altra finestra come destinazione.
;; Trasforma dired in un file manager a due pannelli. Nessun tasto cambia: cambia solo il percorso PROPOSTO nel prompt, sempre modificabile.

(setq dired-dwim-target t)

;;; ---

;; In dired, dimensioni dei file leggibili (KB, MB...) invece di byte grezzi.
;; Il default è "-al"; l'opzione -h aggiunta qui è supportata anche dal ls BSD di macOS (il requisito di dired, la presenza di -l, resta rispettato).
;; Nota: --group-directories-first (cartelle in cima) richiederebbe invece il ls GNU (coreutils via Homebrew, poi insert-directory-program): rimandato.

(setq dired-listing-switches "-alh")


(provide 'my-dired)
;;; my-dired.el ends here
