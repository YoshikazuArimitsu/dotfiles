;;-------------------------------------------------------------------------------------
; 共通
; M-g     行移動
; C-h     バックスペース
; C-c ;   範囲コメントアウト
; C-c :   範囲コメントアウト解除
; C-{     対応するカッコに移動(前)
; C-}     対応するカッコに移動(後)
; C-tab   次のタブに移動
; S-tab   前のタブに移動
; C-RET   矩形選択モード
; C-c f   find-grep モード
;
; folding
; C-c h   現在位置のソース折り畳みトグル
; C-c x   ソース折り畳み(ALL)
; C-c s   ソース折り畳み解除(ALL)
;
; GTAGS
; M-t     タグ検索
; M-r     タグ検索(back)
; M-s     シンボル検索
; C-t     戻る
;
; C/C++
; C-c c   コンパイル
; C-c r   再コンパイル
; C-c g   gdb起動
;
; JSON
; C-c r   フォーマット
;
; flymake
; M-n     次のエラー行にジャンプ
; M-p     前のエラー行にジャンプ
;
; Haskell
; C-c C-l ghci起動
;
; nav
; C-x C-d ディレクトリツリーモード起動
;
; SVN
; C-x v d ディレクトリモードに入る
; C-x v l ログ表示(log)
; C-x v v コミット
; C-x v u 戻す(revert)

;;-------------------------------------------------------------------------------------
;; 共通

; フォント(Ricty)
(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(cua-mode t nil (cua-base))
 '(show-paren-mode t)
 '(tool-bar-mode nil))
(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :stipple nil :background "white" :foreground "black" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 98 :width normal :foundry "unknown" :family "Ricty")))))

; パス
(setq load-path (cons "~/.emacs.d" load-path))

; UTF-8を優先させるおまじない
(set-language-environment "Japanese")
(prefer-coding-system 'utf-8)
(set-file-name-coding-system 'utf-8)

; 基本キーバインド
(global-set-key "\M-g" 'goto-line)
(global-set-key "\C-h" 'delete-backward-char)
(global-set-key "\C-c;" 'comment-region)
(global-set-key "\C-c:" 'uncomment-region)

; 起動時メッセージを消す
(setq inhibit-startup-message t)

; バックアップファイル作成しない
(setq make-backup-files nil)

; 変更のあったファイルを自動的に再読込
(global-auto-revert-mode t)

; ツールバー無し
(tool-bar-mode -1)

; 対応する括弧を光らせるモード
(show-paren-mode 1)

; 現在行をハイライト
(defface hlline-face
  '((((class color)
      (background dark))
     (:background "dark slate gray"))
    (((class color)
      (background light))
     (:background "LightBlue1"))
    (t
     ()))
  "*Face used by hl-line.")
(setq hl-line-face 'hlline-face)
(global-hl-line-mode)

; タイトルにパス表示
(setq frame-title-format
    (format "%%f - Emacs@%s" (system-name)))

; モードラインに編集中関数名を表示
(which-function-mode 1)

;; 改行コードを表示
(setq eol-mnemonic-dos "(CRLF)")
(setq eol-mnemonic-mac "(CR)")
(setq eol-mnemonic-unix "(LF)")

;; C-x bでミニバッファにバッファ候補を表示
(iswitchb-mode t)
(iswitchb-default-keybindings)

; C-RETで矩形選択開始
(cua-mode t)
(setq cua-enable-cua-keys nil) ;; 変なキーバインド禁止

; 起動時サイズ指定
(setq initial-frame-alist
      (append (list
      '(width . 100)
      '(height . 48)
      '(top . 32)
      '(left . 0)
      )
     initial-frame-alist))

; カット/コピー時にクリップボードにもデータをコピーする
(global-set-key "\M-w" 'clipboard-kill-ring-save)  ; クリップボードにコピー
(global-set-key "\C-w" 'clipboard-kill-region)     ; 切り取ってクリップボードへ

;;-------------------------------------------------------------------------------------
;; シェル関連
; find-grep
(define-key
  global-map
  (kbd "C-c f") 'find-grep)

; find-grep時のコマンド(.svn除外)
(setq grep-find-command 
      "find . -type f '!' -wholename '*/.svn/*' -print0 | xargs -0 -e grep -nH -e ")

; shell-modeでpasswordを隠す
(add-hook 'comint-output-filter-functions 'comint-watch-for-password-prompt)

; #! から始まるファイルを保存すると実行権限を付与するフック
(add-hook 'after-save-hook 'my-chmod-script)
(defun my-chmod-script() (interactive) (save-restriction (widen)
							 (let ((name (buffer-file-name)))
							   (if (and (not (string-match ":" name))
								    (not (string-match "/\\.[^/]+$" name))
								    (equal "#!" (buffer-substring 1 (min 3 (point-max)))))
							       (progn (set-file-modes name (logior (file-modes name) 73))
								      (message "Wrote %s (chmod +x)" name)
								      ))
							   )))

;;-------------------------------------------------------------------------------------
;; ibus.el
(require 'ibus)
(add-hook 'after-init-hook 'ibus-mode-on)

; Ctrl+space は無効にする
(ibus-define-common-key ?\C-\s nil)
; ON/OFFでカーソル色を変える
(setq ibus-cursor-color "limegreen")

;;-------------------------------------------------------------------------------------
;; mozc (ibus動作しない環境用)
(require 'mozc)
;(set-language-environment "Japanese")
(setq default-input-method "japanese-mozc")
(setq mozc-candidate-style 'overlay)

; 全角/半角キーでの切り替え対応
(global-set-key (kbd "<zenkaku-hankaku>") 'toggle-input-method)
(add-hook 'mozc-mode-hook
  (lambda()
    (define-key mozc-mode-map (kbd "<zenkaku-hankaku>") 'toggle-input-method)))

(add-hook 'input-method-activate-hook
          (lambda ()
	    (set-cursor-color "limegreen")
	    ))
(add-hook 'input-method-inactivate-hook
          (lambda () 
	    (set-cursor-color "black")
	    ))

;;-------------------------------------------------------------------------------------
;; diffモードのカラーリング
(defun diff-mode-setup-faces ()
  ;; 追加された行は緑で表示
  (set-face-attribute 'diff-added nil
                      :foreground "white" :background "dark green")
  ;; 削除された行は赤で表示
  (set-face-attribute 'diff-removed nil
                      :foreground "white" :background "dark red")
  ;; 文字単位での変更箇所は色を反転して強調
  (set-face-attribute 'diff-refine-change nil
                      :foreground nil :background nil
                      :weight 'bold :inverse-video t))
(add-hook 'diff-mode-hook 'diff-mode-setup-faces)


;;-------------------------------------------------------------------------------------
; 行番号表示
(require 'wb-line-number)
(setq truncate-partial-width-windows nil)
(set-scroll-bar-mode nil)
(setq wb-line-number-scroll-bar t)
(wb-line-number-toggle)

;;-------------------------------------------------------------------------------------
;; オートコンプリート(ac-dict)
(setq ac-dir ".emacs.d/")
(require 'auto-complete)
(require 'auto-complete-config)
(add-to-list 'ac-dictionary-directories (concat ac-dir "ac-dict/" ))
(global-auto-complete-mode t)

;;-------------------------------------------------------------------------------------
;; タグ(gtags)モード設定
(autoload 'gtags-mode "gtags" "" t)
(setq gtags-mode-hook
      '(lambda ()
         (local-set-key "\M-t" 'gtags-find-tag)
         (local-set-key "\M-r" 'gtags-find-rtag)
         (local-set-key "\M-s" 'gtags-find-symbol)
         (local-set-key "\C-t" 'gtags-pop-stack)
         ))

;;-------------------------------------------------------------------------------------
;; C/C++言語用設定
(defun my-c-mode-hook ()
  (c-set-style "linux")
  (setq tab-width 4)
  (setq c-basic-offset tab-width)
  (cpp-highlight-buffer t)

  ; gtags ONなー
  (gtags-mode 1)
  (gtags-make-complete-list)

  ; C-c c コンパイル
  ; C-c r 再コンパイル
  ; C-c g gdb起動
  (define-key
    global-map
    (kbd "C-c c") 'compile)
  (define-key
    global-map
    (kbd "C-c r") 'recompile)
  (define-key
    global-map
    (kbd "C-c g") 'gdb)
  )

(add-hook 'c-mode-hook 'my-c-mode-hook)
(add-hook 'c++-mode-hook 'my-c-mode-hook)

; gdb
(setq gdb-many-windows t)


;; 対応する括弧に移動(C-M-f/p相当)
(global-set-key [?\C-{] 'backward-list)
(global-set-key [?\C-}] 'forward-list)

; cpp-hilight-buffer 設定
(setq cpp-known-face 'default)
(setq cpp-unknown-face 'default)
(setq cpp-face-type 'light)
(setq cpp-known-writable 't)
(setq cpp-unknown-writable 't)
(setq cpp-edit-list
      '(("1" nil
	 (background-color . "light gray")
	 both nil)
	("0"
	 (background-color . "light gray")
	 nil both nil)
	("" nil nil both nil)))

;;-------------------------------------------------------------------------------------
;; YAML-MODE
(require 'yaml-mode)
(add-to-list 'auto-mode-alist '("\\.yaml$" . yaml-mode))

;;-------------------------------------------------------------------------------------
;; JSON-MODE
(require 'json-mode)
(require 'json-reformat)

;; json-reformat-regionは文法正しくないと厳しいので。
(defun json-format ()
  (interactive)
  (save-excursion
    (shell-command-on-region (mark) (point) "python -m json.tool" (buffer-name) t)
    )
  )

(add-hook 'json-mode-hook
	  '(lambda ()
	     (define-key json-mode-map (kbd "C-c r") 'json-format)
	     ))

;;-------------------------------------------------------------------------------------
;; nXML mode
(add-hook 'nxml-mode-hook
	  (lambda ()
	    (setq nxml-slash-auto-complete-flag t)
	    (setq nxml-child-indent 2)
	    (setq tab-width 4)
	    
	    (custom-set-faces
	     '(rng-error
	       ((t (:background "pink"))))
	     )
	    )
)
(setq auto-mode-alist
        (cons '("\\.\\(tmpl\\|mtml\\|xhtml\\)\\'" . nxml-mode)
              auto-mode-alist))

;;-------------------------------------------------------------------------------------
;; python mode
(add-hook 'python-mode-hook
          (lambda ()
            (define-key python-mode-map "\"" 'electric-pair)
            (define-key python-mode-map "\'" 'electric-pair)
            (define-key python-mode-map "(" 'electric-pair)
            (define-key python-mode-map "[" 'electric-pair)
            (define-key python-mode-map "{" 'electric-pair)))
(defun electric-pair ()
  "Insert character pair without sournding spaces"
  (interactive)
  (let (parens-require-spaces)
    (insert-pair)))

;;-------------------------------------------------------------------------------------
;; ruby mode
(require 'ruby-electric)
(require 'smart-compile)
(add-hook 'ruby-mode-hook
	  '(lambda ()
	     (ruby-electric-mode t)
	     (define-key ruby-mode-map (kbd "C-c c") 'smart-compile)
	     ))

;;-------------------------------------------------------------------------------------
;; php mode
(load-library "php-mode")
(require 'php-mode)

;;-------------------------------------------------------------------------------------
;; Scala mode
;(add-to-list 'load-path "~/.emacs.d/scala-mode2/")
;(require 'scala-mode2)

(add-to-list 'load-path "~/.emacs.d/ensime/elisp/")
(require 'ensime)
(add-hook 'scala-mode-hook 'ensime-scala-mode-hook)


;;-------------------------------------------------------------------------------------
;; Haskell mode
(add-to-list 'load-path "~/.emacs.d/haskell-mode-2.8.0")
(load "~/.emacs.d/haskell-mode-2.8.0/haskell-site-file")

; 基本設定
(add-hook 'haskell-mode-hook 'turn-on-haskell-doc-mode)
(add-hook 'haskell-mode-hook 'turn-on-haskell-indentation)

(require 'haskell-mode)
(require 'haskell-cabal)

(add-to-list 'auto-mode-alist '("\\.hs$" . haskell-mode))
(add-to-list 'auto-mode-alist '("\\.lhs$" . literate-haskell-mode))
(add-to-list 'auto-mode-alist '("\\.cabal\\'" . haskell-cabal-mode))

; ghc-mod
(add-to-list 'exec-path (concat (getenv "HOME") "/.cabal/bin"))
(add-to-list 'load-path "~/.emacs.d/ghc-mod") 
(autoload 'ghc-init "ghc" nil t)
(add-hook 'haskell-mode-hook
  (lambda () (ghc-init) (flymake-mode)))

; auto-complete
(ac-define-source ghc-mod
  '((depends ghc)
    (candidates . (ghc-select-completion-symbol))
    (symbol . "s")
    (cache)))

(defun my-ac-haskell-mode ()
  (setq ac-sources '(ac-source-words-in-same-mode-buffers ac-source-dictionary ac-source-ghc-mod)))
(add-hook 'haskell-mode-hook 'my-ac-haskell-mode)

(defun my-haskell-ac-init ()
  (when (member (file-name-extension buffer-file-name) '("hs" "lhs"))
    (auto-complete-mode t)
    (setq ac-sources '(ac-source-words-in-same-mode-buffers ac-source-dictionary ac-source-ghc-mod))))

(add-hook 'find-file-hook 'my-haskell-ac-init)

; launch ghci
(defadvice inferior-haskell-load-file (after change-focus-after-load)
  "Change focus to GHCi window after C-c C-l command"
  (other-window 1))
(ad-activate 'inferior-haskell-load-file)


;;-------------------------------------------------------------------------------------
;; yasnippet
;(add-to-list 'load-path "~/.emacs.d/yasnippet")
;(require 'yasnippet)
;(yas/initialize)
;(yas/load-directory "~/.emacs.d/yasnippet/snippets")

;;-------------------------------------------------------------------------------------
;; folding(折りたたみ)
; C-c h  トグル
; C-c x  全部折りたたみ
; C-c s  全部展開

;; C coding style
(add-hook 'c-mode-hook
          '(lambda ()
	     (hs-minor-mode 1)))
;; Scheme coding style
(add-hook 'scheme-mode-hook
          '(lambda ()
	     (hs-minor-mode 1)))
;; Elisp coding style
(add-hook 'emacs-lisp-mode-hook
          '(lambda ()
	     (hs-minor-mode 1)))
;; Lisp coding style
(add-hook 'lisp-mode-hook
          '(lambda ()
	     (hs-minor-mode 1)))
;; Python coding style
(add-hook 'python-mode-hook
          '(lambda ()
	     (hs-minor-mode 1)))
;; Perl coding style
(add-hook 'cperl-mode-hook
	  '(lambda ()
	     (hs-minor-mode 1)))
(define-key
  global-map
  (kbd "C-c h") 'hs-toggle-hiding)
(define-key
  global-map
  (kbd "C-c x") 'hs-hide-all)
(define-key
  global-map
  (kbd "C-c s") 'hs-show-all)


;;-------------------------------------------------------------------------------------
;; リアルタイム文法チェック(flymake)
(require 'flymake)
(require 'set-perl5lib)
;(setq flymake-gui-warnings-enabled nil) ; GUIの警告は表示しない

(set-face-background 'flymake-errline "red4")
(set-face-foreground 'flymake-errline "black")
(set-face-background 'flymake-warnline "yellow")
(set-face-foreground 'flymake-warnline "black")

; M-p/M-n で警告/エラー行の移動
(global-set-key "\M-p" 'flymake-goto-prev-error)
(global-set-key "\M-n" 'flymake-goto-next-error)

; Makefile 存在時
; [Makefile]
;  check-syntax:
;      $(CXX) -Wall -Wextra -fsyntax-only $(CHK_SOURCES)
; を追加しとくこと

(defun flymake-simple-generic-init (cmd &optional opts)
  (let* ((temp-file  (flymake-init-create-temp-buffer-copy
                      'flymake-create-temp-inplace))
         (local-file (file-relative-name
                      temp-file
                      (file-name-directory buffer-file-name))))
    (list cmd (append opts (list local-file)))))

; Makefile が無くてもC/C++のチェック
(defun flymake-simple-make-or-generic-init (cmd &optional opts)
  (if (file-exists-p "Makefile")
      (flymake-simple-make-init)
    (flymake-simple-generic-init cmd opts)))

(defun flymake-c-init ()
  (flymake-simple-make-or-generic-init
   "gcc" '("-Wall" "-Wextra" "-fsyntax-only")))


(defun flymake-cc-init ()
  (flymake-simple-make-or-generic-init
   "g++" '("-Wall" "-Wextra" "-fsyntax-only")))

(push '(".+\\.c$" flymake-c-init) flymake-allowed-file-name-masks)
(push '(".+\\.cpp$" flymake-cc-init) flymake-allowed-file-name-masks)
(push '(".+\\.cc$" flymake-cc-init) flymake-allowed-file-name-masks)

;
; perl + flymake
(defvar flymake-perl-err-line-patterns '(("\(.*\) at \([^ n]+\) line \([0-9]+\)[,.n]" 2 3 nil 1)))
(defconst flymake-allowed-perl-file-name-masks '(("\.pl$" flymake-perl-init)
                                               ("\.pm$" flymake-perl-init)
                                               ("\.t$" flymake-perl-init)
                                               ))
(defun flymake-perl-init ()
  (let* ((temp-file (flymake-init-create-temp-buffer-copy
                     'flymake-create-temp-inplace))
         (local-file (file-relative-name
                      temp-file
                      (file-name-directory buffer-file-name))))
    (list "perl" (list "-wc" local-file))))

(defun flymake-perl-load ()
  (interactive)
  (set-perl5lib)
  (flymake-mode t)
  )
 
(push '(".+\\.pl$" flymake-perl-init) flymake-allowed-file-name-masks)
(push '(".+\\.pm$" flymake-perl-init) flymake-allowed-file-name-masks)
(push '(".+\\.t$" flymake-perl-init) flymake-allowed-file-name-masks)

;
; YAML + flymake
;
(defun flymake-yaml-init ()
  (interactive)
  (let* ((temp-file   (flymake-init-create-temp-buffer-copy 'flymake-create-temp-inplace))
         (local-file  (file-relative-name temp-file (file-name-directory buffer-file-name))))
    (list "emacs-yaml-syntax-check.rb" (list local-file))))

(add-to-list 'flymake-allowed-file-name-masks '("\\.ya?ml$" flymake-yaml-init))
(add-to-list 'flymake-err-line-patterns '("syntax error on line \\([0-9]+\\), col \\([0-9]+\\): `\\(.*\\)'"
                                          nil 1 2 3))
(add-hook 'yaml-mode-hook '(lambda() (flymake-mode t)))

;
; JavaScript(or JSON) + flymake
;
(defun flymake-js-init ()
  (interactive)

  (defvar flymake-jsl-err-line-patterns
    '(("^\\(.+\\)(\\([0-9]+\\)): \\(SyntaxError:.+\\)$" 1 2 nil 3)
      ("^\\(.+\\)(\\([0-9]+\\)): \\(.*warning:.+\\)$" 1 2 nil 3)))
  (setq flymake-err-line-patterns
	(append flymake-jsl-err-line-patterns flymake-err-line-patterns))

  (let* ((temp-file (flymake-init-create-temp-buffer-copy
		     'flymake-create-temp-inplace))
         (local-file (file-relative-name
		      temp-file
		      (file-name-directory buffer-file-name))))
    (list "jsl" (list "-conf" "~/.emacs.d/jsl.conf" "-process" local-file))))

(add-to-list 'flymake-allowed-file-name-masks '("\\.js$" flymake-js-init))
(add-to-list 'flymake-allowed-file-name-masks '("\\.json$" flymake-js-init))
(add-hook 'json-mode-hook '(lambda() (flymake-mode t)))
(add-hook 'js-mode-hook (lambda () (flymake-mode t)))

;
; python + flymake
;
(defun flymake-python-init ()
  (interactive)
  (let* ((temp-file   (flymake-init-create-temp-buffer-copy 'flymake-create-temp-inplace))
         (local-file  (file-relative-name temp-file (file-name-directory buffer-file-name))))
    (list "emacs-python-syntax-check.sh" (list local-file))))

(add-to-list 'flymake-allowed-file-name-masks '("\\.py$" flymake-python-init))
(add-hook 'python-mode-hook '(lambda() (flymake-mode t)))

;
; ruby + flymake
;
(defun flymake-ruby-init ()
  (interactive)
  (let* ((temp-file   (flymake-init-create-temp-buffer-copy 'flymake-create-temp-inplace))
         (local-file  (file-relative-name temp-file (file-name-directory buffer-file-name))))
    (list "ruby" (list "-c" local-file))))

(add-to-list 'flymake-allowed-file-name-masks '("\\.rb$" flymake-ruby-init))
(add-hook 'ruby-mode-hook '(lambda() (flymake-mode t)))

;
; php + flymake
;
(defun flymake-php-init ()
  (interactive)
  (let* ((temp-file   (flymake-init-create-temp-buffer-copy 'flymake-create-temp-inplace))
         (local-file  (file-relative-name temp-file (file-name-directory buffer-file-name))))
    (list "php" (list "-f" local-file "-l"))))

(add-to-list 'flymake-allowed-file-name-masks '("\\.php$" flymake-php-init))
(add-hook 'php-mode-hook '(lambda() (flymake-mode t)))

; 
; popup.el を使ってエラーを tip として表示
(defun my-flymake-display-err-popup.el-for-current-line ()
  "Display a menu with errors/warnings for current line if it has errors and/or warnings."
  (interactive)
  (message "my-flymake-display-err")
  (let* ((line-no            (flymake-current-line-no))
         (line-err-info-list (nth 0 (flymake-find-err-info flymake-err-info line-no)))
         (menu-data          (flymake-make-err-menu-data line-no line-err-info-list)))
    (if menu-data
	(popup-tip (mapconcat '(lambda (e) (nth 0 e))
			      (nth 1 menu-data)
			      "\n")))
    ))


; 日本語ロケールではerrorとwarningが区別できないのでmake実行時は英語ロケールで
(defun flymake-get-make-cmdline (source base-dir)
  (list "make"
        (list "-s"
              "-C"
              base-dir
              (concat "CHK_SOURCES=" source)
              "SYNTAX_CHECK_MODE=1"
              "LANG=C"
              "check-syntax")))


; flymakeのエラー行表示色
(set-face-background 'flymake-errline "pink")
(set-face-background 'flymake-warnline "SeaGreen1")


;(add-hook 'find-file-hook 'flymake-find-file-hook) ; 全てのファイルで flymakeを有効化
; C/C++モードのみ
(add-hook 'c++-mode-hook
 '(lambda ()
    (flymake-mode t)))
(add-hook 'c-mode-hook
 '(lambda ()
    (flymake-mode t)))


;;-------------------------------------------------------------------------------------
;; ディレクトリツリー(nav)
(add-to-list 'load-path "~/.emacs.d/emacs-nav-49")
(require 'nav)
(setq nav-split-window-direction 'vertical) ;; 分割したフレームを垂直に並べる
(global-set-key "\C-x\C-d" 'nav-toggle)     ;; C-x C-d で nav をトグル


;;-------------------------------------------------------------------------------------
;; オートコンプリート(clang++) Linuxでは動かない...
;
; プリコンパイルヘッダ
; 標準ヘッダをインクルードしたヘッダを作成し、
; $ clang++ -cc1 -emit-pch -x c++-header ./hoge.h -o stdafx.pch
; ってやっとくこｔ

;(require 'auto-complete-clang)
;(defun my-ac-config ()
;      (setq-default ac-sources '(ac-source-abbrev
;				 ac-source-dictionary
;				 ac-source-words-in-same-mode-buffers
;				 ac-source-gtags
;				 )))
;(add-hook 'c++-mode-hook 'ac-cc-mode-setup)
;(defun my-ac-cc-mode-setup ()
;    (setq ac-sources (append '(ac-source-clang ac-source-yasnippet) ac-sources))
;    (setq ac-clang-prefix-header "~/stdafx.pch")
;    (setq ac-clang-flags (append
;  (mapcar (lambda (item)(concat "-I" item))
;  (split-string
;   "
; /usr/include/c++/4.4.4
; /usr/include/c++/4.4.4/x86_64-redhat-linux
; /usr/include/c++/4.4.4/backward
; /usr/local/include
; /usr/lib/clang/2.8/include
; /usr/include
; /usr/lib/gcc/x86_64-redhat-linux/4.4.4/include
;"
;   )) ac-clang-flags ))
;    )
;(my-ac-config)


;; ------------------------------------------------------------------------
;; タブバー(tabbar)
(require 'tabbar)

;; tabbar有効化
(tabbar-mode)

;; タブ切替にマウスホイールを使用（0：有効，-1：無効）
;(tabbar-mwheel-mode -1)

;; タブグループを使用（t：有効，nil：無効）
;(setq tabbar-buffer-groups-function t)

;; キーバインド設定
(define-key
  global-map
  (kbd "<C-tab>") 'tabbar-forward)
(define-key
  global-map
  (kbd "<backtab>") 'tabbar-backward)

;;-------------------------------------------------------------------------------------
;; Perl用設定

(autoload 'cperl-mode "cperl-mode" "alternate mode for editing Perl programs" t)
(add-to-list 'auto-mode-alist '("\.\([pP][Llm]\|al\|t\|cgi\)\'" . cperl-mode))
(add-to-list 'interpreter-mode-alist '("perl" . cperl-mode))
(add-to-list 'interpreter-mode-alist '("perl5" . cperl-mode))
(add-to-list 'interpreter-mode-alist '("miniperl" . cperl-mode))
;;; cperl-mode is preferred to perl-mode
;;; "Brevity is the soul of wit" <foo at acm.org>
(defalias 'perl-mode 'cperl-mode)
 
(setq cperl-indent-level 4
      cperl-continued-statement-offset 4
      cperl-close-paren-offset -4
      cperl-label-offset -4
      cperl-comment-column 40
      cperl-highlight-variables-indiscriminately t
      cperl-indent-parens-as-block t
      cperl-tab-always-indent nil
      cperl-font-lock t)
(add-hook 'cperl-mode-hook
	  '(lambda ()
	     (progn
               (setq indent-tabs-mode nil)
               (setq tab-width nil)
	       
               ; perl-completion
	       (setq plcmp-use-keymap nil)  ; perl-completionのデフォルトキーバインドは使用しない
               (require 'perl-completion)
               (add-to-list 'ac-sources 'ac-source-perl-completion)
               (perl-completion-mode t)
	       
	       ; flymake & gtags ON
	       (flymake-perl-load)
	       (gtags-mode 1)
	       )))
 
; perl tidy
; sudo aptitude install perltidy
(defun perltidy-region ()
  "Run perltidy on the current region."
  (interactive)
  (save-excursion
    (shell-command-on-region (point) (mark) "perltidy -q" nil t)))
(defun perltidy-defun ()
  "Run perltidy on the current defun."
  (interactive)
  (save-excursion (mark-defun)
                  (perltidy-region)))
; (global-set-key "C-c t" 'perltidy-region)

; AriUbuntu MT用PERL5LIB
(setenv "PERL5LIB" (concat
		    (getenv "PERL5LIB") "/usr/lib/cgi-bin/mt/lib"))
(setenv "PERL5LIB" (concat
		    (getenv "PERL5LIB") ":/usr/lib/cgi-bin/mt/extlib"))

;;-------------------------------------------------------------------------------------
; W3M
(require 'w3m-load)
(require 'mime-w3m)
(setq w3m-home-page "http://www.google.co.jp/") ;起動時に開くページ
(setq w3m-use-cookies t) ;クッキーを使う
(setq w3m-default-display-inline-images t)

;;-------------------------------------------------------------------------------------
; Wanderlust (IMAP Client)
(setq ssl-certificate-verification-policy 1) ; この行がないとimapサーバに繋がらない
(autoload 'wl "wl" "Wanderlust" t)
(autoload 'wl-other-frame "wl" "Wanderlust on new frame." t)
(autoload 'wl-draft "wl-draft" "Write draft with Wanderlust." t)

;;-------------------------------------------------------------------------------------
;; Navi2ch
(add-to-list 'load-path "~/.emacs.d/navi2ch")
(autoload 'navi2ch "navi2ch" "Navigator for 2ch for Emacs" t)

;;-------------------------------------------------------------------------------------
; NoWindowMode用設定
(if (not window-system)
	(progn
	; 前景/背景
	(set-face-background 'default "000000")
	(set-face-foreground 'default "FFFFFF")
	(global-hl-line-mode)
	; メニューバー無し
        (menu-bar-mode -1)
	; タブバー無し(トグル＆デフォONなのでもう一回呼ぶ)
	(tabbar-mode)
	))

(put 'downcase-region 'disabled nil)
