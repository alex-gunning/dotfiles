(defun jump-5-lines-previous ()
  (interactive)
  (evil-previous-line 5))
(defun jump-5-lines-next ()
  (interactive)
  (evil-next-line 5))
(defun jump-1-lines-next ()
  (interactive)
  (evil-next-line 1))
(defun visual-jump-5-lines-previous ()
  (interactive)
  (evil-previous-visual-line 5))
(defun visual-jump-5-lines-next ()
  (interactive)
  (evil-next-visual-line 5))

;; nil overrides
(map! :after evil
      :map evil-outer-text-objects-map
      "'" nil)
(map! :after evil
      :map evil-motion-state-map
      ";" nil)

;; vim-mode maps
(map! :after evil
      :map evil-motion-state-map
      "j" #'evil-backward-char
      "k" #'evil-next-line
      "l" #'evil-previous-line
      ";" #'evil-next-char
      "K" #'jump-5-lines-next
      "L" #'jump-5-lines-previous
      "C-]" #'evil-goto-definition
      "?" #'evil-lookup
      "gd" #'evil-jump-to-tag
      "S-<right>" #'centaur-tabs-forward
      "S-<left>" #'centaur-tabs-backward
      :desc "Magit pull" "SPC g p" #'magit-pull
      :desc "Magit push" "SPC g P" #'magit-push
;; Evil Snipe = Vim find
      "'" #'evil-snipe-repeat)

(map! :after evil
      :map evil-normal-state-map
      "K" #'jump-5-lines-next
      "C" #'evil-lookup
      ";" #'evil-forward-char)

(map! :after evil
      :map evil-visual-state-map
      "j" #'evil-backward-char
      "k" #'evil-next-line
      "l" #'evil-previous-line
      ";" #'evil-forward-char
      "K" #'jump-5-lines-next
      "L" #'jump-5-lines-previous)

(map! :after evil
      :map evil-visual-state-map
      "K" #'visual-jump-5-lines-next
      "L" #'visual-jump-5-lines-previous)

;; emacs maps
(map! :after evil
      :map evil-window-map
      "j" #'evil-window-left
      "k" #'evil-window-down
      "l" #'evil-window-up
      ";" #'evil-window-right)

(map! :after evil
      :map evil-normal-state-map
      "SPC c r" #'eglot-rename
      "SPC c a" #'eglot-code-actions)

(use-package eglot
  :config
  (setq eglot-report-progress nil)
  :bind
  (("M-RET" . eglot-code-actions)))


;; (map! :after evil
;;       :map evil-snipe-override-local-mode-map
;;       ";" nil)
(map! :after evil :map general-override-mode-map :nv ";" nil)

;; Treemacs Evil
(defun treemacs-jump-5-lines-next ()
  (interactive)
  (treemacs-next-line 5))
(defun treemacs-jump-5-lines-previous ()
  (interactive)
  (treemacs-previous-line 5))
(after! treemacs
  (define-key evil-treemacs-state-map (kbd "j") nil)
  (define-key evil-treemacs-state-map (kbd "k") #'treemacs-next-line)
  (define-key evil-treemacs-state-map (kbd "l") #'treemacs-previous-line)
  (define-key evil-treemacs-state-map (kbd "K") #'treemacs-jump-5-lines-next)
  (define-key evil-treemacs-state-map (kbd "L") #'treemacs-jump-5-lines-previous)
  (evil-define-key 'treemacs treemacs-mode-map (kbd "j") #'treemacs-COLLAPSE-action)
  (evil-define-key 'treemacs treemacs-mode-map (kbd "l") nil)
  (evil-define-key 'treemacs treemacs-mode-map (kbd ";") #'treemacs-RET-action))

;; Org Agenda Evil
(map! :after org-agenda-mode-map
      :map org-agenda-mode-map
      "k" #'org-agenda-next-line
      "l" #'org-agenda-previous-line)
;; (after! org-agenda-mode-map
;;   (define-key org-agenda-mode-map (kbd "h") nil)
;;   (evil-define-key 'org-agenda-mode-map org-agenda-mode-map (kbd "k") #'org-agenda-next-line)
;;   (evil-define-key 'org-agenda-mode-map org-agenda-mode-map (kbd "l") #'org-agenda-previous-line))



;; Magit Evil

;; (map! :after magit-log-mode-map
;;       :map magit-log-mode-map
;;       "k" #'magit-log-mo
;;       "SPC c a" #'eglot-code-actions)
