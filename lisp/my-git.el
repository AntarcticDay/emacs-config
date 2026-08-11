;;; my-git.el --- Git: magit e diff-hl -*- lexical-binding: t -*-

;;; Commentary:

;; Interfaccia a git e indicatori di modifica a margine.

;;; Code:
;; Magit: interfaccia completa per git.
;; C-x g mostra lo stato del repository; da lì ogni tasto apre menu guidati (? per l'elenco).

(use-package magit
  :bind ("C-x g" . magit-status))

;;; ---

;; diff-hl: indicatori a margine delle righe aggiunte/modificate/eliminate rispetto a git. Il complemento PASSIVO di magit: pura informazione visiva, nessun tasto nuovo.
;; Su GNU ELPA (release stabili, il canale a priorità massima di questa configurazione: nessuna dipendenza da MELPA).
;; Note:
;; - la chiamata in :init carica il pacchetto all'avvio (come vertico e marginalia): scelta deliberata, i soli :hook lo caricherebbero pigramente;
;; - in modalità grafica gli indicatori vivono nella fringe (la strisciolina laterale integrata): non toccano il testo né l'internal-border-width di early-init.el;
;; - mostra le differenze tra l'ultimo SALVATAGGIO su disco e git: le modifiche non ancora salvate non appaiono (per quello esiste diff-hl-flydiff-mode, rimandato);
;; - i due hook sincronizzano gli indicatori con le operazioni di magit (commit, stage...): direzione = hook di magit -> funzione di diff-hl.

(use-package diff-hl
  :init (global-diff-hl-mode 1)
  :hook ((magit-pre-refresh . diff-hl-magit-pre-refresh)
         (magit-post-refresh . diff-hl-magit-post-refresh)))


(provide 'my-git)
;;; my-git.el ends here
