;;; my-appearance.el --- Aspetto: temi, caratteri, spaziatura -*- lexical-binding: t -*-

;;; Commentary:

;; Tema (compresi i temi personali sotto themes/), tipografia e
;; spaziatura della cornice.
;;
;; L'ordine interno di questo file conta: custom-theme-load-path prima
;; della dichiarazione del pacchetto, la dichiarazione prima di ogni
;; load-theme, e spacious-padding dopo il caricamento del tema.

;;; Code:
;; Personal themes live in the repository, under themes/, so that they
;; are tracked by git.  This MUST come before the modus-themes package
;; declaration: the manual warns that customizing custom-theme-load-path
;; afterwards breaks the loading of theme files.
(add-to-list 'custom-theme-load-path
             (expand-file-name "themes/" user-emacs-directory))

;; modus-themes from GNU ELPA, installed on top of the copy bundled with
;; Emacs 30 (version 4.x).  Reference version: 5.3.0.  Version 5 is what
;; brings the palette machinery we are after: semantic mappings, palette
;; overrides and derivative themes.
;;
;; This declaration MUST come before any `load-theme' call, and it is the
;; whole point of the block.  Both copies sit on disk at once: the built-in
;; themes are not in the `load-path' and are reached through `require-theme',
;; while the ELPA copy is an ordinary package reached through `require'.
;; Declaring the package is what makes the ELPA one win.
;;
;; :demand t defeats use-package's lazy loading on purpose -- the theme has to
;; be in place at startup, not on first use.  :ensure is implicit here, since
;; use-package-always-ensure is set further up.
;;
;; Cost: the package is loaded at every startup, but this is not new -- a
;; theme file pulls it in anyway.  What changes is only which copy is loaded.
;;
;; Graceful degradation is left to the block below, which keeps using plain
;; `load-theme': that works on both 4.x and 5.x, so on a machine where this
;; package fails to install, Emacs falls back to the bundled themes.

(use-package modus-themes
  :demand t)

;;; ---

;; Piccole rifiniture estetiche dei temi modus: corsivo per commenti e costrutti "doc", grassetto per le parole chiave.
;; Vanno valutate PRIMA del caricamento del tema; cambiandole a Emacs avviato, il tema va ricaricato.
;; Nota: dalla versione 5 queste due opzioni governano molte più facce di prima (diverse facce che erano incondizionatamente in grassetto o corsivo ora dipendono da qui). Aspettati quindi più grassetti e corsivi rispetto alla 4.x: se non piacciono, la leva è questa.

(setq modus-themes-italic-constructs t
      modus-themes-bold-constructs t)

;;; ---

;; Tema che segue automaticamente l'aspetto di sistema chiaro/scuro.
;; L'hook ns-system-appearance-change-functions è una funzionalità esclusiva di Emacs Plus: se la build in uso non ce l'ha (Emacs vanilla, terminale...), si ripiega su un tema fisso.
;; La funzione è idempotente (disattiva prima i temi attivi), quindi un'eventuale doppia chiamata all'avvio è innocua.
;; Nota: si usa load-theme e non modus-themes-load-theme (comodo, perché disattiva da sé i temi attivi) perché quest'ultimo esiste solo nella 5.x: load-theme mantiene il file funzionante anche dove il pacchetto non è installato.
;; Nota sulla barra del titolo trasparente (early-init.el): con ns-appearance a nil (il default), macOS fa seguire alla finestra l'aspetto di sistema. Poiché anche il tema segue l'aspetto di sistema, barra e tema restano sincronizzati PER COSTRUZIONE: nessun intervento necessario. Servirebbe impostare ns-appearance solo adottando un tema fisso scollegato dal sistema.

;; Attenzione a non aggiungere un load-theme fuori dall'`if' qui sotto: verrebbe
;; eseguito SEMPRE, anche dopo il ramo scuro, e sovrapporrebbe il tema chiaro a
;; quello appena caricato senza disattivarlo. Il sintomo è insidioso, perché il
;; difetto colpisce solo l'AVVIO: cambiando aspetto a Emacs già aperto scatta
;; l'hook, che chiama my/apply-theme da sola e ripulisce tutto.
;; Controllo rapido: C-h v custom-enabled-themes deve elencare UN SOLO tema.

(defun my/apply-theme (appearance)
  "Carica il tema adatto ad APPEARANCE (`light' o `dark')."
  (mapc #'disable-theme custom-enabled-themes)  ; evita temi sovrapposti
  (pcase appearance
    ('light (load-theme 'chaun-bay t))
    ('dark  (load-theme 'chaun-bay-dark t))))

(if (boundp 'ns-system-appearance-change-functions)
    (progn
      (add-hook 'ns-system-appearance-change-functions #'my/apply-theme)
      ;; Applica il tema già all'avvio (fallback su 'light se la variabile non è ancora valorizzata, es. avvio come daemon).
      (my/apply-theme (or (and (boundp 'ns-system-appearance)
                               ns-system-appearance)
                          'light)))
  (load-theme 'chaun-bay t))

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

;;; --- Aspetto: spaziatura di finestre e riquadri ---

;; spacious-padding (GNU ELPA): visual-only tweaks to frame parameters
;; and faces.  No command or key binding is affected.
;;
;; What it buys us: side-by-side windows are separated by a band of
;; background colour instead of a 1 px line, so each pane reads as a
;; distinct surface.  Mode line and fringes gain some breathing room.
;;
;; Placement matters: this block must come AFTER the theme is loaded,
;; because the mode reads the background of the `default' face in order
;; to paint the dividers with it.
;;
;; Reversible at any time with M-x spacious-padding-mode: the mode stores
;; the original frame parameters and restores them when disabled.  One
;; exception, the scroll bar; see below.
(use-package spacious-padding
  :custom
  ;; The plist below carries the upstream defaults, kept for visibility.
  ;; Three values differ from them and are marked CHANGED inline.
  ;;
  ;; 1. :internal-border-width is the space between the frame edge and
  ;;    its contents, on all four sides -- below the minibuffer included.
  ;;    Set to 12 to match the dividers, so the frame keeps one uniform
  ;;    margin all around.
  ;;    MUST be kept in sync with early-init.el, which paints the first
  ;;    frame before this file is read: a mismatch shows up as the margin
  ;;    visibly jumping at startup.
  ;;
  ;; 2. :right-divider-width is lowered from the upstream 30, which is
  ;;    too much here because the divider is not the whole gutter: two
  ;;    side-by-side windows are already separated by a fringe, the
  ;;    scroll bar and another fringe.
  ;;    Never set it below 2: the package hides the `vertical-border'
  ;;    face unconditionally, but paints the divider only when its width
  ;;    is greater than 1.  Below that, windows would end up with no
  ;;    visible separation at all.
  ;;
  ;; 3. :scroll-bar-width must match the native macOS scroll bar width or
  ;;    the bar gets clipped; the upstream default of 8 targets the thin
  ;;    GTK bar.  Measure it with M-: (frame-scroll-bar-width) after
  ;;    setting that frame parameter to nil.  Two caveats: nil is not
  ;;    usable in this plist (the package falls back to a hardcoded 8),
  ;;    and turning the mode off does not restore the native width
  ;;    either -- that takes a restart.
  (spacious-padding-widths
   '( :internal-border-width 14   ; CHANGED - margin around the frame
      :header-line-width 4
      :mode-line-width 6
      :custom-button-width 3
      :tab-width 4
      :right-divider-width 12     ; CHANGED - gap between side-by-side windows
      :scroll-bar-width 17        ; CHANGED - native macOS width
      :fringe-width 8))
  :init
  (spacious-padding-mode 1)
  :config
  ;; The package handles the right divider only: it has no
  ;; :bottom-divider-width key, so windows stacked with C-x 2 would get
  ;; no gap at all, with the mode line as their only separator.  We set
  ;; that frame parameter ourselves, at the same 12 px as everything
  ;; else.  It reads as empty space because the package already paints
  ;; the `window-divider' face with the background colour, and that face
  ;; covers the bottom divider too.
  ;;
  ;; Kept inside :config on purpose: without spacious-padding the divider
  ;; would show up as a visible grey bar.
  ;;
  ;; Two calls because they cover different frames: default-frame-alist
  ;; applies to frames created later, modify-all-frames-parameters to the
  ;; one already open at startup.
  (let ((width 12))
    (add-to-list 'default-frame-alist `(bottom-divider-width . ,width))
    (modify-all-frames-parameters `((bottom-divider-width . ,width)))))


(provide 'my-appearance)
;;; my-appearance.el ends here
