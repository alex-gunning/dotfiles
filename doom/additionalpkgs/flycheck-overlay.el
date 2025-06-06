;;; flycheck-overlay.el --- Display Flycheck errors with overlays -*- lexical-binding: t -*-

;; Copyright (C) 2025 Free Software Foundation, Inc.

;; Author: Mikael Konradsson <mikael.konradsson@outlook.com>
;; Version: 0.7.5
;; Package-Requires: ((emacs "27.1") (flycheck "0.23"))
;; Keywords: convenience, tools
;; URL: https://github.com/konrad1977/flycheck-overlay

;;; Commentary:
;; This package provides a way to display Flycheck errors using overlays.
;; It offers customization options for icons, colors, and display behavior.

;;; Code:

(define-advice flycheck-overlays-in (:override (beg end) disable-sorting)
  "Get flycheck overlays between BEG and END without sorting."
  (seq-filter (lambda (ov) (overlay-get ov 'flycheck-overlay))
              (overlays-in beg end)))

(require 'flycheck)
(require 'flymake)
(require 'cl-lib)

(defgroup flycheck-overlay nil
  "Display Flycheck/Flymake errors using overlays."
  :prefix "flycheck-overlay-"
  :group 'tools)

(defcustom flycheck-overlay-debug nil
  "Enable debug messages for flycheck-overlay."
  :type 'boolean
  :group 'flycheck-overlay)

(defcustom flycheck-overlay-checkers '(flycheck flymake)
  "Checkers to use for displaying errors.
Supported values are `flycheck` and `flymake`."
  :type '(set (const :tag "Flycheck" flycheck)
              (const :tag "Flymake" flymake))
  :group 'flycheck-overlay)

(defface flycheck-overlay-error
  '((t :inherit error
       :height 0.9
       :weight normal))
  "Face used for error overlays.
Inherits from the theme's error face."
  :group 'flycheck-overlay)

(defface flycheck-overlay-warning
  '((t :inherit warning
       :height 0.9
       :weight normal))
  "Face used for warning overlays.
Inherits from the theme's warning face."
  :group 'flycheck-overlay)

(defface flycheck-overlay-info
  '((t :inherit success
       :height 0.9
       :weight normal))
  "Face used for info overlays.
Inherits from the theme's success face."
  :group 'flycheck-overlay)

(defface flycheck-overlay-marker
  '((t :inherit link
       :height 0.9
       :weight bold))
  "Face used for info overlays."
  :group 'flycheck-overlay)

(defcustom flycheck-overlay-text-tint 'lighter
  "Tint type for text.  Possible values: nil, \='lighter, \='darker."
  :type '(choice (const :tag "No tinting" nil)
                 (const :tag "Lighter than base color" lighter)
                 (const :tag "Darker than base color" darker))
  :group 'flycheck-overlay)

(defcustom flycheck-overlay-text-tint-percent 50
  "Percentage to lighten or darken the text when tinting is enabled."
  :type 'integer
  :group 'flycheck-overlay)

(defcustom flycheck-overlay-info-icon " "
  "Icon used for information."
  :type 'string
  :group 'flycheck-overlay)

(defcustom flycheck-overlay-warning-icon " "
  "Icon used for warnings."
  :type 'string
  :group 'flycheck-overlay)

(defcustom flycheck-overlay-error-icon " "
  "Icon used for warnings."
  :type 'string
  :group 'flycheck-overlay)

(defcustom flycheck-overlay-virtual-line-icon nil
  "Icon used for the virtual line."
  :type 'string
  :group 'flycheck-overlay)

(defcustom flycheck-overlay-percent-darker 50
  "Icon background percent darker.
Based on foreground color"
  :type 'integer
  :group 'flycheck-overlay)

(defcustom flycheck-overlay-use-theme-colors t
  "Use theme colors for error, warning, and info faces.
When non-nil, adapts colors from the current theme."
  :type 'boolean
  :group 'flycheck-overlay)

(defcustom flycheck-overlay-background-lightness 75
  "Background lightness percentage for overlay faces.
Lower values make backgrounds darker."
  :type 'integer
  :group 'flycheck-overlay)

(defcustom flycheck-overlay-show-at-eol nil
  "Show error messages at the end of the line."
  :type 'boolean
  :group 'flycheck-overlay)

(defcustom flycheck-overlay-hide-when-cursor-is-on-same-line t
  "Hide error messages when the cursor is on the same line."
  :type 'boolean
  :group 'flycheck-overlay)

(defcustom flycheck-overlay-hide-when-cursor-is-at-same-line nil
  "Hide error messages when cursor is at same line as error.
Unlike `flycheck-overlay-hide-when-cursor-is-on-same-line', this
only hides when cursor is at the exact line position of the error."
  :type 'boolean
  :group 'flycheck-overlay)

(defcustom flycheck-overlay-hide-checker-name t
  "Hide the checker name in the error message."
  :type 'boolean
  :group 'flycheck-overlay)

(defcustom flycheck-overlay-show-virtual-line t
  "Show a virtual line to highlight the error a bit more."
  :type 'boolean
  :group 'flycheck-overlay)

(defcustom flycheck-overlay-icon-left-padding 0.9
  "Padding to the left of the icon."
  :type 'number
  :group 'flycheck-overlay)

(defcustom flycheck-overlay-icon-right-padding 0.5
  "Padding to the right of the icon."
  :type 'number
  :group 'flycheck-overlay)

(defcustom flycheck-overlay-debounce-interval 0.2
  "Time in seconds to wait before checking and displaying errors after a change."
  :type 'number
  :group 'flycheck-overlay)

(defcustom flycheck-overlay-virtual-line-type 'curved-dotted-arrow
  "Arrow used to point to the error.
Provides various line styles including
straight, curved, bold, and dotted variations,
with and without arrow terminators."
  :type '(choice
          ;; Basic styles (no arrow)
          (const :tag "No indicator" nil)
          (const :tag "Straight line" line-no-arrow)
          (const :tag "Curved line" curved-line-no-arrow)
          (const :tag "Double line" double-line-no-arrow)
          (const :tag "Bold line" bold-line-no-arrow)
          (const :tag "Dotted line" dotted-line-no-arrow)

          ;; Straight variants with arrow
          (const :tag "Straight line + arrow" straight-arrow)
          (const :tag "Double line + arrow" double-line-arrow)
          (const :tag "Bold line + arrow" bold-arrow)
          (const :tag "Dotted line + arrow" dotted-arrow)

          ;; Curved variants with arrow
          (const :tag "Curved line + arrow" curved-arrow)
          (const :tag "Curved bold + arrow" curved-bold-arrow)
          (const :tag "Curved double + arrow" curved-double-arrow)
          (const :tag "Curved dotted + arrow" curved-dotted-arrow)

          (const :tag "arrow" arrow)
          (const :tag "line" line))
  :group 'flycheck-overlay)

(defcustom flycheck-overlay-line-position-offset 1
  "Number of lines below the error line to display the overlay.
A value of 1 means the overlay appears on the next line after the error.
A value of 0 means the overlay appears on the same line as the error."
  :type 'integer
  :group 'flycheck-overlay)

(defcustom flycheck-overlay-wrap-messages t
  "Whether to wrap long error messages across multiple lines.
When non-nil, long messages will be displayed on multiple lines.
When nil, messages will be truncated to fit on a single line."
  :type 'boolean
  :group 'flycheck-overlay)

(defcustom flycheck-overlay-max-line-length 80
  "Maximum length of each line when wrapping messages.
Only used when `flycheck-overlay-wrap-messages' is non-nil."
  :type 'integer
  :group 'flycheck-overlay)

(defvar-local flycheck-overlay--overlays nil
  "List of overlays used in the current buffer.")

(defvar flycheck-overlay--debounce-timer nil
  "Timer used for debouncing error checks.")

;; Color cache for performance optimization
(defvar flycheck-overlay--color-cache (make-hash-table :test 'equal)
  "Cache for computed colors to avoid repeated calculations.")

;; Priority constants
(defconst flycheck-overlay--error-priority 3000
  "Priority value for error overlays.")

(defconst flycheck-overlay--warning-priority 2000
  "Priority value for warning overlays.")

(defconst flycheck-overlay--info-priority 1000
  "Priority value for info overlays.")

;; Error handling utilities
(defun flycheck-overlay--handle-error (error-symbol error-data context &optional operation)
  "Centralized error handling for flycheck-overlay.
ERROR-SYMBOL is the error type, ERROR-DATA contains error details,
CONTEXT provides operation context, and OPERATION is optional operation name."
  (let ((error-msg (format "flycheck-overlay error in %s: %s - %s"
                          (or operation context)
                          error-symbol
                          (if (stringp error-data) error-data (format "%S" error-data)))))
    (when flycheck-overlay-debug
      (message "Debug: %s" error-msg))
    ;; Return nil to indicate failure
    nil))

(defvar flycheck-overlay-regex-mark-quotes  "\\('[^']+'\\|\"[^\"]+\"\\|\{[^\}]+\}\\)"
  "Regex to match quoted strings or everything after a colon.")

(defvar flycheck-overlay-regex-mark-parens "\\(\([^\)]+\)\\)"
  "Regex used to mark parentheses.")

(defvar flycheck-overlay-checker-regex "^[^\"'(]*?:\\(.*\\)"
  "Regex used to match the checker name at the start of the error message.")

(defun flycheck-overlay-get-arrow-type ()
  "Return the arrow character based on the selected style."
  (pcase flycheck-overlay-virtual-line-type
    ;; Basic styles (no arrow)
    ('line-no-arrow "└──")
    ('curved-line-no-arrow "╰──")
    ('double-line-no-arrow "╚══")
    ('bold-line-no-arrow "┗━━")
    ('dotted-line-no-arrow "└┈┈")

    ;; Straight variants with arrow
    ('straight-arrow "└──►")
    ('double-line-arrow "╚══►")
    ('bold-arrow "┗━━►")
    ('dotted-arrow "└┈┈►")

    ;; Curved variants with arrow
    ('curved-arrow "╰──►")
    ('curved-bold-arrow "╰━━►")
    ('curved-double-arrow "╰══►")
    ('curved-dotted-arrow "╰┈┈►")

    ('arrow "──►")
    ('line "──")

    ;; Default/fallback
    ('no-arrow "")
    (_ "→")))

(defun flycheck-overlay-get-arrow ()
  "Return the arrow character based on the selected style."
  (if (not flycheck-overlay-show-virtual-line)
      ""
    (if (not flycheck-overlay-virtual-line-icon)
        (flycheck-overlay-get-arrow-type)
      flycheck-overlay-virtual-line-icon)))

(defun flycheck-overlay--get-flymake-diagnostics ()
  "Get all current Flymake diagnostics for this buffer."
  (when (and (memq 'flymake flycheck-overlay-checkers)
             (bound-and-true-p flymake-mode))
    (flymake-diagnostics)))

(defun flycheck-overlay--convert-flymake-diagnostic (diag)
  "Convert a Flymake DIAG to Flycheck error format."
  (let* ((beg (flymake-diagnostic-beg diag))
         (type (flymake-diagnostic-type diag))
         (text (flymake-diagnostic-text diag))
         (level (pcase type
                 ('flymake-error 'error)
                 ('flymake-warning 'warning)
                 ('flymake-note 'info)
                 (_ 'warning))))
    (flycheck-error-new-at
     (line-number-at-pos beg)
     (save-excursion
       (goto-char beg)
       (current-column))
     level
     text)))

(defun flycheck-overlay--get-all-errors ()
  "Get all errors from enabled checkers."
  (let (all-errors)
    (when (memq 'flycheck flycheck-overlay-checkers)
      (setq all-errors (append all-errors flycheck-current-errors)))
    (when (memq 'flymake flycheck-overlay-checkers)
      (setq all-errors
            (append all-errors
                    (mapcar #'flycheck-overlay--convert-flymake-diagnostic
                            (flycheck-overlay--get-flymake-diagnostics)))))
    all-errors))

(defun flycheck-overlay--error-position-< (err1 err2)
  "Compare two errors ERR1 and ERR2 by position."
  (let ((line1 (flycheck-error-line err1))
        (line2 (flycheck-error-line err2))
        (col1 (flycheck-error-column err1))
        (col2 (flycheck-error-column err2)))
    (or (< line1 line2)
        (and (= line1 line2)
             (< (or col1 0) (or col2 0))))))

(defun flycheck-overlay--is-valid-error (err)
  "Check if ERR is a valid flycheck error with proper positioning."
  (and err
       (not (eq err t))
       (flycheck-error-p err)
       (let ((line (flycheck-error-line err))
             (column (flycheck-error-column err)))
         (and (numberp line)
              (>= line 0)
              (or (not column)
                  (and (numberp column) (>= column 0)))))))

(defun flycheck-overlay--filter-errors (errors)
  "Filter out invalid ERRORS.
This function ensures all errors are valid and have proper positions."
  (condition-case filter-err
      (when (and errors (listp errors))
        (let ((valid-errors (seq-filter #'flycheck-overlay--is-valid-error errors)))
          (when flycheck-overlay-debug
            (message "Debug: Valid errors: %S" valid-errors))
          valid-errors))
    (error
     (flycheck-overlay--handle-error 'filter-error filter-err "error filtering" "filter-errors"))))

(defun flycheck-overlay--get-error-region (err)
  "Get the start and end position for ERR."
  (condition-case region-err
      (save-excursion
        (save-restriction
          (widen)
          (let* ((line (flycheck-error-line err))
                 (start-pos (progn
                              (goto-char (point-min))
                              (forward-line (1- line))  ; line is 1-based
                              (point))))  ; Always get position, even for empty lines
            (when start-pos
              (goto-char start-pos)
              (let ((end-pos (line-end-position)))
                ;; For empty lines, ensure we still have a valid region
                (when (= start-pos end-pos)
                  (setq end-pos (1+ start-pos)))
                (when (and (numberp start-pos) (numberp end-pos)
                           (> start-pos 0) (> end-pos 0)
                           (<= start-pos (point-max))
                           (<= end-pos (point-max)))
                  (cons start-pos end-pos)))))))
    (error
     (flycheck-overlay--handle-error 'region-error region-err "get-error-region" "get-error-region"))))

(defun flycheck-overlay--create-overlay (region level msg &optional error)
  "Create an overlay at REGION with LEVEL and message MSG.
REGION should be a cons cell (BEG . END) of buffer positions.
LEVEL is the error level (error, warning, or info).
ERROR is the optional original flycheck error object."
  (let ((overlay nil))
    (condition-case ov-err
        (let* ((beg (car region))
               (end (cdr region)))
          (save-excursion
            (goto-char (min end (point-max)))
            (let* ((next-line-beg (if flycheck-overlay-show-at-eol
                                    end
                                    (progn
                                      (forward-line flycheck-overlay-line-position-offset)
                                      (line-beginning-position))))
                   (face (flycheck-overlay--get-face level)))
              (when (and (numberp beg)
                        (numberp end)
                        (numberp next-line-beg)
                        (> beg 0)
                        (> end 0)
                        (> next-line-beg 0)
                        (<= beg (point-max))
                        (<= end (point-max))
                        (<= next-line-beg (point-max)))
                (setq overlay (make-overlay beg next-line-beg))
                (when (overlayp overlay)
                  (flycheck-overlay--configure-overlay overlay face msg beg error))))))
      (error
       (flycheck-overlay--handle-error 'overlay-creation ov-err "create-overlay"
                                       (format "region=%S level=%S" region level))))
    overlay))

(defun flycheck-overlay--get-face (type)
  "Return the face corresponding to the error TYPE."
  (pcase type
    ('error 'flycheck-overlay-error)
    ('warning 'flycheck-overlay-warning)
    ('info 'flycheck-overlay-info)
    ;; Handle string type names (from flymake conversion)
    ("error" 'flycheck-overlay-error)
    ("warning" 'flycheck-overlay-warning)
    ("info" 'flycheck-overlay-info)
    ;; Default to warning for any other type
    (_ 'flycheck-overlay-warning)))

(defun flycheck-overlay--get-indicator (type color)
  "Return the indicator string corresponding to the error TYPE COLOR"
  (let* ((props (pcase type
                  ('flycheck-overlay-error
                   (cons flycheck-overlay-error-icon 'flycheck-overlay-error))
                  ('flycheck-overlay-warning
                   (cons flycheck-overlay-warning-icon 'flycheck-overlay-warning))
                  ('flycheck-overlay-info
                   (cons flycheck-overlay-info-icon 'flycheck-overlay-info))
                  (_
                   (cons flycheck-overlay-warning-icon 'flycheck-overlay-warning))))
         (icon (car props))
         (face-name (cdr props))
         (height (face-attribute face-name :height))
         (bg (if flycheck-overlay-use-theme-colors
                 (pcase face-name
                   ('flycheck-overlay-error
                    (flycheck-overlay--get-theme-face-color 'error :foreground))
                   ('flycheck-overlay-warning
                    (flycheck-overlay--get-theme-face-color 'warning :foreground))
                   ('flycheck-overlay-info
                    (flycheck-overlay--get-theme-face-color 'success :foreground))
                   (_ (face-attribute face-name :foreground)))
               (face-attribute face-name :foreground)))
         (bg-color (flycheck-overlay--darken-color bg flycheck-overlay-percent-darker)))

    (concat
     ;; Left padding
     (propertize " "
                 'face `(:background ,bg-color, :height ,height)
                 'display '(space :width flycheck-overlay-icon-left-padding))
     ;; Icon
     (propertize icon
                 'face `(:foreground ,color :background ,bg-color, :height ,height)
                 'display '(raise -0.02))
     ;; Right padding
     (propertize " "
                 'face `(:background ,bg-color, :height ,height)
                 'display '(space :width flycheck-overlay-icon-right-padding)))))


(defun flycheck-overlay--calculate-overlay-priority (error)
  "Calculate overlay priority based on ERROR level and column position."
  (let* ((col-pos (when (flycheck-error-p error)
                    (or (flycheck-error-column error) 0)))
         (level-priority (pcase (flycheck-error-level error)
                           ('error flycheck-overlay--error-priority)
                           ('warning flycheck-overlay--warning-priority)
                           ('info flycheck-overlay--info-priority)
                           (_ flycheck-overlay--warning-priority))))
    (- level-priority (or col-pos 0))))

(defun flycheck-overlay--setup-basic-overlay-properties (overlay error)
  "Set up basic properties for OVERLAY with ERROR."
  (overlay-put overlay 'flycheck-overlay t)
  (overlay-put overlay 'evaporate t)
  (overlay-put overlay 'modification-hooks
               '(flycheck-overlay--clear-overlay-on-modification))
  (overlay-put overlay 'priority (flycheck-overlay--calculate-overlay-priority error))
  (when (flycheck-error-p error)
    (overlay-put overlay 'flycheck-error error)))

(defun flycheck-overlay--create-overlay-display-components (face error msg)
  "Create display components for overlay with FACE, ERROR, and MSG.
Returns a plist with :fg-color, :bg-color, :tinted-fg, :face-with-colors,
:indicator, :virtual-line, and :marked-string."
  (let* ((colors (flycheck-overlay--get-face-colors (flycheck-error-level error)))
         (fg-color (car colors))
         (bg-color (cdr colors))
         (tinted-fg (if flycheck-overlay-text-tint
                        (flycheck-overlay--tint-color
                         fg-color
                         flycheck-overlay-text-tint
                         flycheck-overlay-text-tint-percent)
                      fg-color))
         (face-with-colors `(:inherit ,face
                                      :foreground ,tinted-fg
                                      :background ,bg-color))
         (indicator (flycheck-overlay--get-indicator face tinted-fg))
         (virtual-line (when flycheck-overlay-show-virtual-line
                         (propertize (flycheck-overlay-get-arrow)
                                     'face `(:foreground ,fg-color))))
         (display-msg (concat " " msg " "))
         (marked-string (flycheck-overlay--mark-all-symbols
                         :input (propertize display-msg
                                            'face face-with-colors
                                            'cursor-sensor-functions nil
                                            'rear-nonsticky t)
                         :regex flycheck-overlay-regex-mark-quotes
                         :property `(:inherit flycheck-overlay-marker
                                              :background ,bg-color))))
    (list :fg-color fg-color
          :bg-color bg-color
          :tinted-fg tinted-fg
          :face-with-colors face-with-colors
          :indicator indicator
          :virtual-line virtual-line
          :marked-string marked-string)))

(defun flycheck-overlay--build-final-overlay-string (components error msg)
  "Build the final overlay string from display COMPONENTS, ERROR, and MSG."
  (let* ((col-pos (when (flycheck-error-p error)
                    (or (flycheck-error-column error) 0)))
         (line-content (string-trim
                        (buffer-substring-no-properties
                         (line-beginning-position)
                         (line-end-position))))
         (is-empty-line (string-empty-p line-content))
         (indicator (plist-get components :indicator))
         (virtual-line (plist-get components :virtual-line))
         (face-with-colors (plist-get components :face-with-colors))
         (bg-color (plist-get components :bg-color))
         (wrapped-lines (flycheck-overlay--wrap-message msg flycheck-overlay-max-line-length))
         (overlay-string (if flycheck-overlay-show-at-eol
                             (concat " " virtual-line indicator
                                     (flycheck-overlay--mark-all-symbols
                                      :input (propertize (concat " " (car wrapped-lines) " ")
                                                        'face face-with-colors)
                                      :regex flycheck-overlay-regex-mark-quotes
                                      :property `(:inherit flycheck-overlay-marker
                                                           :background ,bg-color)))
                           (flycheck-overlay--create-multiline-overlay-string
                            (if is-empty-line 0 col-pos) virtual-line indicator
                            wrapped-lines face-with-colors bg-color))))
    (if flycheck-overlay-show-at-eol
        overlay-string
      (concat overlay-string "\n"))))

(defun flycheck-overlay--create-multiline-overlay-string (col-pos virtual-line indicator lines face-with-colors bg-color)
  "Create multiline overlay string for LINES.
COL-POS is the column position, VIRTUAL-LINE is the line indicator,
INDICATOR is the error/warning icon, LINES are the wrapped message lines,
FACE-WITH-COLORS is the face for text, and BG-COLOR is the background color."
  (when flycheck-overlay-debug
    (message "Debug multiline overlay-string: starting with col-pos=%S lines=%S" col-pos lines))
  (let* ((spaces (if (and (not flycheck-overlay-show-at-eol) col-pos)
                     (make-string col-pos ?\s)
                   ""))
         (first-line (car lines))
         (remaining-lines (cdr lines))
         (first-line-string (concat spaces
                                   virtual-line
                                   indicator
                                   (flycheck-overlay--mark-all-symbols
                                    :input (propertize (concat " " first-line " ")
                                                       'face face-with-colors)
                                    :regex flycheck-overlay-regex-mark-quotes
                                    :property `(:inherit flycheck-overlay-marker
                                                         :background ,bg-color))))
         (continuation-lines (mapcar (lambda (line)
                                      (concat spaces
                                             (make-string (length virtual-line) ?\s)
                                             (make-string (length indicator) ?\s)
                                             (flycheck-overlay--mark-all-symbols
                                              :input (propertize (concat " " line " ")
                                                                'face face-with-colors)
                                              :regex flycheck-overlay-regex-mark-quotes
                                              :property `(:inherit flycheck-overlay-marker
                                                                   :background ,bg-color))))
                                    remaining-lines))
         (all-lines (cons first-line-string continuation-lines))
         (result-string (string-join all-lines "\n")))

    (when flycheck-overlay-debug
      (message "Debug multiline overlay-string: created string successfully"))
    (flycheck-overlay--mark-all-symbols
     :input result-string
     :regex flycheck-overlay-regex-mark-parens
     :property `(:inherit flycheck-overlay-marker :background ,bg-color))))

(defun flycheck-overlay--configure-overlay (overlay face msg beg error)
  "Configure OVERLAY with FACE, MSG, BEG, and ERROR."
  (condition-case configure-err
      (when (overlayp overlay)
        (flycheck-overlay--setup-basic-overlay-properties overlay error)
        (let* ((components (flycheck-overlay--create-overlay-display-components face error msg))
               (final-string (flycheck-overlay--build-final-overlay-string components error msg)))
          (overlay-put overlay 'after-string
                       (propertize final-string
                                   'rear-nonsticky t
                                   'cursor-sensor-functions nil))))
    (error
     (flycheck-overlay--handle-error 'overlay-configuration configure-err
                                     "configure-overlay" (format "beg=%S" beg)))))

(defun flycheck-overlay--clear-overlay-on-modification (overlay &rest _)
  "Clear OVERLAY when the buffer is modified."
  (delete-overlay overlay))

(defun flycheck-overlay--create-overlay-string (col-pos virtual-line indicator marked-string bg-color)
  "Create the overlay string.
COL-POS is the column position.
VIRTUAL-LINE is the line indicator.
INDICATOR is the error/warning icon.
MARKED-STRING is the message with marked symbols.
BG-COLOR is the background color."
  (when flycheck-overlay-debug
    (message "Debug overlay-string: starting with col-pos=%S" col-pos))
  (let* ((spaces (if (and (not flycheck-overlay-show-at-eol) col-pos)
                     (make-string col-pos ?\s)
                   ""))
         (result-string
          (if flycheck-overlay-show-at-eol
              (concat " " indicator marked-string)
            (concat spaces
                   virtual-line
                   indicator
                   marked-string))))

    (when flycheck-overlay-debug
      (message "Debug overlay-string: created string successfully"))
    (flycheck-overlay--mark-all-symbols
     :input result-string
     :regex flycheck-overlay-regex-mark-parens
     :property `(:inherit flycheck-overlay-marker :background ,bg-color))))

(defun flycheck-overlay-replace-curly-quotes (text)
  "Replace curly quotes with straight quotes in TEXT."
  (replace-regexp-in-string "[“”]" "\""
    (replace-regexp-in-string "[‘’]" "'" text)))

(cl-defun flycheck-overlay--mark-all-symbols (&key input regex property)
  "Highlight all symbols matching REGEX in INPUT with specified PROPERTY."
  (save-match-data
    (setq input (flycheck-overlay-replace-curly-quotes input))  ; Replace curly quotes with straight quotes
    (let ((pos 0))
      (while (string-match regex input pos)
        (let* ((start (match-beginning 1))
               (end (match-end 1))
               (existing-face (text-properties-at start input))
               (new-face (append existing-face (list 'face property))))
          (add-text-properties start end new-face input)
          (setq pos end))))
    input))

(defun flycheck-overlay-errors-at (pos)
  "Return the Flycheck errors at POS."
  (delq nil (mapcar (lambda (ov)
                      (when-let* ((err (overlay-get ov 'flycheck-error)))
                        (when (flycheck-error-p err)
                          err)))
                    (overlays-at pos))))

(defun flycheck-overlay--remove-checker-name (msg)
  "Remove checker name prefix from (as MSG).
If it appears at the start.
Ignores colons that appear within quotes or parentheses."
  (when flycheck-overlay-hide-checker-name
    (let ((case-fold-search nil))
      ;; Match start of string, followed by any characters except quotes/parens,
      ;; followed by a colon, capturing everything after
      (if (string-match flycheck-overlay-checker-regex (flycheck-overlay-replace-curly-quotes msg))
          (setq msg (string-trim (match-string 1 msg))))))
  msg)

(defun flycheck-overlay--wrap-message (msg max-length)
  "Wrap MSG to multiple lines with each line no longer than MAX-LENGTH.
Returns a list of strings, each representing a line."
  (if (not flycheck-overlay-wrap-messages)
      (list msg)
    (let ((words (split-string msg " " t))
          (lines '())
          (current-line ""))
      (dolist (word words)
        (let ((potential-line (if (string-empty-p current-line)
                                 word
                               (concat current-line " " word))))
          (if (<= (length potential-line) max-length)
              (setq current-line potential-line)
            ;; Current word would make line too long
            (when (not (string-empty-p current-line))
              (push current-line lines))
            (setq current-line word))))
      ;; Add the last line if it's not empty
      (when (not (string-empty-p current-line))
        (push current-line lines))
      (nreverse lines))))

(defun flycheck-overlay--display-errors (&optional errors)
  "Display ERRORS using overlays."
  (condition-case display-err
      (let* ((filtered-errors (flycheck-overlay--filter-errors (or errors (flycheck-overlay--get-all-errors))))
             (sorted-errors (progn
                            (when flycheck-overlay-debug
                              (message "Before sorting: %S"
                                     (mapcar (lambda (err)
                                             (cons (flycheck-error-line err)
                                                   (flycheck-error-column err)))
                                             filtered-errors)))
                            (sort filtered-errors #'flycheck-overlay--error-position-<))))
      (when flycheck-overlay-debug
          (message "After sorting: %S"
                   (mapcar (lambda (err)
                           (cons (flycheck-error-line err)
                                 (flycheck-error-column err)))
                           sorted-errors))
          (message "Error levels: %S"
                   (mapcar #'flycheck-error-level sorted-errors)))

        (when filtered-errors
          (flycheck-overlay--clear-overlays)
          ;; Reverse the list to maintain correct display order
          (setq flycheck-overlay--overlays
                (cl-loop for err in filtered-errors
                         when (flycheck-error-p err)
                         for level = (flycheck-error-level err)
                         for msg = (flycheck-error-message err)
                         for cleaned-msg = (and msg (flycheck-overlay--remove-checker-name msg))
                         for region = (and cleaned-msg (flycheck-overlay--get-error-region err))
                         for overlay = (and region (flycheck-overlay--create-overlay
                                                    region level cleaned-msg err))
                         when overlay
                         collect overlay))))
    (error
     (when flycheck-overlay-debug
       (message "Debug: Display error: %S" display-err)))))

(defun flycheck-overlay--clear-overlays ()
  "Remove all flycheck overlays from the current buffer."
  (dolist (ov flycheck-overlay--overlays)
    (when (overlayp ov)
      (delete-overlay ov)))
  (setq flycheck-overlay--overlays nil)
  ;; Remove any remaining flycheck-overlay overlays
  (remove-overlays (point-min) (point-max) 'flycheck-overlay t))

;;;###autoload
(define-minor-mode flycheck-overlay-mode
  "Minor mode for displaying Flycheck errors using overlays."
  :lighter " fo"
  :group 'flycheck-overlay
  (if flycheck-overlay-mode
      (flycheck-overlay--enable)
    (flycheck-overlay--disable)))

(defun flycheck-overlay--safe-add-hook (hook function)
  "Safely add FUNCTION to HOOK if not already present."
  (unless (memq function (symbol-value hook))
    (add-hook hook function nil t)))

(defun flycheck-overlay--safe-remove-hook (hook function)
  "Safely remove FUNCTION from HOOK if present."
  (when (memq function (symbol-value hook))
    (remove-hook hook function t)))

(defun flycheck-overlay--enable ()
  "Enable Flycheck/Flymake overlay mode."
  (when (memq 'flycheck flycheck-overlay-checkers)
    (flycheck-overlay--safe-add-hook 'flycheck-after-syntax-check-hook
                                     #'flycheck-overlay--maybe-display-errors-debounced))
  (when (memq 'flymake flycheck-overlay-checkers)
    (flycheck-overlay--safe-add-hook 'flymake-after-show-buffer-diagnostics-hook
                                     #'flycheck-overlay--maybe-display-errors-debounced))
  (flycheck-overlay--safe-add-hook 'after-change-functions
                                   #'flycheck-overlay--handle-buffer-changes)
  (flycheck-overlay--safe-add-hook 'post-command-hook
                                   #'flycheck-overlay--maybe-display-errors-debounced)
  ;; Clear color cache when theme changes
  (flycheck-overlay--safe-add-hook 'after-load-theme-hook
                                   #'flycheck-overlay--clear-color-cache)
  ;; Force initial display of existing errors
  (flycheck-overlay--maybe-display-errors))

(defun flycheck-overlay--disable ()
  "Disable Flycheck/Flymake overlay mode."
  (when flycheck-overlay--debounce-timer
    (cancel-timer flycheck-overlay--debounce-timer)
    (setq flycheck-overlay--debounce-timer nil))
  (when (memq 'flycheck flycheck-overlay-checkers)
    (flycheck-overlay--safe-remove-hook 'flycheck-after-syntax-check-hook
                                        #'flycheck-overlay--maybe-display-errors-debounced))
  (when (memq 'flymake flycheck-overlay-checkers)
    (flycheck-overlay--safe-remove-hook 'flymake-after-show-buffer-diagnostics-hook
                                        #'flycheck-overlay--maybe-display-errors-debounced))
  (flycheck-overlay--safe-remove-hook 'after-change-functions
                                      #'flycheck-overlay--handle-buffer-changes)
  (flycheck-overlay--safe-remove-hook 'post-command-hook
                                      #'flycheck-overlay--maybe-display-errors-debounced)
  (flycheck-overlay--safe-remove-hook 'after-load-theme-hook
                                      #'flycheck-overlay--clear-color-cache)
  (setq flycheck-overlay--debounce-timer nil)
  (save-restriction
    (widen)
    (flycheck-overlay--clear-overlays)))

(defun flycheck-overlay--maybe-display-errors ()
  "Display errors except on current line."
  (unless (buffer-modified-p)
    (let ((current-line (line-number-at-pos))
          (current-col (current-column))
          (to-delete))
      (flycheck-overlay--display-errors)
      (dolist (ov flycheck-overlay--overlays)
        (when (and (overlayp ov)
                   (= (line-number-at-pos (overlay-start ov)) current-line))
          (when flycheck-overlay-hide-when-cursor-is-on-same-line
            (push ov to-delete))
          (when (and flycheck-overlay-hide-when-cursor-is-at-same-line
                     (overlay-get ov 'flycheck-error)
                     (= (flycheck-error-column (overlay-get ov 'flycheck-error))
                        current-col))
            (push ov to-delete))))
      ;; Delete collected overlays
      (dolist (ov to-delete)
        (delete-overlay ov)
        (setq flycheck-overlay--overlays (delq ov flycheck-overlay--overlays))))))

(defun flycheck-overlay--maybe-display-errors-debounced ()
  "Debounced version of `flycheck-overlay--maybe-display-errors`."
  (condition-case err
      (progn
        (when flycheck-overlay--debounce-timer
          (cancel-timer flycheck-overlay--debounce-timer))
        (setq flycheck-overlay--debounce-timer
              (run-with-idle-timer flycheck-overlay-debounce-interval nil
                                   #'flycheck-overlay--maybe-display-errors)))
    (error
     (message "Error in debounced display: %S" err)
     (setq flycheck-overlay--debounce-timer nil))))

(defun flycheck-overlay--handle-buffer-changes (beg end _len)
  "Handle buffer modifications by clearing overlays on the modified lines.
BEG and END mark the beginning and end of the changed region."
  (condition-case err
      (when (buffer-modified-p)
        (let* ((beg-line (line-number-at-pos beg))
               (end-line (line-number-at-pos end)))
          ;; Remove overlays on all modified lines
          (dolist (ov flycheck-overlay--overlays)
            (when (and ov
                      (overlayp ov)
                      (overlay-buffer ov)  ; Check if overlay is still valid
                      (let ((ov-line (line-number-at-pos (overlay-start ov))))
                        (and (>= ov-line beg-line) (<= ov-line end-line))))
              (delete-overlay ov)))
          ;; Update our list of valid overlays
          (setq flycheck-overlay--overlays
                (cl-remove-if-not (lambda (ov)
                                   (and (overlayp ov)
                                        (overlay-buffer ov)))
                                 flycheck-overlay--overlays))))
    (error
     (message "Error in flycheck-overlay--handle-buffer-changes: %S" err))))

(defun flycheck-overlay--get-cached-color (cache-key color-fn &rest args)
  "Get color from cache or compute and cache it using COLOR-FN with ARGS."
  (or (gethash cache-key flycheck-overlay--color-cache)
      (puthash cache-key (apply color-fn args) flycheck-overlay--color-cache)))

(defun flycheck-overlay--clear-color-cache ()
  "Clear the color cache."
  (clrhash flycheck-overlay--color-cache))

(defun flycheck-overlay--color-to-rgb (color)
  "Convert COLOR (hex or name) to RGB components."
  (let ((cache-key (format "rgb-%s" color)))
    (flycheck-overlay--get-cached-color
     cache-key
     (lambda (c)
       (let ((rgb (color-values c)))
         (if rgb
             (mapcar (lambda (x) (/ x 256)) rgb)
           (error "Invalid color: %s" c))))
     color)))

(defun flycheck-overlay--rgb-to-hex (r g b)
  "Convert R G B components to hex color string."
  (format "#%02x%02x%02x" r g b))

(defun flycheck-overlay--darken-color (color percent)
  "Darken COLOR by PERCENT."
  (let ((cache-key (format "darken-%s-%d" color percent)))
    (flycheck-overlay--get-cached-color
     cache-key
     (lambda (c p)
       (let* ((rgb (flycheck-overlay--color-to-rgb c))
              (darkened (mapcar (lambda (component)
                                 (min 255
                                      (floor (* component (- 100 p) 0.01))))
                               rgb)))
         (apply 'flycheck-overlay--rgb-to-hex darkened)))
     color percent)))

(defun flycheck-overlay--get-theme-face-color (face-name attribute &optional fallback)
  "Get color for FACE-NAME's ATTRIBUTE from current theme.
If not found, return FALLBACK color."
  (let ((color (face-attribute face-name attribute nil t)))
    (if (or (eq color 'unspecified) (not color))
        fallback
      color)))

(defun flycheck-overlay--create-background-from-foreground (fg-color lightness)
  "Create a background color from FG-COLOR with LIGHTNESS percent.
Lower LIGHTNESS values create darker backgrounds."
  (let ((cache-key (format "bg-%s-%d" fg-color lightness)))
    (flycheck-overlay--get-cached-color
     cache-key
     (lambda (fg l)
       (let* ((rgb (flycheck-overlay--color-to-rgb fg))
              (bg (mapcar (lambda (component)
                           (min 255
                                (floor (* component (/ l 100.0)))))
                         rgb)))
         (apply 'flycheck-overlay--rgb-to-hex bg)))
     fg-color lightness)))

(defun flycheck-overlay--get-face-colors (level)
  "Get foreground and background colors for error LEVEL.
Uses theme colors when `flycheck-overlay-use-theme-colors' is non-nil."
  (let ((fg (pcase level
              ((or 'error "error") (flycheck-overlay--get-theme-face-color 'error :foreground "#ea8faa"))
              ((or 'warning "warning") (flycheck-overlay--get-theme-face-color 'warning :foreground "#DCA561"))
              ((or 'info "info") (flycheck-overlay--get-theme-face-color 'success :foreground "#a8e3a9"))
              (_ (flycheck-overlay--get-theme-face-color 'warning :foreground "#DCA561")))))
    (cons fg (flycheck-overlay--create-background-from-foreground fg flycheck-overlay-background-lightness))))

(defun flycheck-overlay--tint-color (color tint percent)
  "Tint COLOR according to TINT type and PERCENT amount.
TINT should be either =\'lighter or =\'darker."
  (pcase tint
    ('lighter
     (let* ((rgb (flycheck-overlay--color-to-rgb color))
            (lightened (mapcar (lambda (component)
                                 (min 255
                                      (floor (+ component (* (- 255 component) (/ percent 100.0))))))
                               rgb)))
       (apply 'flycheck-overlay--rgb-to-hex lightened)))
    ('darker
     (flycheck-overlay--darken-color color percent))
    (_ color)))

(defun flycheck-overlay-toggle ()
  "Toggle Flycheck Overlay mode."
  (interactive)
  (if flycheck-overlay-mode
      (flycheck-overlay-mode -1)
    (flycheck-overlay-mode 1)))

(provide 'flycheck-overlay)
;;; flycheck-overlay.el ends here
