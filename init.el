
;;; init.el -*- lexical-binding: t -*-

;; Configurazione principale, caricata dopo early-init.el.

;;; --- Dove vive questa configurazione (promemoria) ---

;; Seguiamo la convenzione XDG: la cartella di configurazione è ~/.config/emacs/ (valore di user-emacs-directory) e NON ~/.emacs.d/.
;; Percorsi principali:
;; - questo file:              ~/.config/emacs/init.el
;; - early-init.el:            ~/.config/emacs/early-init.el
;; - pacchetti installati:     ~/.config/emacs/elpa/
;; - indici degli archivi:     ~/.config/emacs/elpa/archives/  (gnu, nongnu, melpa)
;; - custom.el, backups/, auto-saves/: sempre qui dentro (via locate-user-emacs-file)
;; Ogni comando da Terminale (backup, ls, cp...) va quindi indirizzato a ~/.config/emacs/
;; Verifica rapida in Emacs:  M-:  (list user-emacs-directory package-user-dir)

;;; --- Comportamenti di base ---

;; Le personalizzazioni fatte da menu/interfaccia finiscono nel file separato (custom.el) invece di sporcare questo init.el.
;; Nota: il file viene caricato in fondo a questo init.el, così le sue impostazioni non entrano in conflitto con quanto configurato qui sotto.

(setq custom-file (locate-user-emacs-file "custom.el"))

;;; ---

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

;; Riapre ogni file esattamente nel punto in cui l'avevamo lasciato.

(save-place-mode 1)

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

;; Prima che un kill di Emacs (C-k, C-w...) sovrascriva gli appunti di sistema, il loro contenuto viene salvato nel kill-ring: recuperabile in qualsiasi momento con M-y (consult-yank-pop, vedi Utilità).
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
;; Nota: C-h f/v/k/x sono riassegnati a helpful (vedi Utilità), che seleziona già da sé la propria finestra.
;; Questa impostazione agisce quindi sulle finestre di aiuto RIMANENTI (C-h m, C-h b, C-h e...).

(setq help-window-select t)

;;; ---

;; Nei buffer di testo (non di codice), le righe lunghe vanno a capo ai confini di parola, come negli editor di testo moderni.
;; È un a-capo solo VISIVO: il file su disco non cambia.
;; Nota: l'hook si propaga anche ai modi derivati da text-mode (Org, Markdown...). Di norma è proprio ciò che si vuole.

(add-hook 'text-mode-hook #'visual-line-mode)

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

;; Le cancellazioni fatte da Emacs (es. da dired) finiscono nel Cestino di macOS invece di essere definitive.
;; Nota: senza trash-directory, la build NS di Emacs userebbe il metodo freedesktop.org (~/.local/share/Trash), una cartella invisibile al Finder. Puntando a ~/.Trash i file finiscono nel vero Cestino.
;; Nota: i file cestinati da Emacs perdono la funzione "Ripristina" del Finder (macOS non ne registra la provenienza).

(setq delete-by-moving-to-trash t
      trash-directory "~/.Trash")

;;; ---

;; In dired, con due finestre dired affiancate, copia (C) e sposta (R) propongono automaticamente l'altra finestra come destinazione.
;; Trasforma dired in un file manager a due pannelli. Nessun tasto cambia: cambia solo il percorso PROPOSTO nel prompt, sempre modificabile.

(setq dired-dwim-target t)

;;; ---

;; In dired, dimensioni dei file leggibili (KB, MB...) invece di byte grezzi.
;; Il default è "-al"; l'opzione -h aggiunta qui è supportata anche dal ls BSD di macOS (il requisito di dired, la presenza di -l, resta rispettato).
;; Nota: --group-directories-first (cartelle in cima) richiederebbe invece il ls GNU (coreutils via Homebrew, poi insert-directory-program): rimandato.

(setq dired-listing-switches "-alh")

;;; ---

;; ibuffer (integrato): versione OPERATIVA dell'elenco buffer, sullo stesso tasto e con lo stesso scopo di list-buffers: marca, chiude, salva più buffer insieme, raggruppa.
;; Stessa sostituzione "un gradino sopra" già fatta con recentf-open su C-x C-r: il tasto standard resta, cambia solo il comando (più capace) che risponde.
;; Estensione futura: casual-ibuffer-tmenu su C-c o, con lo schema with-eval-after-load 'ibuffer già documentato per casual (vedi Utilità: la keymap di ibuffer non esiste all'avvio).

(keymap-global-set "C-x C-b" #'ibuffer)

;;; ---

;; so-long (integrato, Emacs 27+): assicurazione contro i file con righe lunghissime (JSON minificati, log...). Li rileva all'apertura e disattiva automaticamente le rifiniture costose, evitando blocchi.
;; Invisibile nel lavoro normale: interviene solo quando serve.

(global-so-long-mode 1)

;;; --- Memoria tra le sessioni (funzioni integrate) ---

;; Alza il limite dei file ricordati (il default è 20).

;; (setq recentf-max-saved-items 100)

;; Per il momento, mantengo l'impostazione di default.

;;; ---

;; Ricorda i file aperti di recente.
;; Di default C-x C-r è find-file-read-only, quindi lo riassegno all'elenco dei file recenti.

(recentf-mode 1)
(keymap-global-set "C-x C-r" #'recentf-open)

;;; ---

;; Ricorda la cronologia del minibuffer (comandi M-x, ricerche...) tra un riavvio e l'altro.

(savehist-mode 1)

;;; ---

;; I segnalibri (C-x r m per crearne uno, C-x r b per saltarci, C-x r l per elencarli) vengono salvati su disco a ogni modifica, invece che solo alla chiusura di Emacs.
;; Rete di sicurezza contro i crash: rende i bookmark affidabili tra sessioni.

(setq bookmark-save-flag 1)

;;; --- Archivio pacchetti e use-package ---

;; package.el è il gestore pacchetti integrato.
;; Di default conosce GNU ELPA e NonGNU ELPA; aggiungo MELPA, l'archivio comunitario.

(require 'package)
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/") t)

;; Quando un pacchetto esiste in più archivi, preferiamo quelli stabili (GNU, poi NonGNU) alle snapshot giornaliere di MELPA.
;; I pacchetti presenti SOLO su MELPA restano comunque installabili.

(setq package-archive-priorities
      '(("gnu" . 3) ("nongnu" . 2) ("melpa" . 1)))

;;; ---

;; Di default package.el rifiuta di aggiornare i pacchetti integrati.
;; Questa impostazione consente l'aggiornamento.
;; È di fatto necessaria per magit: dipende da transient (anch'esso integrato) e spesso ne richiede una versione più recente di quella inclusa in Emacs.
;; Vale lo stesso per casual (vedi Utilità), che richiede anch'esso un transient recente.
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

;;; --- Integrazione macOS ---

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

;;; ---

;; Piccole rifiniture estetiche dei temi modus: corsivo per commenti e costrutti "doc", grassetto per le parole chiave.

(setq modus-themes-italic-constructs t
      modus-themes-bold-constructs t)

;;; ---

;; Tema che segue automaticamente l'aspetto di sistema chiaro/scuro.
;; Usa i temi modus, integrati in Emacs.
;; L'hook ns-system-appearance-change-functions è una funzionalità esclusiva di Emacs Plus: se la build in uso non ce l'ha (Emacs vanilla, terminale...), si ripiega su un tema fisso.
;; La funzione è idempotente (disattiva prima i temi attivi), quindi un'eventuale doppia chiamata all'avvio è innocua.
;; Nota sulla barra del titolo trasparente (early-init.el): con ns-appearance a nil (il default), macOS fa seguire alla finestra l'aspetto di sistema. Poiché anche il tema segue l'aspetto di sistema, barra e tema restano sincronizzati PER COSTRUZIONE: nessun intervento necessario. Servirebbe impostare ns-appearance solo adottando un tema fisso scollegato dal sistema.

(defun my/apply-theme (appearance)
  "Carica il tema adatto ad APPEARANCE (`light' o `dark')."
  (mapc #'disable-theme custom-enabled-themes)  ; evita temi sovrapposti
  (pcase appearance
    ('light (load-theme 'modus-operandi t))
    ('dark  (load-theme 'modus-vivendi t))))
(if (boundp 'ns-system-appearance-change-functions)
    (progn
      (add-hook 'ns-system-appearance-change-functions #'my/apply-theme)
      ;; Applica il tema già all'avvio (fallback su 'light se la variabile non è ancora valorizzata, es. avvio come daemon).
      (my/apply-theme (or (and (boundp 'ns-system-appearance)
                               ns-system-appearance)
                          'light)))
  (load-theme 'modus-operandi t))

;;; --- Aspetto: caratteri e tipografia ---

;; Carattere predefinito a 14 punti (il default di macOS è Menlo 12).
;; JetBrains Mono, font open source (licenza OFL).
;; Se non è installato, si ripiega su Menlo (font proprietario Apple, preinstallato).
;; L'altezza è in decimi di punto: 140 = 14 pt.
;; Nota: cambiando il font, la finestra si ridimensiona da sola per mantenere le colonne/righe.

(let ((famiglia (seq-find (lambda (f) (member f (font-family-list)))
                          '("JetBrains Mono" "Menlo"))))
  (when famiglia
    (set-face-attribute 'default nil :family famiglia :height 140)))

;;; ---

;; Interlinea leggermente aumentata (2 pixel extra tra le righe)
;; Stile app MacOS.

(setq-default line-spacing 2)

;;; --- Minibuffer moderno ---

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

;;; --- Completamento nel buffer ---

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

;;; --- Utilità ---

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

;;; ---

;; Vundo: mostra la cronologia di annullamento come un albero navigabile con le frecce. Invio conferma, q annulla.
;; (C-/ resta l'undo "semplice".)

(use-package vundo
  :bind ("C-x u" . vundo))

;;; ---

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

;;; --- Programmazione ---

;; Tree-sitter: Emacs 30 include il supporto ai modi *-ts-mode (es. python-ts-mode), con evidenziazione della sintassi molto più precisa di quella classica.
;; treesit-auto: quando si apre un file, propone di installare la grammatica mancante e attiva automaticamente il modo tree-sitter corrispondente.

(use-package treesit-auto
  :custom
  (treesit-auto-install 'prompt)   ; chiede conferma prima di scaricare una grammatica
  :config
  (treesit-auto-add-to-auto-mode-alist 'all)
  (global-treesit-auto-mode 1))

;;; ---

;; Eglot: client LSP INTEGRATO in Emacs (diagnostica, documentazione, rinomina, vai-a-definizione...).
;; Non si avvia da solo: in un buffer di codice, eseguire M-x eglot.
;; Richiede il language server del linguaggio, installato a parte (es. via Homebrew: pyright per Python, gopls per Go, rust-analyzer per Rust...).
;; Grazie a exec-path-from-shell, i server installati via Homebrew vengono trovati.

(use-package eglot
  :ensure nil)                ; integrato

;; Avvio automatico di eglot per linguaggio: decommentare la riga corrispondente
;; DOPO aver installato il language server (es. via Homebrew).
;; Nota: con treesit-auto i modi attivi sono quelli *-ts-mode.
;; (add-hook 'python-ts-mode-hook #'eglot-ensure)   ; richiede pyright
;; (add-hook 'go-ts-mode-hook     #'eglot-ensure)   ; richiede gopls
;; (add-hook 'rust-ts-mode-hook   #'eglot-ensure)   ; richiede rust-analyzer

;;; --- Meow: editing modale ---

;; Configurazione QWERTY ufficiale, come suggerita dalla documentazione.

(defun my/meow-setup ()
  "Layout QWERTY standard per meow (dalla documentazione ufficiale)."
  (setq meow-cheatsheet-layout meow-cheatsheet-layout-qwerty)
  (meow-motion-define-key
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

;;; --- Caricamento di custom.el (per ultimo) ---

;; Caricato in fondo, così le personalizzazioni salvate da M-x customize non vengono sovrascritte dal resto dell'init.

(when (file-exists-p custom-file)
  (load custom-file))
