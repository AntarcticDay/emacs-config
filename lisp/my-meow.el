;;; my-meow.el --- Editing modale con meow -*- lexical-binding: t -*-

;;; Commentary:

;; Layout QWERTY standard, allineato alla versione di meow installata.

;;; Code:
;; Configurazione QWERTY presa dalla documentazione della versione INSTALLATA
;; di meow, la 1.5.0 di NonGNU ELPA (le priorità degli archivi impostate più
;; sopra fanno preferire NonGNU a MELPA: meow arriva sempre da lì).
;; ATTENZIONE: la documentazione di meow che si trova online descrive il ramo
;; di sviluppo, non la 1.5.0. Due differenze già oggi:
;; - lì la funzione usata qui sotto si chiama meow-motion-define-key;
;; - lì le due righe '("j" . "H-j") e '("k" . "H-k") sono state rimosse,
;;   perché il leader raggiunge da solo il comando originale.
;; Con la 1.5.0 servono entrambe le cose come sono scritte qui. Alla prossima
;; release di meow questo blocco andrà riallineato in blocco, non a pezzi.
;; Riferimenti sempre allineati alla versione installata, perché arrivano
;; dentro il pacchetto: M-x meow-tutor e, a meow attivo, SPC ?

(defun my/meow-setup ()
  "Layout QWERTY standard per meow (dalla documentazione ufficiale)."
  (setq meow-cheatsheet-layout meow-cheatsheet-layout-qwerty)
  (meow-motion-overwrite-define-key
   '("j" . meow-next)
   '("k" . meow-prev)
   '("<escape>" . ignore))
  (meow-leader-define-key
   ;; SPC j/k richiamano j/k della modalità motion
   '("j" . "H-j")
   '("k" . "H-k")
   ;; Aiuti per i tasti numerici
   '("1" . meow-digit-argument)
   '("2" . meow-digit-argument)
   '("3" . meow-digit-argument)
   '("4" . meow-digit-argument)
   '("5" . meow-digit-argument)
   '("6" . meow-digit-argument)
   '("7" . meow-digit-argument)
   '("8" . meow-digit-argument)
   '("9" . meow-digit-argument)
   '("0" . meow-digit-argument)
   '("/" . meow-keypad-describe-key)
   '("?" . meow-cheatsheet))
  (meow-normal-define-key
   '("0" . meow-expand-0)
   '("9" . meow-expand-9)
   '("8" . meow-expand-8)
   '("7" . meow-expand-7)
   '("6" . meow-expand-6)
   '("5" . meow-expand-5)
   '("4" . meow-expand-4)
   '("3" . meow-expand-3)
   '("2" . meow-expand-2)
   '("1" . meow-expand-1)
   '("-" . negative-argument)
   '(";" . meow-reverse)
   '("," . meow-inner-of-thing)
   '("." . meow-bounds-of-thing)
   '("[" . meow-beginning-of-thing)
   '("]" . meow-end-of-thing)
   '("a" . meow-append)
   '("A" . meow-open-below)
   '("b" . meow-back-word)
   '("B" . meow-back-symbol)
   '("c" . meow-change)
   '("d" . meow-delete)
   '("D" . meow-backward-delete)
   '("e" . meow-next-word)
   '("E" . meow-next-symbol)
   '("f" . meow-find)
   '("g" . meow-cancel-selection)
   '("G" . meow-grab)
   '("h" . meow-left)
   '("H" . meow-left-expand)
   '("i" . meow-insert)
   '("I" . meow-open-above)
   '("j" . meow-next)
   '("J" . meow-next-expand)
   '("k" . meow-prev)
   '("K" . meow-prev-expand)
   '("l" . meow-right)
   '("L" . meow-right-expand)
   '("m" . meow-join)
   '("n" . meow-search)
   '("o" . meow-block)
   '("O" . meow-to-block)
   '("p" . meow-yank)
   '("q" . meow-quit)
   '("Q" . meow-goto-line)
   '("r" . meow-replace)
   '("R" . meow-swap-grab)
   '("s" . meow-kill)
   '("t" . meow-till)
   '("u" . meow-undo)
   '("U" . meow-undo-in-selection)
   '("v" . meow-visit)
   '("w" . meow-mark-word)
   '("W" . meow-mark-symbol)
   '("x" . meow-line)
   '("X" . meow-goto-line)
   '("y" . meow-save)
   '("z" . meow-pop-selection)
   '("'" . repeat)
   '("<escape>" . ignore)))

(use-package meow
  :config
  (my/meow-setup)
  (meow-global-mode 1))


(provide 'my-meow)
;;; my-meow.el ends here
