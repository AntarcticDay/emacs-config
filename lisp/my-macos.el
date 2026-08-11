;;; my-macos.el --- Integrazione con macOS -*- lexical-binding: t -*-

;;; Commentary:

;; Codice specifico della piattaforma Apple.  Su un altro sistema questo
;; modulo va rivisto: le impostazioni ns-* sono ignorate altrove, ma il
;; Cestino e exec-path-from-shell vanno riconsiderati.

;;; Code:
;; Tasti Option (⌥) e Meta.
;; Default di Emacs: ENTRAMBI i tasti Option fanno da Meta (il tasto M- di Emacs).
;; Su layout italiano è utile liberare l'Option destro per i simboli, lasciando solo il sinistro come Meta:

;; (setq ns-alternate-modifier 'meta
;;       ns-right-alternate-modifier 'none)

;; Uso il layout inglese internazionale, quindi i simboli @ # [ ] { } ~ restano accessibili anche così: mantengo il default.

;;; ---

;; Scorrimento fluido pixel per pixel, come le app native (trackpad).

(pixel-scroll-precision-mode 1)

;;; ---

;; Menu contestuale col tasto destro (integrato, Emacs 28+), come le app native.
;; Le voci cambiano in base al contesto (link, dired, regione selezionata...).
;; Nota: SOSTITUISCE il default di mouse-3 (mouse-save-then-kill, comando storico che estende la regione o taglia testo a seconda dei clic): potente ma arcano, più fonte di incidenti che di produttività.

(context-menu-mode 1)

;;; ---

;; Le cancellazioni fatte da Emacs (es. da dired) finiscono nel Cestino di macOS invece di essere definitive.
;; Nota: senza trash-directory, la build NS di Emacs userebbe il metodo freedesktop.org (~/.local/share/Trash), una cartella invisibile al Finder. Puntando a ~/.Trash i file finiscono nel vero Cestino.
;; Nota: i file cestinati da Emacs perdono la funzione "Ripristina" del Finder (macOS non ne registra la provenienza).

(setq delete-by-moving-to-trash t
      trash-directory "~/.Trash")

;;; ---

;; L'Emacs grafico avviato dal Finder non eredita il PATH della shell: strumenti installati via Homebrew (git, ripgrep, linters, LSP...) non verrebbero trovati.
;; exec-path-from-shell (open source, GPL, su MELPA) copia il PATH dalla shell di login.
;; Serve solo in modalità grafica o daemon: in un Emacs da terminale il PATH è già corretto.
;; Nota sulla forma: il `when' avvolge l'INTERA dichiarazione use-package, come indicato dal manuale di use-package (nodo "Conditional loading"): è l'unico modo per rendere condizionale anche l'INSTALLAZIONE. Il keyword :if condizionerebbe solo caricamento e configurazione: con use-package-always-ensure, il pacchetto verrebbe comunque installato anche a condizione falsa.

;; Nota: se l'avvio dovesse diventare lento, si può aggiungere prima dell'initialize:
;; (setq exec-path-from-shell-arguments '("-l"))   ; shell di login NON interattiva
;; (il default del pacchetto è una shell interattiva di login, più lenta da avviare).

(when (or (memq window-system '(mac ns x))
          (daemonp))
  (use-package exec-path-from-shell
    :config
    (exec-path-from-shell-initialize)))

;;; ---

;; I file aperti dal Finder ("Apri con...") si aprono nella finestra Emacs già esistente, invece di creare ogni volta una nuova finestra.

;; (setq ns-pop-up-frames nil)

;; Per il momento, mantengo l'impostazione di default.


(provide 'my-macos)
;;; my-macos.el ends here
