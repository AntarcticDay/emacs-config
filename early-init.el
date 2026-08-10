;;; early-init.el -*- lexical-binding: t -*-

;; Caricato PRIMA dell'interfaccia grafica.

;; Qui solo ciò che riguarda l'aspetto iniziale della finestra.

;; Nasconde la barra degli strumenti (icone grandi) e la barra di scorrimento laterale.
;; (push '(tool-bar-lines . 0) default-frame-alist)
;; (push '(vertical-scroll-bars . nil) default-frame-alist)
;; Per il momento, preferisco mentenerle.

;; Look minimale: rimuove dalla barra del titolo, l'icona-documento ("proxy icon") e il testo del titolo.
;; (setq ns-use-proxy-icon nil)
;; (setq frame-title-format "")
;; Per il momento, preferisco mentenerle.

;; Rende la barra del titolo trasparente, integrandola col tema della finestra (stile app macOS).
(add-to-list 'default-frame-alist '(ns-transparent-titlebar . t))

;; Margine interno (12 pixel) tra il bordo della finestra e il contenuto, su tutti e quattro i lati (stile app macOS).
;; Il valore DEVE restare allineato a :internal-border-width in init.el: questo file dipinge il primo frame, spacious-padding lo ridefinisce subito dopo. Se i due numeri divergono, all'avvio si vede il margine cambiare di scatto.
(push '(internal-border-width . 12) default-frame-alist)

;; Dimensioni della finestra all'apertura: 100 colonne x 45 righe.
(add-to-list 'default-frame-alist '(width  . 100))
(add-to-list 'default-frame-alist '(height . 45))
