;;; my-tools.el --- Utilita' -*- lexical-binding: t -*-

;;; Commentary:

;; Strumenti trasversali che non appartengono a un dominio preciso:
;; aiuto migliorato, menu di scoperta, cronologia di annullamento.

;;; Code:
;; Helpful: schermate di aiuto molto più leggibili di quelle predefinite, con esempi, codice sorgente e tasti collegati.

;; Sostituisce i comandi standard di C-h.

(use-package helpful
  :bind (("C-h f" . helpful-callable)
         ("C-h v" . helpful-variable)
         ("C-h k" . helpful-key)
         ("C-h x" . helpful-command)))

;;; ---

;; Casual: menu transient di scoperta (stile magit) per le modalità integrate.
;; C-c o apre il pannello con le operazioni disponibili e i loro tasti NATIVI: non ridefinisce nulla, insegna i comandi standard mentre li si usa. Complemento perfetto di which-key.
;; Scelta del tasto: C-c + lettera è lo spazio riservato all'utente per convenzione, quindi nessun comando standard viene toccato.
;; (La documentazione di Casual suggerisce C-o, che però in dired ombreggerebbe dired-display-file.)
;; Un solo gesto mentale, uguale ovunque: "C-c o = mostrami il menu di questo contesto".
;; Nota: richiede un transient recente; viene aggiornato correttamente grazie a package-install-upgrade-built-in e alle priorità degli archivi (GNU ELPA stabile).
;; Nota sulla forma dei due binding:
;; - isearch è PRECARICATO in Emacs, quindi isearch-mode-map esiste già all'avvio: il binding via :bind funziona subito;
;; - dired invece si carica al primo uso: la sua keymap non esiste ancora all'avvio, e un :bind (:map dired-mode-map ...) verrebbe rimandato al caricamento di CASUAL, che però si caricherebbe solo premendo quel binding — circolo vizioso, tasto muto. Il binding va quindi rimandato esplicitamente al caricamento di DIRED (with-eval-after-load in :init, eseguito all'avvio). Il comando è autoload: premerlo carica casual da sé.
;; Estensioni future, stesso schema di dired (le loro keymap non esistono all'avvio): casual-ibuffer-tmenu, casual-info-tmenu, casual-calc-tmenu...

(use-package casual
  :bind (:map isearch-mode-map
              ("C-c o" . casual-isearch-tmenu))
  :init
  (with-eval-after-load 'dired
    (keymap-set dired-mode-map "C-c o" #'casual-dired-tmenu)))

;;; ---

;; Vundo: mostra la cronologia di annullamento come un albero navigabile con le frecce. Invio conferma, q annulla.
;; (C-/ resta l'undo "semplice".)

(use-package vundo
  :bind ("C-x u" . vundo))


(provide 'my-tools)
;;; my-tools.el ends here
