;; turn off emacs startup message
(setq inhibit-startup-message t)

(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(clojure-mode-use-backtracking-indent t)
 '(menu-bar-mode nil)
 '(tool-bar-mode nil))
;(custom-set-variables '(tabbar-separator  '(0)))
;(custom-set-variables '(tabbar-use-images nil))

;; load color-theme
(add-to-list 'load-path "~/.emacs.d/color-theme")

;; use wombat
(load-file "~/.emacs.d/color-theme/themes/wombat.el")
(color-theme-wombat)

;; uncomment to not wrap lines
(setq-default truncate-lines t)

;; tab width as two, using spaces
(setq default-tab-width 2)
(setq-default indent-tabs-mode nil)

;;in your buffer, you can override with
;; M-: (setq tab-width 8)

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

;; C-f7 and f7: store your window configuration in register "a" and quickly get back to it
;; http://www.emacswiki.org/emacs/DedicatedKeys

(global-set-key (kbd "C-<f7>") 'window-configuration-to-register)
(global-set-key [f7] 'jump-to-register)
;; (global-set-key (kbd "C-<f7>") '(lambda ()
;;                                  (interactive)
;;                                  (window-configuration-to-register ?a)
;;                                  (message "Stored window config to 'a'...")))
;; (global-set-key [f7] '(lambda () (interactive) (jump-to-register ?a)))

(global-set-key (kbd "C-<XF86Launch7>") '(lambda ()
                                  (interactive)
                                  (window-configuration-to-register ?3)
                                  (message "Stored window config to '3'...")))
(global-set-key [(XF86Launch7)] '(lambda () (interactive) (jump-to-register ?3)))
(global-set-key (kbd "C-<XF86Launch8>") '(lambda ()
                                  (interactive)
                                  (window-configuration-to-register ?4)
                                  (message "Stored window config to '4'...")))
(global-set-key [(XF86Launch8)] '(lambda () (interactive) (jump-to-register ?4)))
(global-set-key (kbd "C-<XF86Launch9>") '(lambda ()
                                  (interactive)
                                  (window-configuration-to-register ?5)
                                  (message "Stored window config to '5'...")))
(global-set-key [(XF86Launch9)] '(lambda () (interactive) (jump-to-register ?5)))


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
;;(global-set-key (kbd "<C-return>") 'apply-macro-to-region-lines)

(global-set-key [f9] 'delete-indentation)


(add-hook 'before-save-hook 'delete-trailing-whitespace)

;;tabbar settings
(require 'tabbar)
;; my Ubuntu ain't got a Monaco font
(set-face-attribute 'tabbar-default    nil :background wombat-gray-1)
(set-face-attribute 'tabbar-unselected nil :foreground wombat-bg :box nil)
(set-face-attribute 'tabbar-selected   nil :background wombat-bg :foreground wombat-gray-1 :box nil)
(set-face-attribute 'tabbar-highlight  nil :underline t)

(tabbar-mode -1)
;(global-set-key [C-XF86Forward] 'tabbar-forward-tab)
;(global-set-key [C-XF86Back] 'tabbar-backward-tab)
;(global-set-key [M-XF86Forward] 'tabbar-forward-group)
;(global-set-key [M-XF86Back] 'tabbar-backward-group)
(global-set-key [C-XF86Forward] 'forward-sexp)
(global-set-key [C-XF86Back] 'backward-sexp)

;; swap the two kills:
;; (global-set-key (kbd "C-M-k") 'paredit-kill)
;; (global-set-key (kbd "C-k") 'kill-sexp)

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

(eval-after-load 'slime-mode
  '(progn (define-key slime-mode-map (kbd "<C-return>") 'slime-eval-defun)))

(eval-after-load 'clojure-mode
  '(progn (define-key clojure-mode-map (kbd "<C-return>") 'slime-eval-defun)))


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

(defun save-compile-and-load-file ()
  (interactive)
  (save-buffer)
  (slime-compile-and-load-file)
  (slime-repl)
  (goto-char (point-max))
  (slime-repl-previous-input))
(add-hook 'slime-mode-hook
          '(lambda ()
             (define-key slime-mode-map (kbd "C-c C-k") 'save-compile-and-load-file)))
;; make ";" be jus a semicolon, not paredit-semicolon
(add-hook 'paredit-mode-hook
          '(lambda ()
             (define-key paredit-mode-map (kbd ";") 'self-insert-command)))

(global-set-key (kbd "C-<f12>") '(lambda () (interactive) (bookmark-set "a")))
(global-set-key (kbd "<f12>") '(lambda () (interactive) (bookmark-jump "a")))
(global-set-key (kbd "M-<f12>") 'bookmark-set)
(global-set-key (kbd "M-S-<f12>") 'bookmark-jump)

(global-set-key (kbd "<Scroll_Lock>") '(lambda () (interactive) (find-file "~/.emacs.d/init.el")))
(global-set-key (kbd "C-<Scroll_Lock>") '(lambda () (interactive) (load-file (buffer-file-name))))

(global-set-key (kbd "C-<tab>") 'other-window)
(global-set-key (kbd "C-S-<iso-lefttab>") '(lambda () (interactive) (other-window -1)))
;; open buffers in another window
;; http://www.fnal.gov/docs/products/emacs/emacs/emacs_20.html#SEC156

(setq eshell-cmpl-cycle-completions t)

(defun display-repl ()
  (interactive)
  (display-buffer (slime-repl)
                  (slime-eval-defun)))

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

;; https://github.com/nonsequitur/smex/
;; smex: ido for M-x
(require 'smex)
(smex-initialize)
(global-set-key (kbd "M-x") 'smex)
(global-set-key (kbd "M-X") 'smex-major-mode-commands)
;; This is your old M-x.
(global-set-key (kbd "C-c C-c M-x") 'execute-extended-command)


;; NAVIGATION

;; window mgmt
;; config undoing/redoing window changes
;;; http://emacs.wordpress.com/2007/01/28/simple-window-configuration-management/
;; flip between windo confix, undo/redo style
(when (fboundp 'winner-mode)
      (winner-mode 1)
      (global-set-key [(XF86Back)] 'winner-undo)
      (global-set-key [(XF86Forward)] 'winner-redo)
      (global-set-key [(XF86Launch5)] 'winner-undo)
      (global-set-key [(XF86Launch6)] 'winner-redo))


;; emacs tab management
;; http://www.emacswiki.org/emacs/TabBarMode



;; help with keys
;; http://www.cliki.net/Editing%20Lisp%20Code%20with%20Emacs
;; http://www.emacswiki.org/emacs/OneTwoThreeMenu
;; http://www.emacswiki.org/cgi-bin/emacs/OneKey

;; imenu

;; org mode for tables and such, folding

;; http://emacs.wordpress.com/2007/07/15/quick-keybindings/

(require 'smooth-scrolling)

;; http://www.emacswiki.org/emacs/HippieExpand
;; (global-set-key "\M- " 'hippie-expand)

;; MISC
;; installed find-file in project
;; http://www.masteringemacs.org/articles/2010/12/13/complete-guide-mastering-eshell/

;; http://emacs-fu.blogspot.com/
;; eg http://emacs-fu.blogspot.com/2010/11/undo.html -- undo tree sounds  cool
;; http://www.prodevtips.com/2010/09/24/emacs-key-bindings-paredit-and-saving-macros/
(global-set-key [f1] 'menu-bar-mode)

(global-set-key (kbd "C-;") 'paredit-open-parenthesis)

;; keys:
;; http://www.math.uh.edu/~bgb/emacs_keys.html
;; http://www.gnu.org/software/emacs/manual/html_node/emacs/Marking-Objects.html

(setq browse-url-browser-function 'browse-url-generic
      browse-url-generic-program "google-chrome")

(global-set-key [(XF86Mail)] 'browse-url)

;; good tutorial: C-u C-SPC prev mark
;; http://web.psung.name/emacs/2009/part1.html