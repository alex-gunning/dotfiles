;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!
(load! "vim-overrides.el")
(setq package-archives
      '(("melpa" . "https://melpa.org/packages/")
	("elpa" . "https://elpa.gnu.org/packages/")))
(require 'yaml-mode)
(add-to-list 'auto-mode-alist '("\\.yml\\'" . yaml-mode))
(add-to-list 'auto-mode-alist '("\\.yaml\\'" . yaml-mode))
(require 'graphql-mode)
(require 'graphql-doc)
(require 'hcl-mode)
(add-to-list 'auto-mode-alist '("\\.tf\\'" . terraform-mode))
;; (add-to-list 'load-path "/your/path/to/dockerfile-mode/")
(require 'dockerfile-mode)
;; (setq-hook! 'js-mode-hook +format-with-lsp 'prettier-js-mode)
;; (setq-hook! 'js-mode-hook +format-with :none)
;; (add-hook 'js-mode-hook 'prettier-js-mode)
;(map! :after evil
;      :map evil-motion-state-map
;      "j" #'evil-backward-char
;      "k" #'evil-next-line
;      "l" #'evil-previous-line
;      ";" #'evil-next-char
;      "'" #'evil-repeat-find-char)
;(map! :after evil 
;      :map evil-normal-state-map
;      ";" #'evil-forward-char)
(after! lsp-ui
  (setq lsp-ui-sideline-diagnostic-max-lines 10))
(setenv "PATH" (concat (getenv "PATH") "/Users/alexl/.nvm/versions/node/v18.14.2/bin/node"))
(setq exec-path (append exec-path '("/Users/alexl/.nvm/versions/node/v18.14.2/bin/node")))
(setq exec-path (append exec-path '("/Users/alexl/go/bin")))
;; (setenv "PATH" (concat (getenv "PATH") "/Users/alexl/.nvm/versions/node/v18.14.2/bin/typescript-language-server"))
;; (setq exec-path (append exec-path '("/Users/alexl/.nvm/versions/node/v18.14.2/bin/typescript-language-server")))

;; accept completion from copilot and fallback to company
;; (use-package! copilot
;;   :hook (prog-mode . copilot-mode)
;;   :bind (:map copilot-completion-map
;;               ("<tab>" . 'copilot-accept-completion)
;;               ("TAB" . 'copilot-accept-completion)
;;               ("C-TAB" . 'copilot-accept-completion-by-word)
;;               ("C-<tab>" . 'copilot-accept-completion-by-word)
;;               ("C-M-]" . 'copilot-next-completion)))
;; Typescript
;; (define-derived-mode typescriptreact-mode web-mode "TypescriptReact"
;;   "A major mode for tsx.")

;; (use-package typescript-mode
;;   :mode (("\\.ts\\'" . typescript-mode)
;;          ("\\.tsx\\'" . typescriptreact-mode)))

;; (use-package eglot
;;   :ensure t
;;   :defer 3
;;   :hook
;;   ((js-mode
;;     typescript-mode
;;     typescriptreact-mode) . eglot-ensure)
;;   :config
;;   (cl-pushnew '((js-mode typescript-mode typescriptreact-mode) . ("typescript-language-server" "--stdio"))
;;               eglot-server-programs
;;               :test #'equal))
;;


(setq package-list '(dap-mode typescript-mode))
;; Loading tree-sitter package
;(require 'tree-sitter-langs)
;(require 'tree-sitter)

;; Activate tree-sitter globally (minor mode registered on every buffer)
;(global-tree-sitter-mode)
;(add-hook 'tree-sitter-after-on-hook #'tree-sitter-hl-mode)


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets. It is optional.
(setq user-full-name "John Doe"
      user-mail-address "john@doe.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom:
;;
;; - `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;; - `doom-unicode-font' -- for unicode glyphs
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face
;;
;; See 'C-h v doom-font' for documentation and more examples of what they
;; accept. For example:
;;
;;(setq doom-font (font-spec :family "Fira Code" :size 12 :weight 'semi-light)
;;      doom-variable-pitch-font (font-spec :family "Fira Sans" :size 13))
;;
;; If you or Emacs can't find your font, use 'M-x describe-font' to look them
;; up, `M-x eval-region' to execute elisp code, and 'M-x doom/reload-font' to
;; refresh your font settings. If Emacs still can't find your font, it likely
;; wasn't installed correctly. Font issues are rarely Doom issues!

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
;; (setq doom-theme 'doom-one)
(setq doom-theme 'doom-acario-dark)

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")


;; Whenever you reconfigure a package, make sure to wrap your config in an
;; `after!' block, otherwise Doom's defaults may override your settings. E.g.
;;
;;   (after! PACKAGE
;;     (setq x y))
;;
;; The exceptions to this rule:
;;
;;   - Setting file/directory variables (like `org-directory')
;;   - Setting variables which explicitly tell you to set them before their
;;     package is loaded (see 'C-h v VARIABLE' to look up their documentation).
;;   - Setting doom variables (which start with 'doom-' or '+').
;;
;; Here are some additional functions/macros that will help you configure Doom.
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;; Alternatively, use `C-h o' to look up a symbol (functions, variables, faces,
;; etc).
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.
