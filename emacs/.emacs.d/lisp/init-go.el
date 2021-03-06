;;; init-go.el --- Setup go mode

(use-package go-mode
  :mode "\\.go\\'"
  :init
  (add-hook 'before-save-hook 'gofmt-before-save))

;; Golang's LSP. Using gopls.
(add-hook 'go-mode-hook #'lsp-deferred)

;; Set up before-save hooks to format buffer and add/delete imports.
;; Make sure you don't have other gofmt/goimports hooks enabled.
(defun lsp-go-install-save-hooks ()
  (add-hook 'before-save-hook #'lsp-format-buffer t t)
  (add-hook 'before-save-hook #'lsp-organize-imports t t))
(add-hook 'go-mode-hook #'lsp-go-install-save-hooks)

(add-hook 'go-mode-hook
 (lambda() (setq tab-width 4)))

(provide 'init-go)
