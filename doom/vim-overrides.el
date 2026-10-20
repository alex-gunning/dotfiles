(defun jump-5-lines-previous ()
  (interactive)
  (evil-previous-line 5))
(defun jump-5-lines-next ()
  (interactive)
  (evil-next-line 5))
(defun jump-1-lines-next ()
  (interactive)
  (evil-next-line 1))
(evil-define-motion visual-jump-5-lines-previous (count)
  :type line
  (evil-previous-line (* 5 (or count 1))))
(evil-define-motion visual-jump-5-lines-next (count)
  :type line
  (evil-next-line (* 5 (or count 1))))

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
      "S-s-<left>" #'centaur-tabs-move-current-tab-to-left
      "S-s-<right>" #'centaur-tabs-move-current-tab-to-right
      "SPC o i" #'treemacs-select-window
      :desc "Magit pull" "SPC g p" #'magit-pull
      :desc "Magit push" "SPC g P" #'magit-push
;; Evil Snipe = Vim find; ' repeats the last f/F/t/T. The after! block below
;; frees ; and , from snipe so ; stays a pure navigation key (move right).
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
      ";" #'evil-window-right
      "J" #'+evil/window-move-left
      "K" #'+evil/window-move-down
      "L" #'+evil/window-move-up
      ":" #'+evil/window-move-right)

(map! :after evil
      :map evil-normal-state-map
      "SPC c r" #'eglot-rename
      "SPC c a" #'eglot-code-actions)

(use-package eglot
  :config
  (setq eglot-report-progress nil)
  :bind
  (("M-RET" . eglot-code-actions)))


;; Evil-snipe (Doom's vim "find" on f/F/t/T) normally hijacks ; and , to repeat
;; the last find. We navigate with ; (move right), so take ; and , away from
;; snipe entirely and repeat with ' instead (see the evil-motion-state-map map).
(after! evil-snipe
  ;; Keep snipe from binding ;/, if these maps are ever rebuilt.
  (setq evil-snipe-override-evil-repeat-keys nil)
  ;; The always-on override map binds ;/, in motion state at load; scrub them.
  (evil-define-key* 'motion evil-snipe-override-local-mode-map
    ";" nil
    "," nil)
  ;; A transient map is active for the keypress right after f/F/t/T and inherits
  ;; ;/, -> repeat from this parent map; scrub it so the first ; after a find is
  ;; plain navigation, not a repeat.
  (define-key evil-snipe-parent-transient-map ";" nil)
  (define-key evil-snipe-parent-transient-map "," nil))

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
;; evil-collection-magit only makes j/k vertical motions by default; h/l stay on
;; magit-dispatch/magit-log. Enabling horizontal movement turns h/l into char
;; motions and relocates those commands to H (dispatch), L (log) and C-l
;; (log-refresh). Must be set before magit loads, so restart Emacs to apply.
(setq evil-collection-magit-want-horizontal-movement t)

;; Shift the motions one key to the right to match the global layout:
;; j = left, k = down, l = up, ; = right.
(map! :after magit
      :map magit-mode-map
      :nv "j" #'evil-backward-char
      :nv "k" #'evil-next-line
      :nv "l" #'evil-previous-line
      :nv ";" #'evil-forward-char)
