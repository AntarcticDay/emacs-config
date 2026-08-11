;;; my-completion.el --- Completamento dentro il buffer -*- lexical-binding: t -*-

;;; Commentary:

;; Corfu e le impostazioni integrate che ne governano il comportamento.
;; Il completamento nel MINIBUFFER sta invece in my-minibuffer.el.

;;; Code:
;; TAB "intelligente" (impostazione integrata di Emacs): prima indenta la riga; se è già indentata, apre il completamento.

(setq tab-always-indent 'complete)

;;; ---
;; Emacs 30 fa aggiungere a text-mode un completamento basato sull'elenco di
;; parole di sistema (ispell). Con corfu-auto attivo, il popup si apre da solo
;; mentre si scrive prosa e propone parole INGLESI: rumore in un testo
;; italiano, più un accesso a un file esterno a ogni pausa di digitazione.
;; Con nil, text-mode non installa più quella funzione di completamento.
;; Note:
;; - riguarda tutti i modi derivati da text-mode: outline, Org, markdown, mail;
;; - va impostata con setopt e non con setq: è un'opzione utente con una
;;   funzione di aggiornamento propria (:set), che solo setopt esegue;
;; - scartata l'alternativa (valore t = comportamento pre-Emacs 30): rimette
;;   ispell-complete-word su C-M-i dentro text-mode-map, oscurandolo in TUTTI
;;   i modi derivati, Org compreso, dove quel tasto serve al completamento di
;;   Org stesso;
;; - il correttore ortografico è un'altra cosa e non viene toccato:
;;   M-x flyspell-mode e M-x ispell continuano a funzionare come prima.
(setopt text-mode-ispell-word-completion nil)

;;; ---

;; Corfu: popup di completamento DENTRO il buffer mentre si scrive (codice, testo...).
;; Completa la famiglia vertico, che si occupa solo del minibuffer.
;; Con corfu-auto il popup compare da solo dopo qualche carattere; TAB conferma.

(use-package corfu
  :custom
  (corfu-auto t)
  :init
  (global-corfu-mode 1)
  :config
  ;; Estensione inclusa in corfu: mostra la documentazione del candidato
  ;; accanto al popup, dopo una breve pausa.
  (corfu-popupinfo-mode 1))


(provide 'my-completion)
;;; my-completion.el ends here
