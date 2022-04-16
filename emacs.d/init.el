(setq gnutls-algorithm-priority "NORMAL:-VERS-TLS1.3")

;;; === detect OS ===
(defun windowsp ()
  (eq system-type 'windows-nt))
(defun mac-os-p ()
  (eq system-type 'darwin))
(defun linuxp ()
  (eq system-type 'gnu/linux))

;; === package.el ===
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

(defun package-install-with-refresh (package)
  (unless (assq package package-alist)
    (package-refresh-contents))
  (unless (package-installed-p package)
    (package-install package)))

;; === install use-package and package-utils ===
(or (require 'use-package nil t)
    (progn
      (package-install-with-refresh 'use-package)
      (require 'use-package)))

(use-package package-utils
  :ensure t)

;; === general settings ===
(setq eval-expression-print-level nil)
(setq max-lisp-eval-depth 10000)
(setq gc-cons-threshold (* 10 gc-cons-threshold))
;; (setq garbage-collection-messages t)
(setq split-width-threshold 90)
(setq create-lockfiles nil)

(set-language-environment 'utf-8)
(prefer-coding-system 'utf-8)

(setq inhibit-startup-message t)
(setq initial-scratch-message "")
(setq initial-major-mode 'text-mode)

;; (setq use-dialog-box nil)
;; (defalias 'message-box 'message)

(setq echo-keystrokes 0.1)

(setq-default x-select-enable-clipboard t)
(when (mac-os-p)
  (defun copy-from-osx ()
    (shell-command-to-string "reattach-to-user-namespace pbpaste"))
  (defun paste-to-osx (text &optional push)
    (let ((process-connection-type nil))
      (let ((proc (start-process "pbcopy" "*Messages*" "reattach-to-user-namespace" "pbcopy")))
        (process-send-string proc text)
        (process-send-eof proc))))
  (setq interprogram-paste-function 'copy-from-osx)
  (setq interprogram-cut-function 'paste-to-osx))
(when (and (not window-system) (linuxp))
  (when (getenv "DISPLAY")
    (defun xclip-cut-function (text &optional push)
      (with-temp-buffer
        (insert text)
        (call-process-region (point-min) (point-max) "xclip" nil 0 nil "-i" "-selection" "clipboard")))
    (defun xclip-paste-function()
      (let ((xclip-output (shell-command-to-string "xclip -o -selection clipboard")))
        (unless (string= (car kill-ring) xclip-output)
          xclip-output )))
    (setq interprogram-cut-function 'xclip-cut-function)
    (setq interprogram-paste-function 'xclip-paste-function))
  (require 'mouse)
  (xterm-mouse-mode t))

(defun mouse-scroll-down ()
  (interactive)
  (scroll-down 1))
(defun mouse-scroll-up ()
  (interactive)
  (scroll-up 1))
(global-set-key [mouse-4] 'mouse-scroll-down)
(global-set-key [mouse-5] 'mouse-scroll-up)
(setq scroll-step 1)

(defalias 'yes-or-no-p 'y-or-n-p)

(setq ring-bell-function 'ignore)

(setq make-backup-files t)
(setq backup-directory-alist '((".*" . "~/.emacs.d/backup")))
(setq auto-save-default t)

(display-time)

(when (file-exists-p (expand-file-name "~/.emacs.d/shellenv.el"))
  (load-file (expand-file-name "~/.emacs.d/shellenv.el"))
  (dolist (path (reverse (split-string (getenv "PATH") ":")))
    (add-to-list 'exec-path path)))

(when (file-directory-p (expand-file-name "~/.emacs.d/site-lisp"))
 (let ((default-directory (expand-file-name "~/.emacs.d/site-lisp")))
  (add-to-list 'load-path default-directory)
  (if (fboundp 'normal-top-level-add-subdirs-to-load-path)
      (normal-top-level-add-subdirs-to-load-path))))

(set-face-attribute 'default nil :family "Source Code Pro" :height 160)

(defun font-big ()
  (interactive)
  (set-face-attribute 'default nil :height
                      (+ (face-attribute 'default :height) 10)))

(defun font-small ()
  (interactive)
  (set-face-attribute 'default nil :height
                      (- (face-attribute 'default :height) 10)))

(global-set-key (kbd "C--") 'font-small)
(global-set-key (kbd "C-+") 'font-big)

(define-prefix-command 'windmove-map)
(global-set-key (kbd "C-w") 'windmove-map)
(define-key windmove-map "h" 'windmove-left)
(define-key windmove-map "j" 'windmove-down)
(define-key windmove-map "k" 'windmove-up)
(define-key windmove-map "l" 'windmove-right)
(define-key windmove-map "0" 'delete-window)
(define-key windmove-map "1" 'delete-other-windows)
(define-key windmove-map "2" 'split-window-vertically)
(define-key windmove-map "3" 'split-window-horizontally)
(defun split-window-conditional ()
  (interactive)
  (if (> (* (window-height) 2) (window-width))
      (split-window-vertically)
    (split-window-horizontally)))
(define-key windmove-map "s" 'split-window-conditional)

(setq electric-indent-mode nil)
(setq-default tab-width 4)
(setq default-tab-width 4)

(show-paren-mode t)

(column-number-mode 1)

(global-linum-mode 1)
(setq linum-delay t)
(defadvice linum-schedule (around my-linum-schedule () activate)
  (run-with-idle-timer 0.2 nil #'linum-update-current))
(setq linum-format "%4d ")

(setq eol-mnemonic-dos "(CRLF)"
      eol-mnemonic-mac "(CR)"
      eol-mnemonic-unix "(LF)")

(use-package exec-path-from-shell
  :ensure t
  :config
  (exec-path-from-shell-initialize))

(use-package railscasts-theme
  :ensure t
  :init
  (load-theme 'railscasts t nil)
  (setq frame-background-mode 'dark))

(use-package paren-face
  :ensure t
  :init
  (add-hook 'after-init-hook 'global-paren-face-mode))

(save-place-mode 1)

(use-package flycheck
  :ensure t
  :init
  (use-package flycheck-popup-tip
    :ensure t)
  (setq-default flycheck-disabled-checkers '(emacs-lisp-checkdoc))
  (add-hook 'flycheck-mode-hook 'flycheck-popup-tip-mode)
  )

(use-package yasnippet
  :ensure t
  :config
  (use-package yasnippet-snippets :ensure t)
  (yas-global-mode 1))

(use-package company
  :ensure t
  :bind (:map company-active-map
         ("C-n" . company-select-next)
         ("C-p" . company-select-previous)
         ("C-i" . company-complete-selection)
         :map company-search-map
         ("C-n" . company-select-next)
         ("C-p" . company-select-previous))
  :init
  (add-hook 'after-init-hook 'global-company-mode)
  (setq-default company-idle-delay 0.1
                company-minimum-prefix-length 2
                company-selection-wrap-around t)
  (setq company-dabbrev-downcase nil)
  :config
  ;; (add-to-list 'company-backends '(company-capf company-yasnippet company-dabbrev))
  (add-to-list 'company-backends 'company-yasnippet)
  (set-face-attribute 'company-tooltip nil
                      :foreground "black" :background "lightgrey")
  (set-face-attribute 'company-tooltip-common nil
                      :foreground "black" :background "lightgrey")
  (set-face-attribute 'company-tooltip-common-selection nil
                      :foreground "white" :background "steelblue")
  (set-face-attribute 'company-tooltip-selection nil
                      :foreground "black" :background "steelblue")
  (set-face-attribute 'company-preview-common nil
                      :background nil :foreground "lightgrey" :underline t)
  (set-face-attribute 'company-scrollbar-fg nil
                      :background "orange")
  (set-face-attribute 'company-scrollbar-bg nil
                      :background "gray40")
  )

(use-package evil
  :ensure t
  :init
  (add-hook 'after-init-hook 'evil-mode)

  :config
  (setcdr evil-insert-state-map nil)
  (define-key evil-insert-state-map [escape] 'evil-normal-state)
  (define-key help-mode-map (kbd "i") 'evil-emacs-state)
  (define-key evil-emacs-state-map (kbd "C-j") 'evil-normal-state)
  (define-key evil-normal-state-map (kbd "j") 'evil-next-visual-line)
  (define-key evil-normal-state-map (kbd "k") 'evil-previous-visual-line)
  (setq evil-esc-delay 0)

  ;; leader key
  (defvar leader-key-map (make-sparse-keymap)
    "Keymap for \"leader key\" shortcuts.")

  (define-key evil-normal-state-map "," leader-key-map)
  (define-key leader-key-map "b" 'list-buffers)

  (use-package evil-surround
    :ensure t
    :init
    (global-evil-surround-mode t)))

(use-package ido
  :init
  (add-hook 'after-init-hook 'ido-mode)
  (setq ido-vertical-define-keys 'C-n-C-p-up-down-left-right)
  (setq ido-enable-flex-matching t) ;; 中間/あいまい一致
  :config
  (ido-everywhere 1)
  (use-package ido-vertical-mode
    :ensure t
    :config
    (ido-vertical-mode 1)
    (setq ido-vertical-define-keys 'C-n-and-C-p-only)    ;; C-n/C-pで候補選択する
    (setq ido-vertical-show-count t)))

(use-package smex
  :ensure t
  :init
  (global-set-key (kbd "M-x") 'smex)
  (global-set-key (kbd "M-X") 'smex-major-mode-commands))

(use-package popwin
  :ensure t
  :init
  (add-hook 'after-init-hook 'popwin-mode)
  :config
  (setq popwin:close-popup-window-timer-interval 0.5)
  (setq popwin:special-display-config
        (append popwin:special-display-config
                '((dired-mode :position top)
                  ("*Shell Command Output*")
                  (compilation-mode :noselect t)
                  ("*slime-apropos*")
                  ("*slime-macroexpansion*")
                  ("*slime-description*")
                  ("*slime-compilation*" :noselect t)
                  ("*slime-xref*")
                  ("*cider-error*")
                  ;; ("*GHC Error*")
                  (slime-connection-list-mode)
                  (slime-repl-mode)
                  (sldb-mode :height 20 :stick t)
                  ))))

(use-package smartparens
  :ensure t
  :init
  (add-hook 'after-init-hook 'turn-on-smartparens-mode)
  (define-key smartparens-mode-map (kbd "C-M-f") 'sp-forward-sexp)
  (define-key smartparens-mode-map (kbd "C-M-b") 'sp-backward-sexp)

  (define-key smartparens-mode-map (kbd "C-M-d") 'sp-down-sexp)
  (define-key smartparens-mode-map (kbd "C-M-a") 'sp-backward-down-sexp)
  (define-key smartparens-mode-map (kbd "C-S-d") 'sp-beginning-of-sexp)
  (define-key smartparens-mode-map (kbd "C-S-a") 'sp-end-of-sexp)

  (define-key smartparens-mode-map (kbd "C-M-e") 'sp-up-sexp)
  (define-key smartparens-mode-map (kbd "C-M-u") 'sp-backward-up-sexp)
  (define-key smartparens-mode-map (kbd "C-M-t") 'sp-transpose-sexp)

  (define-key smartparens-mode-map (kbd "C-M-n") 'sp-next-sexp)
  (define-key smartparens-mode-map (kbd "C-M-p") 'sp-previous-sexp)

  (define-key smartparens-mode-map (kbd "C-M-k") 'sp-kill-sexp)
  (define-key smartparens-mode-map (kbd "C-M-w") 'sp-copy-sexp)

  (define-key smartparens-mode-map (kbd "M-<delete>") 'sp-unwrap-sexp)
  (define-key smartparens-mode-map (kbd "M-<backspace>") 'sp-backward-unwrap-sexp)

  (define-key smartparens-mode-map (kbd "C-<right>") 'sp-forward-slurp-sexp)
  (define-key smartparens-mode-map (kbd "C-<left>") 'sp-forward-barf-sexp)
  (define-key smartparens-mode-map (kbd "C-M-<left>") 'sp-backward-slurp-sexp)
  (define-key smartparens-mode-map (kbd "C-M-<right>") 'sp-backward-barf-sexp)

  (define-key smartparens-mode-map (kbd "M-D") 'sp-splice-sexp)
  (define-key smartparens-mode-map (kbd "C-M-<delete>") 'sp-splice-sexp-killing-forward)
  (define-key smartparens-mode-map (kbd "C-M-<backspace>") 'sp-splice-sexp-killing-backward)
  (define-key smartparens-mode-map (kbd "C-S-<backspace>") 'sp-splice-sexp-killing-around)

  (define-key smartparens-mode-map (kbd "C-]") 'sp-select-next-thing-exchange)
  (define-key smartparens-mode-map (kbd "C-<left_bracket>") 'sp-select-previous-thing)
  (define-key smartparens-mode-map (kbd "C-M-]") 'sp-select-next-thing)

  (define-key smartparens-mode-map (kbd "M-F") 'sp-forward-symbol)
  (define-key smartparens-mode-map (kbd "M-B") 'sp-backward-symbol)

  (smartparens-global-mode t))

;; === C ===
(use-package cc-mode
  :ensure t
  :init
  (add-hook 'c-mode-common-hook
            (lambda ()
              (turn-on-smartparens-mode)
              (electric-indent-mode 1)
              (company-mode 1)
              (setq c-default-style "k&r")
              (setq indent-tabs-mode nil)
              (setq c-basic-offset 2)))

  (add-hook 'c-mode-hook 'flycheck-mode)
  (add-hook 'c++-mode-hook 'flycheck-mode)

  (add-hook 'c-mode-hook
            (lambda()
               (setq-default sp-escape-quotes-after-insert nil)))
  (add-hook 'c++-mode-hook
			(lambda ()
			  (setq flycheck-clang-language-standard "c++17")
			  (setq flycheck-gcc-language-standard "c++17")))
  :config
  (sp-with-modes '(c-mode malabar-mode c++-mode)
    (sp-local-pair "{" nil :post-handlers '(("||\n[i]" "RET")))
    (sp-local-pair "/*" "*/" :post-handlers '((" | " "SPC")
                                              ("* ||\n[i]" "RET"))))
  ;; (use-package irony
  ;;   :ensure t
  ;;   :init
  ;;   (add-hook 'irony-mode-hook 'irony-cdb-autosetup-compile-options)
  ;;   (add-hook 'c++-mode-hook 'irony-mode)
  ;;   (add-hook 'c-mode-hook 'irony-mode)
  ;;   (add-hook 'objc-mode-hook 'irony-mode)
  ;;   (add-hook 'irony-mode-hook #'irony-eldoc)
  ;;   :config
  ;;   (use-package flycheck-irony
  ;;     :ensure t
  ;;     :config
  ;;     (flycheck-irony-setup))
  ;;   (use-package company-irony
  ;;     :ensure t
  ;;     :config
  ;;     (add-to-list 'company-backends 'company-irony))
  ;;   (use-package irony-eldoc
  ;;     :ensure t))
  )

;; === LSP ===
(use-package eglot
  :ensure t)

(use-package lsp-mode
  :ensure t
  :commands lsp
  :config
  (setq lsp-prefer-flymake nil))

; (use-package company-lsp
;   :ensure t
;   :commands company-lsp)

;; === Haskell ===
(use-package lsp-haskell
  :ensure t
  :config
  (setq lsp-haskell-process-path-hie "hie-wrapper")
  ;; (setq lsp-haskell-process-path-hie "ghcide")
  (setq lsp-haskell-process-args-hie '())
  ;; (lsp-haskell-set-completion-snippets :json-false)
  )

(use-package haskell-mode
  :ensure t
  :init
  (use-package flycheck-haskell :ensure t)
  (add-hook 'haskell-mode-hook #'lsp)
  (add-hook 'haskell-mode-hook #'flycheck-mode)
  (add-hook 'haskell-mode-hook #'flycheck-haskell-setup)
  (add-hook 'haskell-mode-hook 'interactive-haskell-mode)
  (add-hook 'haskell-mode-hook (lambda ()  (setq tab-width 2)))
  :config
  (setq flymake-allowed-file-name-masks (delete '("\\.l?hs\\'" haskell-flymake-init) flymake-allowed-file-name-masks))
  (flycheck-add-next-checker 'haskell-stack-ghc '(warning . haskell-hlint))
  (flycheck-add-next-checker 'haskell-ghc '(warning . haskell-hlint)))

;; (use-package haskell-mode
;;   :init
;;   (use-package flycheck-haskell :ensure t)
;;   (add-hook 'haskell-mode-hook 'flycheck-mode)
;;   (add-hook 'haskell-mode-hook 'company-mode)
;;   :config
;;   (use-package intero
;;     :ensure t
;;     :config
;;     (flycheck-add-next-checker 'intero '(warning . haskell-hlint))
;;     (flycheck-add-next-checker 'haskell-stack-ghc '(warning . haskell-hlint))
;;     (intero-global-mode 1)))

;; === Markdown ===
(use-package markdown-mode
  :ensure t
  :mode "\\.md\\'")

;; === TOML ===
(use-package toml-mode
  :ensure t)

;; === Rust ===
(use-package rust-mode
  :ensure t
  :init
  (add-hook 'rust-mode-hook #'racer-mode)
  (add-hook 'racer-mode-hook #'eldoc-mode)
  :config
  (use-package racer :ensure t))

;; === Go ===
(use-package go-mode
  :ensure t
  :config
  (add-hook 'go-mode-hook 'eglot-ensure))

;; === YAML ===
(use-package yaml-mode
  :ensure t)

;; === SML ===
(use-package sml-mode
  :ensure t)

;; wakatime
;; (use-package wakatime-mode
;;   :ensure t
;;   :init
;;   (setq wakatime-api-key "0310995b-8f6c-43f8-959c-4d935e22b4f4")
;;   :config
;;   (global-wakatime-mode))

(setq custom-file "~/.emacs.d/custom_setttings.el")
(load custom-file t)

;; satysfi
(require 'satysfi)
(add-to-list 'auto-mode-alist '("\\.saty$" . satysfi-mode))
(add-to-list 'auto-mode-alist '("\\.satyh$" . satysfi-mode))
(setq satysfi-command "satysfi")
  ; set the command for typesetting (default: "satysfi -b")
(setq satysfi-pdf-viewer-command "open")
  ; set the command for opening PDF files (default: "open")

;; zig
(use-package zig-mode
  :ensure t
  :mode (("\\.zig\\'" . zig-mode)))

;; (load-file (let ((coding-system-for-read 'utf-8))
;;                 (shell-command-to-string "agda-mode locate")))

;; Common lisp
(load (expand-file-name "~/.roswell/helper.el"))

(setq inferior-lisp-program "ros -Q run")

;; Local Variables:
;; byte-compile-warnings: (not cl-functions obsolete)
;; End:
