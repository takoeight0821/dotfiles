(prefer-coding-system 'utf-8)
(setq inhibit-startup-message t)
(setq initial-scratch-message "")
(setq initial-major-mode 'emacs-lisp-mode)

(setq-default tab-width 2
              indent-tabs-mode nil)

(setq use-dialog-box nil)
(defalias 'message-box 'message)

(setq echo-keystrokes 0.1)

(setq x-select-enable-clipboard t)
(when (mac-os-p)
  (defun copy-from-osx ()
    (shell-command-to-string "pbpaste"))
  (defun paste-to-osx (text &optional push)
    (let ((process-connection-type nil))
      (let ((proc (start-process "pbcopy" "*Messages*" "pbcopy")))
	(process-send-string proc text)
	(process-send-eof proc))))
  (setq interprogram-paste-function 'copy-from-osx)
  (setq interprogram-cut-function 'paste-to-osx))

(setq-default require-final-newline nil)
(setq require-final-newline nil)

;; Prevent beeping.
(setq ring-bell-function 'ignore)

(setq make-backup-files nil)
(setq auto-save-default nil)

(require 'saveplace)
(setq-default save-place t)

;;; evil
(need-package 'evil)
(evil-mode t)
(define-key evil-insert-state-map (kbd "C-j") 'evil-normal-state)


;;; helm
(need-package 'helm)
(require 'helm-config)
(helm-mode t)

