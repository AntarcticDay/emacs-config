;;; my-packages.el --- Archivi dei pacchetti e use-package -*- lexical-binding: t -*-

;;; Commentary:

;; Configurazione di package.el (il gestore pacchetti integrato) e di
;; use-package.  Questo modulo va caricato per primo: quasi tutti gli
;; altri dichiarano i propri pacchetti con use-package.

;;; Code:

;; package.el è il gestore pacchetti integrato.
;; Di default conosce GNU ELPA e NonGNU ELPA; aggiungo MELPA, l'archivio comunitario.

(require 'package)

(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/") t)

;;; ---

;; Quando un pacchetto esiste in più archivi, preferiamo quelli stabili (GNU, poi NonGNU) alle snapshot giornaliere di MELPA.
;; I pacchetti presenti SOLO su MELPA restano comunque installabili.

(setq package-archive-priorities
      '(("gnu" . 3) ("nongnu" . 2) ("melpa" . 1)))

;;; ---

;; Di default package.el rifiuta di aggiornare i pacchetti integrati.
;; Questa impostazione consente l'aggiornamento.
;; È di fatto necessaria per magit: dipende da transient (anch'esso integrato) e spesso ne richiede una versione più recente di quella inclusa in Emacs.
;; Vale lo stesso per casual (vedi my-tools.el), che richiede anch'esso un transient recente.
;; Il rischio è mitigato da package-archive-priorities (sopra): gli integrati vengono aggiornati alle release STABILI di GNU ELPA, non a snapshot di MELPA.
;; Accorgimenti di metodo:
;; - preferire M-x package-upgrade (un pacchetto alla volta, quando serve) a M-x package-upgrade-all, per evitare aggiornamenti di massa a sorpresa;
;; - ogni aggiornamento di un integrato è reversibile: M-x package-delete sulla copia ELPA fa riemergere la versione inclusa in Emacs.

(setq package-install-upgrade-built-in t)

;;; ---

;; Compilazione nativa dei pacchetti AL MOMENTO DELL'INSTALLAZIONE.
;; Default (nil): la compilazione avviene comunque, ma in modo pigro e asincrono al primo caricamento di ogni file (occasionali picchi di CPU e piccoli scatti).
;; Con t: installare è un po' più lento, ma il costo si paga una volta sola.
;; La guardia rende la riga innocua su build prive di native compilation (Emacs Plus la include di default).

(when (native-comp-available-p)
  (setq package-native-compile t))

;;; ---

;; Al primo avvio su una macchina pulita scarica l'indice degli archivi, se assente.
;; Nota: nei riavvii successivi l'indice NON viene più aggiornato automaticamente.
;; Prima di installare un pacchetto, conviene comunque eseguire manualmente: M-x package-refresh-contents

(unless package-archive-contents
  (package-refresh-contents))

;;; ---

;; Se viene richiesto un pacchetto sconosciuto all'indice locale, aggiorna prima l'indice degli archivi.
;; Così use-package (:ensure) e M-x package-install funzionano anche con un indice datato, senza il costo di un refresh a ogni avvio.

(define-advice package-install (:before (pkg &rest _) my/refresh-se-sconosciuto)
  (let ((nome (if (package-desc-p pkg) (package-desc-name pkg) pkg)))
    (unless (assq nome package-archive-contents)
      (package-refresh-contents))))

;;; ---

;; use-package permette di dichiarare ogni pacchetto in un blocco ordinato: installazione + configurazione.
;; Con questa impostazione, ogni pacchetto dichiarato viene installato automaticamente, se assente.

(require 'use-package)
(setq use-package-always-ensure t)

(provide 'my-packages)
;;; my-packages.el ends here
