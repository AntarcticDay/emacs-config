;;; my-minibuffer.el --- Minibuffer, completamento e navigazione -*- lexical-binding: t -*-

;;; Commentary:

;; La famiglia vertico/orderless/marginalia/consult/embark, piu' le
;; impostazioni integrate del minibuffer e which-key.

;;; Code:
;; Permette di usare comandi del minibuffer mentre un minibuffer è già attivo.

(setq enable-recursive-minibuffers t)

;; ...mostrando un contatore [2] nel prompt quando si è "annidati", per non perdersi.

(minibuffer-depth-indicate-mode 1)

;;; ---

;; M-x nasconde i comandi non pertinenti al buffer corrente (es. comandi specifici di un modo non attivo). Restano richiamabili per nome completo.

(setq read-extended-command-predicate
      #'command-completion-default-include-p)

;;; ---

;; Vertico: mostra i candidati del minibuffer in una lista verticale navigabile con le frecce.
;; Trasforma M-x e C-x C-f da "campo cieco" a menu esplorabile.

(use-package vertico
  :init (vertico-mode 1))

;;; ---

;; vertico-directory (estensione INCLUSA in vertico):
;; in C-x C-f, Backspace cancella un'intera directory invece di un carattere, e M-Backspace una parola. RET entra nella directory selezionata.

;; (use-package vertico-directory
;;   :ensure nil
;;   :after vertico
;;   :bind (:map vertico-map
;;               ("RET" . vertico-directory-enter)
;;               ("DEL" . vertico-directory-delete-char)
;;               ("M-DEL" . vertico-directory-delete-word))
;;   ;; Ripulisce il percorso quando si digita ~/ o / per ripartire da capo.
;;   :hook (rfn-eshadow-update-overlay . vertico-directory-tidy))

;; Per il momento, mantengo il comportamento di default.

;; Promemoria: due comportamenti INTEGRATI coprono già in parte lo stesso bisogno:
;; - in un prompt di file, M-DEL cancella all'indietro una componente di percorso per volta;
;; - digitando ~/ o // in mezzo a un percorso, Emacs riparte dalla home o dalla radice
;;   (il vecchio percorso resta visibile "in ombra" ma viene ignorato).

;;; ---

;; Orderless: completamento "per parole in qualsiasi ordine".

(use-package orderless
  :custom
  (completion-styles '(orderless basic))
  (completion-category-overrides '((file (styles basic partial-completion)))))

;;; ---

;; Completamento senza distinzione maiuscole/minuscole: chiusura dei casi residui.
;; Il grosso è già coperto altrove:
;; - per ciò che passa da orderless decide la sua opzione orderless-smart-case (default t): input tutto minuscolo = confronto insensibile; una maiuscola nell'input = confronto sensibile;
;; - per i NOMI DI FILE decide read-file-name-completion-ignore-case, GIÀ t di default su macOS (come su ogni sistema il cui filesystem è tipicamente case-insensitive): digitare "doc" trova già "Documents".
;; Le due variabili qui sotto estendono lo stesso comportamento a ciò che resta: i nomi di buffer e ogni altro completamento servito dallo stile di ripiego basic (che, da solo, distingue le maiuscole).

(setq read-buffer-completion-ignore-case t
      completion-ignore-case t)

;; Ribadire il default macOS dei nomi di file sarebbe superfluo:
;; (setq read-file-name-completion-ignore-case t)

;;; ---

;; Marginalia: annotazioni accanto ai candidati (descrizione dei comandi, dimensioni dei file...).

(use-package marginalia
  :init (marginalia-mode 1))

;;; ---

;; Which-key: attivato un prefisso (es. C-x), compare il pannello con le continuazioni possibili.

(use-package which-key
  :ensure nil                 ; integrato
  :init (which-key-mode 1))

;;; ---

;; Consult: versioni "vive" dei comandi di ricerca e navigazione.
;; Stessa famiglia di vertico/orderless/marginalia.
;; - M-s l cerca nel file mostrando i risultati mentre digiti
;;   (C-s resta l'isearch classico, quello descritto dal tutorial C-h t);
;; - C-x b unifica buffer aperti e file recenti in un'unica lista;
;; - M-s r cerca in un'intera cartella (usa ripgrep, già installato via Homebrew e trovato grazie a exec-path-from-shell);
;; - M-y: la versione standard funziona solo subito dopo C-y; questa apre in QUALSIASI momento l'intera cronologia dei tagli/copie come lista navigabile con anteprima;
;; - M-g g / M-g M-g: vai alla riga, con anteprima dal vivo (goto-line di serie vive su ENTRAMBI i tasti: li copriamo entrambi per coerenza);
;; - M-g i salta a funzioni/sezioni/intestazioni del file corrente (imenu).

(use-package consult
  :bind (("M-s l" . consult-line)
         ("C-x b" . consult-buffer)
         ("M-s r" . consult-ripgrep)
         ("M-y" . consult-yank-pop)
         ("M-g g" . consult-goto-line)
         ("M-g M-g" . consult-goto-line)
         ("M-g i" . consult-imenu)))

;;; ---

;; Embark: menu di azioni contestuali sul candidato selezionato nel minibuffer (e sull'oggetto sotto il cursore nei buffer normali).
;; C-. apre il menu delle azioni; C-h B elenca tutte le scorciatoie attive.

(use-package embark
  :bind (("C-." . embark-act)
         ("C-h B" . embark-bindings)))

;;; ---

;; Integrazione tra embark e consult (es. esportare i risultati di una ricerca in un buffer).

(use-package embark-consult
  :hook (embark-collect-mode . consult-preview-at-point-mode))


(provide 'my-minibuffer)
;;; my-minibuffer.el ends here
