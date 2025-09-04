;; dark mode
;; (define-configuration (web-buffer)
;;   ((default-modes (pushnew 'nyxt/mode/style:dark-mode %slot-value%))))
(define-configuration browser
  ((theme theme:+dark-theme+)))

;; vi mode
;; (define-configuration base-mode
;;   "Note the :import part of the define-keyscheme-map.
;; It re-uses the other keymap (in this case, the one that was slot value before
;; the configuration) and merely adds/modifies it."
;;   ((keyscheme-map
;;     (define-keyscheme-map "my-base" (list :import %slot-value%)
;;                           keyscheme:vi-normal
;;                           (list "g b"
;;                                 (lambda-command switch-buffer*
;;                                     nil
;;                                   (switch-buffer :current-is-last-p
;;                                                  t)))))))

(define-configuration (input-buffer)
  ((default-modes (pushnew 'nyxt/mode/vi:vi-insert-mode %slot-value%))))

(define-configuration (prompt-buffer)
  ((default-modes (pushnew 'nyxt/mode/vi:vi-insert-mode %slot-value%))))

;; TODO: wal theme
;; TODO: keys
