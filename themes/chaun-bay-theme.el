;;; chaun-bay-theme.el --- Personal theme derived from the Modus themes -*- lexical-binding:t -*-

;; Author: me
;; Keywords: faces, theme, accessibility

;;; Commentary:
;;
;; Chaun Bay is a personal theme built on top of the modus-themes
;; engine.  Reference version: modus-themes 5.3.0.
;;
;; This is not a fork.  Only the palette lives here; every face
;; definition -- and the support for the hundreds of packages that come
;; with it -- is supplied by `modus-themes-theme'.
;;
;; A palette entry has one of two shapes:
;;
;;   (COLOR-NAME "#hexvalue")    a named color
;;   (MAPPING-NAME COLOR-NAME)   a semantic mapping onto a named color
;;
;; The palette below ends by appending `modus-themes-operandi-palette'.
;; Lookup returns the FIRST match, so anything not defined here falls
;; back to `modus-operandi'.  An incomplete palette is a working theme:
;; define what you care about, ignore the rest, refine over time.
;;
;; Changes made here require reloading the theme to take effect.

;;; Code:

(require 'modus-themes)

(defconst chaun-bay-palette
  (append
   '(;; -------------------------------------------------------------
     ;; Own entries.  Each one shadows the modus-operandi entry of the
     ;; same name.  Delete a line to fall back to modus-operandi.
     ;; -------------------------------------------------------------

     ;; Basic values: warm off-white paper instead of pure white.
     ;; The foregrounds (fg-main, fg-dim, fg-alt) are inherited.
     (bg-main     "#fbfaf7")
     (bg-dim      "#f1efe9")
     (bg-inactive "#e7e4dc")
     (bg-active   "#dbd7cd")
     (border      "#c2beb4"))
   modus-themes-operandi-palette)
  "The entire palette of the `chaun-bay' theme.")

(defcustom chaun-bay-palette-user nil
  "Like `chaun-bay-palette' for user-defined entries.
Extends the palette with extra named colors and/or semantic mappings,
for use together with `chaun-bay-palette-overrides'."
  :group 'modus-themes
  :type '(repeat (list symbol (choice symbol string))))

(defcustom chaun-bay-palette-overrides nil
  "Overrides for `chaun-bay-palette'.
Takes precedence over `modus-themes-common-palette-overrides'."
  :group 'modus-themes
  :type '(repeat (list symbol (choice symbol string))))

(modus-themes-theme
 'chaun-bay
 'chaun-bay
 "Personal theme with a warm off-white background."
 'light
 'chaun-bay-palette
 'chaun-bay-palette-user
 'chaun-bay-palette-overrides)

(provide 'chaun-bay-theme)

;;; chaun-bay-theme.el ends here
