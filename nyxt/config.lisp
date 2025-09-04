; dark mode
(define-configuration (web-buffer)
  ((default-modes (pushnew 'nyxt/mode/style:dark-mode %slot-value%))))
(define-configuration browser
  ((theme theme:+dark-theme+)))

; vi mode
(defmethod customize-instance ((buffer buffer) &key)
  (setf (slot-value buffer 'default-modes)
          '(nyxt/mode/vi:vi-normal-mode nyxt/mode/autofill:autofill-mode
                                        nyxt/mode/spell-check:spell-check-mode
                                        nyxt/mode/search-buffer:search-buffer-mode
                                        nyxt/mode/hint:hint-mode
                                        nyxt/mode/document:document-mode
                                        nyxt/mode/password:password-mode
                                        nyxt/mode/bookmark:bookmark-mode
                                        nyxt/mode/annotate:annotate-mode
                                        nyxt/mode/history:history-mode
                                        base-mode)))

(define-configuration (input-buffer)
  ((default-modes (pushnew 'nyxt/mode/vi:vi-normal-mode %slot-value%))))

(define-configuration (prompt-buffer)
  ((default-modes (pushnew 'nyxt/mode/vi:vi-insert-mode %slot-value%))))

(define-configuration (input-buffer)
  ((default-modes
    (remove-if
     (lambda (nyxt::m)
       (find (symbol-name nyxt::m)
             '("EMACS-MODE" "VI-NORMAL-MODE" "VI-INSERT-MODE") :test
             #'string=))
     %slot-value%))))
