;;; init-ui.el --- Emacs UI overhaul because the default sucks(tm)

(defun yuki/frame-mods (frame)
  (select-frame frame)
  (when window-system
    (fringe-mode '(nil . nil))
    (menu-bar-mode 1)
    (tool-bar-mode -1)
    (scroll-bar-mode -1)
    (modify-frame-parameters frame
                             `((vertical-scroll-bars . nil)
                               (horizontal-scroll-bars . nil)))))
(add-hook 'after-make-frame-functions 'yuki/frame-mods)
(add-hook 'after-init-hook
          (lambda ()
            (when window-system
              (yuki/frame-mods (selected-frame)))))

;; The superior completion front-end
(use-package ivy
  :bind
  ("C-c C-r" . ivy-resume)
  :init
  (setq ivy-use-virtual-buffers t
        enable-recursive-minibuffers t)
  (add-hook 'after-init-hook
            (lambda ()
              (ivy-mode t))))

;; The superior isearch
(use-package swiper
  :bind
  ("C-s" . swiper)
  ("C-r" . swiper))

;; Use the superior completion front end
(use-package counsel
  :bind
  ("M-x"     . counsel-M-x)
  ("C-x C-f" . counsel-find-file)
  ("<f1> f"  . counsel-describe-function)
  ("<f2> v"  . counsel-describe-variable)
  ("<f1> l"  . counsel-find-library)
  ("<f1> i"  . counsel-info-lookup-symbol)
  ("<f2> u"  . counsel-unicode-char)
  :config
  (define-key read-expression-map
    (kbd "C-r") 'counsel-expression-history))

;; The silver searcher
(setq ag-arguments "--hidden --ignore-case --path-to-ignore ~/.ignore")

(use-package ag
  :after counsel
  :config
  (defun custom-counsel-ag () (interactive)
         (counsel-ag nil nil ag-arguments))
  :bind
  ("C-c C-f" . custom-counsel-ag))

;; Display available keybindings in popup
(use-package which-key
  :init
  (setq which-key-idle-delay 0.5)
  (add-hook 'after-init-hook
            (lambda ()
              (which-key-mode t))))

;; Easier window management
(use-package switch-window
  :bind
  ("C-x o" . switch-window)
  ("C-x 1" . switch-window-then-maximize)
  ("C-x 2" . switch-window-then-split-below)
  ("C-x 3" . switch-window-then-split-right)
  ("C-x 0" . switch-window-then-delete)
  :init
  (setq switch-window-shortcut-style 'qwerty)
  (setq switch-window-qwerty-shortcuts
        '("a" "s" "d" "f" "j" "k" "l" ";" "w" "e" "i" "o"))
  (setq switch-window-minibuffer-shortcut ?z))

;; Dashboard
(use-package dashboard
  :init
  (setq dashboard-banner-logo-title "Gabriel is the best waifu!")
  (setq dashboard-startup-banner (concat user-emacs-directory "waifu.png"))
  (setq dashboard-center-content t)
  (setq dashboard-set-heading-icons t)
  (setq dashboard-set-file-icons t)
  (setq dashboard-set-navigator t)
  (setq dashboard-items `((recents . 5)
                          (projects . 5)
                          (registers . 5)))
  (dashboard-setup-startup-hook))

;; All the Icons
(use-package all-the-icons
  :ensure all-the-icons-dired
  :init
  (add-hook 'dired-mode-hook 'all-the-icons-dired-mode))

;; Theme settings
(use-package dracula-theme
  :init
  (load-theme 'dracula t))

;; Powerline ftw!
(use-package smart-mode-line-powerline-theme)

(use-package smart-mode-line
  :init
  (setq sml/theme 'powerline)
  (sml/setup))

;; Makes it clear where the fuck you're on(tm)
(use-package highlight-indent-guides
  :init
  (setq highlight-indent-guides-method 'fill)
  (add-hook 'prog-mode-hook #'highlight-indent-guides-mode))

;; A Better Git interface than git(1)
(use-package magit
  :bind
  ("C-x g" . magit-status))

;; Automatic whitespace cleanup
(use-package whitespace-cleanup-mode
  :init
  (add-hook 'after-init-hook
            (lambda ()
              (global-whitespace-cleanup-mode t))))

;; Persistent Undo
(use-package undo-tree
  :config
  (unless (file-directory-p "~/.emacs.d/undo")
    (make-directory "~/.emacs.d/undo"))
  (setq undo-tree-history-directory-alist '((".*" . "~/.emacs.d/undo")))
  (setq undo-tree-auto-save-history t))

;; Highlight TODOs
(use-package hl-todo
  :init
  (add-hook 'after-init-hook 'global-hl-todo-mode))

;; Highlight version control diffs
(use-package diff-hl
  :hook
  (dired-mode . diff-hl-dired-mode)
  :init
  (add-hook 'after-init-hook 'global-diff-hl-mode)
  (add-hook 'magit-post-refresh-hook 'diff-hl-magit-post-refresh))

;; Show colors for rgb(rr,gg,bb) and #rrggbb
(use-package rainbow-mode
  :init
  (add-hook 'prog-mode-hook #'rainbow-mode))

;; IMenu Anywhere
(use-package imenu-anywhere
  :bind
  ("C-c ." . imenu-anywhere))

;; Treemacs
(use-package treemacs
  :init
  (with-eval-after-load 'winum
    (define-key winum-keymap (kbd "M-0") #'treemacs-select-window))
  :bind
  ("M-0"       . treemacs-select-window)
  ("C-x t 1"   . treemacs-delete-other-windows)
  ("C-x t t"   . treemacs)
  ("C-x t B"   . treemacs-bookmark)
  ("C-x t C-t" . treemacs-find-file)
  ("C-x t M-t" . treemacs-find-tag))

(use-package treemacs-projectile
  :after treemacs projectile)

(use-package treemacs-icons-dired
  :after treemacs dired
  :config (treemacs-icons-dired-mode))

(use-package treemacs-magit
  :after treemacs magit)

;; Neotree cause well, easier than C-x C-f.
(use-package neotree
  :bind
  ("C-x f" . neotree-toggle)
  :init
  (setq neo-theme (if (display-graphic-p) 'icons 'arrow)))

(provide 'init-ui)
