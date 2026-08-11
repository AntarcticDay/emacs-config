;;; chaun-bay-dark-theme.el --- Dark variant of the Chaun Bay theme -*- lexical-binding:t -*-

;; Author: Stefano
;; Keywords: faces, theme, accessibility

;;; Commentary:
;;
;; Dark counterpart of `chaun-bay'.  Same principle: only the palette
;; lives here, every face definition comes from `modus-themes-theme'.
;; Reference version: modus-themes 5.3.0.
;;
;; The palette ends by appending `modus-themes-vivendi-palette', so any
;; entry not defined here falls back to `modus-vivendi'.
;;
;; The two Chaun Bay files intentionally repeat their structure rather
;; than share a common palette.  Colours cannot be shared between a
;; light and a dark background -- a value that reads well on paper is
;; unreadable at night -- which is why Modus itself keeps one palette
;; per theme.  What the two files do share is the FAMILY symbol.

;;; Code:

(require 'modus-themes)

(defconst chaun-bay-dark-palette
  (append
   '(;; Basic values: warm near-black instead of pure black.
     ;; The foregrounds (fg-main, fg-dim, fg-alt) are inherited.
     (bg-main     "#1c1a16")
     (bg-dim      "#26231e")
     (bg-inactive "#2f2c26")
     (bg-active   "#3d392f")
     (border      "#5a544a"))
   modus-themes-vivendi-palette)
  "The entire palette of the `chaun-bay-dark' theme.")

(defcustom chaun-bay-dark-palette-user nil
  "Like `chaun-bay-dark-palette' for user-defined entries."
  :group 'modus-themes
  :type '(repeat (list symbol (choice symbol string))))

(defcustom chaun-bay-dark-palette-overrides nil
  "Overrides for `chaun-bay-dark-palette'."
  :group 'modus-themes
  :type '(repeat (list symbol (choice symbol string))))

(modus-themes-theme
 'chaun-bay-dark
 'chaun-bay
 "Personal theme with a warm near-black background."
 'dark
 'chaun-bay-dark-palette
 'chaun-bay-dark-palette-user
 'chaun-bay-dark-palette-overrides)

(provide 'chaun-bay-dark-theme)

;;; chaun-bay-dark-theme.el ends here
