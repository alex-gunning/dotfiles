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
      "'" #'evil-repeat-find-char
      "K" #'jump-5-lines-next
      "L" #'jump-5-lines-previous
      "C-]" #'evil-goto-definition
      "?" #'evil-lookup
      "gd" #'evil-jump-to-tag
      "S-<right>" #'centaur-tabs-forward
      "S-<left>" #'centaur-tabs-backward)

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
