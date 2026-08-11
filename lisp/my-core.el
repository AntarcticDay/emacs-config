;;; my-core.el --- Comportamenti di base -*- lexical-binding: t -*-

;;; Commentary:

;; Impostazioni fondamentali dell'editor: backup e auto-salvataggi,
;; aggiornamento automatico dei buffer, rifiniture di editing e di
;; navigazione.  Nessun pacchetto esterno: tutto integrato in Emacs.

;;; Code:
;; Salta la schermata di benvenuto all'avvio.
;; Il tutorial resta sempre disponibile con: C-h t

;; (setq inhibit-startup-screen t)

;; Per il momento preferisco mantenerla.

;;; ---

;; Niente segnale acustico per gli errori (es. C-g).

;; (setq ring-bell-function 'ignore)

;; Per il momento preferisco mantenerlo.

;;; ---

;; Risposte brevi ai prompt: y/n al posto di yes/no.
;; Emacs distingue apposta tra domande leggere (già y/n) e domande importanti o distruttive, per cui pretende "yes" per esteso.
;; Questa impostazione (integrata, Emacs 28+) elimina la distinzione.

;; (setq use-short-answers t)

;; Per il momento preferisco mantenere il default.

;;; ---

;; Conferma (y/n) prima di chiudere Emacs: intercetta C-x C-c e Cmd-Q accidentali.
;; Scelgo y-or-n-p (e non yes-or-no-p) perché la conferma scatta a OGNI uscita, anche quelle intenzionali: per una barriera così frequente l'attrito deve restare minimo.
;; I buffer non salvati sono comunque protetti da un prompt separato, indipendente da questa impostazione.

(setq confirm-kill-emacs #'y-or-n-p)

;;; ---

;; Emacs, di default, crea copie di backup ("file~") accanto ai file modificati.
;; Utile come rete di sicurezza, ma disordinato.
;; Le raccogliamo tutte in una cartella dedicata dentro la directory di configurazione di Emacs (user-emacs-directory: nel nostro caso ~/.config/emacs/).

(setq backup-directory-alist
      `(("." . ,(locate-user-emacs-file "backups"))))

;;; ---

;; Rifiniture ai backup:
;; - backup-by-copying: crea il backup copiando il file (più sicuro con i link simbolici);
;; - version-control: backup numerati (file.~1~, file.~2~, ...) invece di uno solo;
;; - delete-old-versions: elimina i backup più vecchi senza chiedere conferma.

(setq backup-by-copying t
      version-control t
      delete-old-versions t)

;;; ---

;; Oltre ai backup, Emacs sparge anche file di auto-salvataggio ("#file#") accanto ai file in modifica. Li raccogliamo in una cartella dedicata, come i backup.
;; Nota: a differenza della cartella dei backup, questa NON viene creata da sola.

(make-directory (locate-user-emacs-file "auto-saves/") t)
(setq auto-save-file-name-transforms
      `((".*" ,(locate-user-emacs-file "auto-saves/") t)))

;;; ---

;; Niente lockfile (".#file"). Servono solo se più istanze di Emacs modificano gli stessi file contemporaneamente.

(setq create-lockfiles nil)

;;; ---

;; Se un file viene modificato fuori da Emacs (es. da git o da un'altra app), il buffer si aggiorna da solo.
;; Estendiamo l'aggiornamento anche ai buffer non-file che lo supportano (in pratica: dired), così l'elenco di una cartella si aggiorna da solo quando il contenuto cambia sul disco.
;; Note:
;; - la variabile va impostata PRIMA di attivare global-auto-revert-mode (viene consultata quando il modo decide quali buffer prendere in gestione);
;; - il revert di dired preserva marcature e posizione del cursore;
;; - i percorsi remoti (TRAMP) sono esclusi di default (auto-revert-remote-files è nil): nessun polling costoso su connessioni lente.

(setq global-auto-revert-non-file-buffers t)
(global-auto-revert-mode 1)

;;; ---

;; winner-mode (integrato): annulla i cambi di disposizione delle finestre.
;; C-c <sinistra> ripristina la disposizione precedente, C-c <destra> riavanza.
;; Utile quando un help, una compilazione o magit stravolgono le finestre.
;; Con repeat-mode attivo (vedi più sotto), dopo il primo C-c <sinistra> basta ripremere la freccia per tornare indietro di più passi.

(winner-mode 1)

;;; ---

;; Digitando ( [ " si chiude automaticamente la coppia.

(electric-pair-mode 1)

;;; ---

;; Digitare con una selezione attiva la sostituisce (comportamento standard macOS).

(delete-selection-mode 1)

;;; ---

;; Prima che un kill di Emacs (C-k, C-w...) sovrascriva gli appunti di sistema, il loro contenuto viene salvato nel kill-ring: recuperabile in qualsiasi momento con M-y (consult-yank-pop, vedi my-minibuffer.el).
;; Rimedia a un incidente classico: copia in un'altra app, kill in Emacs, appunti persi.
;; Nota: con t il salvataggio avviene sempre, qualunque sia la dimensione degli appunti. Da Emacs 28 la variabile accetta anche un NUMERO (salva solo appunti fino a quella dimensione in caratteri): opzione di ripiego se copiare testi enormi altrove dovesse mai causare rallentamenti.

(setq save-interprogram-paste-before-kill t)

;; Kill ripetuti dello stesso testo non creano voci doppie nel kill-ring.
;; Nota: il confronto avviene solo con la voce in TESTA al kill-ring: elimina i duplicati CONSECUTIVI (caso tipico: C-w ripetuto sullo stesso testo), non quelli sparsi nella cronologia.

(setq kill-do-not-save-duplicates t)

;;; ---

;; repeat-mode (integrato): dopo certi comandi, basta ripremere l'ultimo tasto per ripetere, senza rifare il prefisso.
;; Esempi (Emacs 30 include già le repeat-map corrispondenti):
;; - C-x o o o...        salta di finestra in finestra;
;; - C-c <sinistra> <sinistra>...   winner-mode, più passi indietro;
;; - C-x { { }...        ridimensiona le finestre.
;; Note:
;; - un messaggio nell'echo area segnala quali tasti sono "caldi";
;; - la ripetizione si interrompe premendo un tasto qualsiasi fuori dalla mappa: quel tasto viene eseguito normalmente, nulla va perso;
;; - nessuna scorciatoia standard viene alterata.

(repeat-mode 1)

;;; ---

;; isearch (C-s) mostra il conteggio dei risultati ("3/17") mentre si digita.
;; Puro guadagno: nessun comando cambia.

(setq isearch-lazy-count t)

;;; ---

;; Le finestre di aiuto ricevono subito il focus: basta premere q per chiuderle, senza dover prima passarci dentro con C-x o.
;; Nota: C-h f/v/k/x sono riassegnati a helpful (vedi my-tools.el), che seleziona già da sé la propria finestra.
;; Questa impostazione agisce quindi sulle finestre di aiuto RIMANENTI (C-h m, C-h b, C-h e...).

(setq help-window-select t)

;;; ---

;; Nei buffer di testo (non di codice), le righe lunghe vanno a capo ai confini di parola, come negli editor di testo moderni.
;; È un a-capo solo VISIVO: il file su disco non cambia.
;; Nota: l'hook si propaga anche ai modi derivati da text-mode (Org, Markdown...). Di norma è proprio ciò che si vuole.

(add-hook 'text-mode-hook #'visual-line-mode)

;;; ---

;; Continuation lines of a wrapped line inherit the indentation, the comment
;; prefix or the list bullet of the line they belong to, instead of restarting
;; at the left margin.  Display only: the text on disk is untouched.
;; Built in since Emacs 30.1, where it absorbed the adaptive-wrap ELPA package
;; from GNU ELPA -- online advice still recommending that package is outdated.
;;
;; Enabled globally, and not only in text-mode: long lines wrap in code buffers
;; too (truncate-lines is nil by default there), and a wrapped comment or a long
;; argument list reads better indented under its own line.
;;
;; Cost: one jit-lock function per buffer, recomputing a prefix for the lines
;; being redisplayed.  Negligible on ordinary files; for the pathological case
;; see the so-long block at the end of this file.
;;
;; Two things worth knowing:
;; - the prefix is built out of SPACE characters, counted in characters and not
;;   in pixels.  In a proportionally spaced buffer (variable-pitch-mode, see
;;   my-appearance.el) indented paragraphs still line up exactly, while list
;;   bullets fall a couple of pixels short, because "- " is wider than two
;;   spaces.  Addressed in Emacs versions later than 30;
;; - org-indent-mode sets the same `wrap-prefix' text property, so the two will
;;   have to be reconciled when Org gets configured.
;;
;; Tuning knob: `visual-wrap-extra-indent' adds a fixed amount of indentation on
;; top of the computed one; a negative value takes some away.

(global-visual-wrap-prefix-mode 1)

;;; ---

;; I comandi di frase (M-a, M-e, M-k) e il riempimento dei paragrafi presumono, di default, la convenzione dattilografica americana: DUE spazi dopo il punto. In italiano non esiste: punto + uno spazio delimita la frase.
;; Nota: il rovescio della medaglia è che anche i punti delle abbreviazioni ("sig. Rossi", "ecc.") contano come fine frase. Compromesso comunque giusto: con il default, in un testo italiano M-e non riconoscerebbe quasi nessuna frase reale.

(setq sentence-end-double-space nil)

;;; ---

;; Numeri di riga ed evidenziazione della riga corrente, solo nei buffer di codice.

;; (add-hook 'prog-mode-hook #'display-line-numbers-mode)
;; (add-hook 'prog-mode-hook #'hl-line-mode)

;; Per il momento, mantengo l'impostazione di default.

;;; ---

;; ibuffer (integrato): versione OPERATIVA dell'elenco buffer, sullo stesso tasto e con lo stesso scopo di list-buffers: marca, chiude, salva più buffer insieme, raggruppa.
;; Stessa sostituzione "un gradino sopra" già fatta con recentf-open su C-x C-r: il tasto standard resta, cambia solo il comando (più capace) che risponde.
;; Estensione futura: casual-ibuffer-tmenu su C-c o, con lo schema with-eval-after-load 'ibuffer già documentato per casual (vedi my-tools.el: la keymap di ibuffer non esiste all'avvio).
;; Le icone accanto ai buffer elencati sono in my-icons.el.

(keymap-global-set "C-x C-b" #'ibuffer)

;;; ---

;; so-long (integrato, Emacs 27+): assicurazione contro i file con righe lunghissime (JSON minificati, log...). Li rileva all'apertura e disattiva automaticamente le rifiniture costose, evitando blocchi.
;; Invisibile nel lavoro normale: interviene solo quando serve.

(global-so-long-mode 1)

;; so-long switches off the expensive minor modes listed in so-long-minor-modes,
;; but visual-wrap-prefix-mode (see above) is not one of them in Emacs 30.  It
;; would keep computing wrap prefixes on exactly the lines so-long exists to
;; protect us from -- and those buffers really do wrap, because so-long
;; deliberately sets truncate-lines to nil in them, for faster vertical movement
;; inside a huge line.  So we add it to the list ourselves.
;; MUST come after the call above: so-long is autoloaded, so the variable only
;; comes into existence once global-so-long-mode has pulled the library in.

(add-to-list 'so-long-minor-modes 'visual-wrap-prefix-mode)


(provide 'my-core)
;;; my-core.el ends here
