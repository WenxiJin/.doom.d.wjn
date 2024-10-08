;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Wenxi Jin"
      user-mail-address "wjn@sophion.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
;; (setq doom-font (font-spec :family "monospace" :size 12 :weight 'semi-light)
;;       doom-variable-pitch-font (font-spec :family "sans" :size 13))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-gruvbox)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)


;; Here are some additional functions/macros that could help you configure Doom:
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
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.


(map! "C-c j" #'avy-goto-char-2)

(use-package! nyan-mode
  :init
  (nyan-mode 1)
  :config
  (setq nyan-animate-nyancat t))


 (c-add-style "microsoft"
              '("stroustrup"
                (c-offsets-alist
                 (innamespace . -)
                 (inline-open . 0)
                 (inher-cont . c-lineup-multi-inher)
                 (arglist-cont-nonempty . +)
                 (template-args-cont . +))))
 (setq c-default-style "microsoft")

;; c/c++, java
;; NOTE: Mine first, google-c-style after
(defun my-c-mode-hook ()
  (c-set-offset 'innamespace [2])
  (c-set-offset 'access-label '-)
  (c-set-offset 'arglist-cont-nonempty '+)
  (setq c-basic-offset 2
        tab-width 2)
  ;; (whitespace-mode 1)
  (setq whitespace-style
                (quote (face trailing tab tab-mark lines-tail)))
  (setq spacemacs-show-trailing-whitespace nil)
  )

(add-hook 'c-mode-common-hook 'my-c-mode-hook)

(use-package! google-c-style
  :config
  (add-hook 'c-mode-common-hook 'google-set-c-style)
  (add-hook 'c-mode-common-hook 'google-make-newline-indent)
  )

;; (after! cc-mode
;;   (set-company-backend! 'c++-mode '(:separate company-dabbrev-code
;;                                     company-gtags
;;                                     company-dabbrev)))

;; irony
(when (boundp 'w32-pipe-read-delay)
  (setq w32-pipe-read-delay 0))
;; Set the buffer size to 64K on Windows (from the original 4K)
(when (boundp 'w32-pipe-buffer-size)
  (setq irony-server-w32-pipe-buffer-size (* 64 1024)))

;; java
(add-hook 'java-mode-hook
          (lambda ()
            (setq c-basic-offset 4
                  tab-width 4
                  indent-tabs-mode 1
                  fill-column 100)
            (whitespace-mode 0)
            (message "WJN: personal java mode hook applied")
            ))

;; C#
(setq auto-mode-alist (append '(("\\.xaml$" . nxml-mode)) auto-mode-alist))
(setq auto-mode-alist
      (append '(("\\.jobdsl\\'" . groovy-mode)
                ("\\.groovy\\'" . groovy-mode)
                ("\\.jenkinsfile\\'" . groovy-mode))
              auto-mode-alist))

(add-to-list 'projectile-other-file-alist '("xaml.cs" "xaml" "cs"))
(add-to-list 'projectile-other-file-alist '("xaml" "cs" "xaml.cs"))
(add-to-list 'projectile-other-file-alist '("cs" "xaml.cs" "xaml"))
(add-to-list 'projectile-other-file-alist '("cs" "Designer.cs"))
(add-to-list 'projectile-other-file-alist '("Designer.cs" "cs"))


;; Multiple-cursors
(global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)
(global-set-key (kbd "C->") 'mc/mark-next-like-this)
(global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
(global-set-key (kbd "C-c C-<") 'mc/mark-all-like-this)

(add-hook 'lsp-mode-hook
          (lambda()
            (setq lsp-ui-sideline-show-code-actions nil)
            (setq lsp-enable-file-watchers nil)))

(after! undo-tree
  (setq undo-tree-auto-save-history nil))

;; Windows, invokes "start /path/to/file.java"
;; Linux, invokes "xdg-open /path/to/file.java", needs package "libfuse-dev"
;; If not working, try to invoke from cmdline to debug
(after! browse-url
 (unless (version< emacs-version "28.2")
     (add-to-list 'browse-url-handlers '("." . browse-url-default-browser))))

(after! vertico
  (setq consult-line-start-from-top t))
