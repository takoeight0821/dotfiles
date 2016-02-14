;;; auto-complete 
(need-package 'auto-complete)
(ac-config-default)

;;; yasnippet
(need-package 'yasnippet)
(require 'yasnippet)
(yas-global-mode t)

;;; flycheck
(need-package 'flycheck)
(global-flycheck-mode)
(with-eval-after-load 'flycheck
  (setq-default flycheck-disabled-checkers '(emacs-lisp-checkdoc)))
