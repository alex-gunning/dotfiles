;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!
(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("stable" . "https://stable.melpa.org/packages/")
                         ("gnu" . "https://elpa.gnu.org/packages/")
                         ("nongnu" . "https://elpa.nongnu.org/nongnu/")))
(customize-set-variable 'package-archive-priorities '(("gnu"    . 99)
                                                      ("nongnu" . 80)
                                                      ("stable" . 70)
                                                      ("melpa"  . 0)))
(add-to-list 'auto-mode-alist '("\\.yml\\'" . yaml-mode))
(add-to-list 'auto-mode-alist '("\\.yaml\\'" . yaml-mode))

(use-package exec-path-from-shell :ensure t)
(exec-path-from-shell-initialize)

;(require 'yaml-mode)
(require 'graphql-mode)
(require 'graphql-doc)
(require 'hcl-mode)
(require 'nerd-icons)
(require 'git-modes)
(require 'treemacs-evil)
(add-to-list 'auto-mode-alist '("\\.tf\\'" . terraform-mode))
(add-to-list 'auto-mode-alist '("\\.kt\\'" . kotlin-mode))
;; (add-to-list 'load-path "/your/path/to/dockerfile-mode/")
(require 'dockerfile-mode)
(setq confirm-kill-emacs nil)

;; Java Config
;; Mac-only
;;(setenv "JAVA_HOME"  "/Library/Java/JavaVirtualMachines/openjdk.jdk/Contents/Home/")
;;(setq lsp-java-java-path "/Library/Java/JavaVirtualMachines/openjdk.jdk/Contents/Home/bin/java")


(use-package eglot
  :config
  (setq eglot-report-progress nil))
(use-package eglot-java :ensure t)
  ;; (add-to-list
  ;;  'eglot-server-programs
  ;;  `((java-mode java-ts-mode) .
  ;;    ("jdtls"
  ;;     :initializationOptions
  ;;     (:bundles ["/home/torstein/.m2/repository/com/microsoft/java/com.microsoft.java.debug.plugin/0.51.1/com.microsoft.java.debug.plugin-0.51.1.jar"]))))

  ;; :hook
  ;; ((python-mode . eglot-ensure))

  ;; :bind
  ;; (("<f7>" . dape-step-in)
  ;;  ("<f8>" . dape-next)
  ;;  ("<f9>" . dape-continue)))

;;(use-package dape
;;  :after eglot
;;  :config
;;  (add-to-list
;;   'dape-configs
;;   `(java8705
;;     modes (java-mode java-ts-mode)
;;     hostname "localhost"
;;     port (lambda () (eglot-execute-command (eglot-current-server) "vscode.java.startDebugSession" nil))
;;     :request "attach"
;;     :hostname "localhost"
;;     :port 8705
;;     :type "java")))

;; (use-package eglot-java :after eglot)
;; ;;(use-package dap-mode :after lsp-mode :config (dap-auto-configure-mode))

(use-package projectile)
(use-package flycheck)
(use-package yasnippet :config (yas-global-mode))
(use-package lsp-mode :hook ((lsp-mode . lsp-enable-which-key-integration))
  :config (setq lsp-completion-enable-additional-text-edit nil))
(use-package hydra)
(use-package company)
(use-package lsp-ui)
(use-package which-key :config (which-key-mode))
(use-package lsp-java :config (add-hook 'java-mode-hook 'lsp))
(use-package dap-mode :after lsp-mode :config (dap-auto-configure-mode))
(use-package dap-java :ensure nil)
(use-package helm-lsp)
(use-package helm)
(use-package lsp-treemacs)
(use-package git-gutter)
;; (lsp-log-io t)

(use-package projectile
  :ensure t
  :init (projectile-mode +1)
  :config
  (define-key
   projectile-mode-map
   (kbd "C-c p")
   'projectile-command-map))

(add-hook 'compilation-filter-hook
          (lambda () (ansi-color-apply-on-region (point-min) (point-max))))

(use-package lsp-mode
  :bind
  (:map lsp-mode-map
        (("\C-\M-b" . lsp-find-implementation)
         ("M-RET" . lsp-execute-code-action))))

(use-package dap-java
  :ensure nil
  :after (lsp-java)

  :config
  (global-set-key (kbd "<f7>") 'dap-step-in)
  (global-set-key (kbd "<f8>") 'dap-next)
  (global-set-key (kbd "<f9>") 'dap-continue))

(defun my-java-mode-hook ()
  (auto-fill-mode)
  (flycheck-mode)
  (git-gutter-mode)
  (subword-mode)
  (yas-minor-mode)
  (set-fringe-style '(8 . 0))
  (unless (display-graphic-p)
    (set-face-background 'dap-ui-marker-face "color-166")
    (set-face-attribute 'dap-ui-marker-face nil :inherit nil)
    (set-face-background 'dap-ui-pending-breakpoint-face "blue")
    (set-face-attribute 'dap-ui-verified-breakpoint-face nil :inherit 'dap-ui-pending-breakpoint-face))

  (define-key c-mode-base-map (kbd "C-M-j") 'tkj-insert-serial-version-uuid)
  (define-key c-mode-base-map (kbd "C-m") 'c-context-line-break)
  (define-key c-mode-base-map (kbd "S-<f7>") 'gtags-find-tag-from-here)

  ;; Fix indentation for anonymous classes
  (c-set-offset 'substatement-open 0)
  (if (assoc 'inexpr-class c-offsets-alist)
      (c-set-offset 'inexpr-class 0))

  ;; Indent arguments on the next line as indented body.
  (c-set-offset 'arglist-intro '++))
(add-hook 'java-mode-hook 'my-java-mode-hook)

;; Setup splashscreen
(setq fancy-splash-image "~/splash.svg")

(load! "vim-overrides.el")
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

;; LSP Configs
(setq lsp-semantic-tokens-enable t)
(setq lsp-semantic-tokens-honor-refresh-requests t)
(setq lsp-enable-links t)
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
;; (setq doom-theme 'doom-acario-dark)
(after! doom-themes
  (load-theme 'doom-nano-dark t))

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
