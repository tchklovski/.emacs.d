;; turn off emacs startup message
(setq inhibit-startup-message t)

(custom-set-variables
 '(menu-bar-mode nil)
 '(tool-bar-mode nil))

;; load color-theme
(add-to-list 'load-path "~/.emacs.d/color-theme")
(require 'color-theme)
(color-theme-initialize)
(setq color-theme-is-global t)
;; use wombat
(load-file "~/.emacs.d/color-theme/themes/wombat.el")
(color-theme-wombat)

;; uncomment to not wrap lines
;;(setq-default truncate-lines t)

;; tab width as two, using spaces
(setq default-tab-width 2)
(setq-default indent-tabs-mode nil)

;;; This was installed by package-install.el.
;;; This provides support for the package system and
;;; interfacing with ELPA, the package archive.
;;; Move this code earlier if you want to reference
;;; packages in your .emacs.
(when
    (load
     (expand-file-name "~/.emacs.d/elpa/package.el"))
  (package-initialize))


;; add all subdirs of ~/.emacs.d to your load-path
(dolist (f (file-expand-wildcards "~/.emacs.d/*"))
  (add-to-list 'load-path f))

;; add all subdirs of ~/.emacs.d to your load-path
(dolist (f (file-expand-wildcards "~/.emacs.d/elpa/*"))
  (add-to-list 'load-path f))


;; default frame size
;(add-to-list 'default-frame-alist (cons 'height 24))
;(add-to-list 'default-frame-alist (cons 'width 80))
;(add-to-list 'default-frame-alist '(alpha 85 75))

;; f5
(global-set-key [f5] 'revert-buffer)

;; load clojure mode
(require 'clojure-mode)

;; load slime
;; make sure you do not install Ubuntu installer version of slime
(eval-after-load "slime"
  '(progn (slime-setup '(slime-repl))))
(eval-after-load "slime"
  '(setq slime-protocol-version 'ignore))

(require 'slime)
(require 'slime-repl)

;; load clojure test mode
(autoload 'clojure-test-mode "clojure-test-mode" "Clojure test mode" t)
(autoload 'clojure-test-maybe-enable "clojure-test-mode" "" t)
(add-hook 'clojure-mode-hook 'clojure-test-maybe-enable)

;; load paredit
(require 'paredit)
(add-hook 'clojure-mode-hook          (lambda () (paredit-mode +1)))
(add-hook 'emacs-lisp-mode-hook       (lambda () (paredit-mode +1)))
(add-hook 'lisp-mode-hook             (lambda () (paredit-mode +1)))
(add-hook 'scheme-mode-hook           (lambda () (paredit-mode +1)))
(add-hook 'lisp-interaction-mode-hook (lambda () (paredit-mode -1)))

;; correctly tab defprotocols, etc
(custom-set-variables
 '(clojure-mode-use-backtracking-indent t))

;; rainbow parentheses
(require 'highlight-parentheses)
(add-hook 'clojure-mode-hook '(lambda () (highlight-parentheses-mode 1)))
;(add-hook 'slime-repl-mode-hook '(lambda () (highlight-parentheses-mode 1)))
(setq hl-paren-colors
      '("orange1" "yellow1" "greenyellow" "green1"
	"springgreen1" "cyan1" "slateblue1" "magenta1" "purple"))

;; magic, haven't broken this down yet
(defmacro defclojureface (name color desc &optional others)
  `(defface ,name '((((class color)) (:foreground ,color ,@others))) ,desc :group 'faces))

; Dim parens - http://briancarper.net/blog/emacs-clojure-colors
(defclojureface clojure-parens       "DimGrey"   "Clojure parens")
(defclojureface clojure-braces       "#49b2c7"   "Clojure braces")
(defclojureface clojure-brackets     "SteelBlue" "Clojure brackets")
(defclojureface clojure-keyword      "khaki"     "Clojure keywords")
(defclojureface clojure-namespace    "#c476f1"   "Clojure namespace")
(defclojureface clojure-java-call    "#4bcf68"   "Clojure Java calls")
(defclojureface clojure-special      "#b8bb00"   "Clojure special")
(defclojureface clojure-double-quote "#b8bb00"   "Clojure special" (:background "unspecified"))

(defun tweak-clojure-syntax ()
  (mapcar (lambda (x) (font-lock-add-keywords nil x))
          '((("#?['`]*(\\|)"       . 'clojure-parens))
            (("#?\\^?{\\|}"        . 'clojure-brackets))
            (("\\[\\|\\]"          . 'clojure-braces))
            ((":\\w+"              . 'clojure-keyword))
            (("#?\""               0 'clojure-double-quote prepend))
            (("nil\\|true\\|false\\|%[1-9]?" . 'clojure-special))
            (("(\\(\\.[^ \n)]*\\|[^ \n)]+\\.\\|new\\)\\([ )\n]\\|$\\)" 1 'clojure-java-call)))))

(add-hook 'clojure-mode-hook 'tweak-clojure-syntax)

;;macros
(global-set-key (kbd "C-,")        'kmacro-start-macro-or-insert-counter)
(global-set-key (kbd "C-.")        'kmacro-end-or-call-macro)
(global-set-key (kbd "<C-return>") 'apply-macro-to-region-lines)

(add-hook 'before-save-hook 'delete-trailing-whitespace)

;;tabbar settings
(require 'tabbar)
;; my Ubuntu ain't got a Monaco font
(set-face-attribute 'tabbar-default    nil :background wombat-gray-1)
(set-face-attribute 'tabbar-unselected nil :foreground wombat-bg :box nil)
(set-face-attribute 'tabbar-selected   nil :background wombat-bg :foreground wombat-gray-1 :box nil)
(set-face-attribute 'tabbar-highlight  nil :underline t)

(custom-set-variables '(tabbar-separator  '(0)))
(custom-set-variables '(tabbar-use-images nil))

(tabbar-mode 1)
(global-set-key [C-right] 'tabbar-forward-tab)
(global-set-key [C-left] 'tabbar-backward-tab)
(global-set-key [C-up] 'tabbar-forward-group)
(global-set-key [C-down] 'tabbar-backward-group)

(defadvice tabbar-buffer-tab-label (after tabbar-tab-label activate)
  (setq ad-return-value
        (concat " " (concat (replace-regexp-in-string "<[[:digit:]]+>" "" ad-return-value) " "))))

(defun tabbar-group-buffers-by-dir ()
  (with-current-buffer (current-buffer)
    (let ((dir (expand-file-name default-directory)))
      (cond ((member (buffer-name) '("*Completions*"
                                     "*scratch*"
                                     "*Messages*"
                                     "*Ediff Registry*"))
             (list "#misc"))
            ((string-match-p "/.emacs.d/" dir) (list ".emacs.d"))
            (t (list dir))))))

(setq tabbar-buffer-groups-function 'tabbar-group-buffers-by-dir)

(setq frame-title-format '("%f"))

(eval-after-load 'slime-repl-mode
  '(progn (define-key slime-repl-mode-map (kbd "<C-return>") nil)))


;;processing
(autoload 'processing-mode "processing-mode" "Processing mode" t)
(add-to-list 'auto-mode-alist '("\\.pde$" . processing-mode))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; make emacs use the clipboard
(setq x-select-enable-clipboard t)
(setq interprogram-paste-function 'x-cut-buffer-or-selection-value)

(defun lein-swank ()
  (interactive)
  (let ((root (locate-dominating-file default-directory "project.clj")))
    (when (not root)
      (error "Not in a Leiningen project."))
    ;; you can customize slime-port using .dir-locals.el
    (shell-command (format "cd %s && lein swank %s &" root slime-port)
                   "*lein-swank*")
    (set-process-filter (get-buffer-process "*lein-swank*")
                        (lambda (process output)
                          (when (string-match "Connection opened on" output)
                            (slime-connect "localhost" slime-port)
                            (set-process-filter process nil))))
    (message "Starting swank server...")))

(defun override-slime-repl-bindings-with-paredit ()
  (define-key slime-repl-mode-map
    (read-kbd-macro paredit-backward-delete-key) nil))
(add-hook 'slime-repl-mode-hook 'override-slime-repl-bindings-with-paredit)
(add-hook 'slime-repl-mode-hook 'clojure-mode-font-lock-setup)


(setq eshell-cmpl-cycle-completions t)

;; TODO:
;;   http://eschulte.github.com/emacs-starter-kit/starter-kit-eshell.html
;;   eshell-cmpl-cycle-completions
;; http://www.emacswiki.org/cgi-bin/wiki/minibuffer-complete-cycle.el ido-find-file
;; http://www.masteringemacs.org/articles/2010/12/13/complete-guide-mastering-eshell/
;; lambda to char -- from starter kit?


;; enable awesome file prompting
(when (> emacs-major-version 21)
  (ido-mode t)
  (setq ido-enable-prefix nil
        ido-enable-flex-matching t
        ido-create-new-buffer 'always
        ido-use-filename-at-point t
        ido-max-prospects 10))

;; display pretty lambdas
(font-lock-add-keywords 'emacs-lisp-mode
    '(("(\\(lambda\\)\\>" (0 (prog1 ()
                               (compose-region (match-beginning 1)
                                               (match-end 1)
                                               ?λ))))))

;; loaded emacs-goodies-el that has bar cursor etc

;; turn off scroll-bars
(scroll-bar-mode -1)

;; alt -~ enters this, i think
;;(global-set-key [(f8)] 'slime-selector)

;;; http://dryice.name/blog/emacs/eshell/
(require 'esh-mode)

;;; http://emacs.wordpress.com/2007/01/28/simple-window-configuration-management/
;; flip between windo confix, undo/redo style
(winner-mode 1)

;; https://github.com/nonsequitur/smex/
;; smex: ido for M-x
(require 'smex)
(smex-initialize)
(global-set-key (kbd "M-x") 'smex)
(global-set-key (kbd "M-X") 'smex-major-mode-commands)
;; This is your old M-x.
(global-set-key (kbd "C-c C-c M-x") 'execute-extended-command)

;; imenu
;; org mode for tables and such, folding

;; http://emacs.wordpress.com/2007/07/15/quick-keybindings/

;; (require 'smooth-scrolling)
;; emacs tab management?? (how to make good tab groups, view all tree)

;; installed find-file in project

