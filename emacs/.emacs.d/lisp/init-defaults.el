;;; init-defaults.el --- Sane defaults

;; Start in *dashboard* frame for emacsclient.
(setq initial-buffer-choice (lambda () (get-buffer "*dashboard*")))

;; Disable the cursed ringing alarm bell. My ears are dead.
(setq visible-bell t)

;; Set default directory to $HOME
(setq default-directory "~/")

;; Increase GC threshold to 500 MB
(setq gc-cons-threshold 500000000)

;; Increase the amount of data which Emacs reads from the process. Current: 3mb
(setq read-process-output-max (* 3 1024 1024))

;; Treat camel case subwords as separate words in programming modes
(add-hook 'prog-mode-hook #'subword-mode)

;; Always follow symlinks
(setq vc-follow-symlinks t)

;; Make scripts executable on save
(add-hook 'after-save-hook
	  #'executable-make-buffer-file-executable-if-script-p)

;; Don't add two spaces after periods.
(setq sentence-end-double-space nil)

;; Make parent directory if they don't exist
(defun ask-make-parent-dir ()
  (when buffer-file-name
    (let ((dir (file-name-directory buffer-file-name)))
      (when (and (not (file-exists-p dir))
		 (y-or-n-p (format "Directory %s does not exist. Create it?" dir)))
	(make-directory dir t)))))

(add-hook 'before-save-hook #'ask-make-parent-dir)

;; Enable transient mark mode
(add-hook 'after-init-hook
	  (lambda ()
	    (transient-mark-mode t)))

;; Delete selected text if something is typed
(add-hook 'after-init-hook
	  (lambda ()
	    (delete-selection-mode t)))

;; Append newline at the end of files
(setq require-final-newline t)

;; Use `y/n?' instead of `yes/no?'
(fset #'yes-or-no-p #'y-or-n-p)

;; Use human-readable units in dired
(setq-default dired-listing-switched "-alh")

;; Turn on syntax highlighting whenever possible
(add-hook 'after-init-hook
	  (lambda ()
	    (global-font-lock-mode t)))

;; Always refresh file when something is changed
(add-hook 'after-init-hook
	  (lambda ()
	    (global-auto-revert-mode t)))

;; Visually indicate matching pairs of parentheses.
(setq show-paren-delay 0.0)
(setq show-paren-style 'expression)

(add-hook 'after-init-hook
	  (lambda ()
	    (show-paren-mode t)))

;; 80 COLUMNS IS STANDARD
(setq fill-column 80)

;; Yank to where the cursor is
(setq mouse-yank-at-point t)

;; Backup to temp directory
(setq backup-directory-alist
      `((".*" . ,temporary-file-directory)))
(setq auto-save-file-name-transforms
      `((".*" ,temporary-file-directory t)))

;; UTF-8 forever
(prefer-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)

;; Visual aid
(add-hook 'after-init-hook
	  (lambda ()
	    (global-hl-line-mode t)
	    (column-number-mode t)
            (global-linum-mode t)))

;; Spaces are superior, fuck you.
(setq-default indent-tabs-mode nil)

;; Empty startup
(setq inhibit-startup-message t)
(setq initial-scratch-message nil)

;; Show battery if on laptop
(require 'battery)
(when (and battery-status-function
       (not (string-match-p "N/A" 
                (battery-format "%B"
                        (funcall battery-status-function)))))
  (display-battery-mode 1))

(provide 'init-defaults)
