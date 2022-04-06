(provide 'ivk-clojure)


(defun ivk.clojure/find-repl-buffer ()
  "Find the REPL buffer."
  (car
   (-filter (lambda (buffer)
              (eq (with-current-buffer buffer major-mode)
                  'cider-repl-mode))
            (buffer-list))))


(defun ivk.clojure/find-clj-buffer ()
  "Find the buffer with Clojure code."
  (car
   (-filter (lambda (buffer)
              (eq (with-current-buffer buffer major-mode)
                  'clojure-mode))
            (buffer-list))))


(defun ivk.clojure/find-repl-window ()
  "Find the REPL window."
  (let ((repl-buffer (ivk.clojure/find-repl-buffer)))
    (when repl-buffer (get-buffer-window repl-buffer))))


(defun ivk.clojure/find-clj-window ()
  "Find the window with Clojure code."
  (let ((repl-buffer (ivk.clojure/find-clj-buffer)))
    (when repl-buffer (get-buffer-window repl-buffer))))


(defun ivk.clojure/clear-repl-buffer ()
  "Find and clear the REPL buffer."
  (interactive)
  (let ((repl-buffer (ivk.clojure/find-repl-buffer)))
    (when repl-buffer
      (with-current-buffer repl-buffer
        (cider-repl-clear-buffer)))))


(defun ivk.clojure/show-repl ()
  "Split the window and open the CIDER REPL in the right pane."
  (interactive)
  (split-window-horizontally 96)
  (other-window 1)
  (switch-to-buffer (ivk.clojure/find-repl-buffer))
  (other-window 1))


(defun ivk.clojure/switch-to-or-out-of-repl-window ()
  "Switch to (or out of) the CIDER REPL window."
  (interactive)
  (when (ivk.clojure/find-repl-window)
    (window-swap-states (ivk.clojure/find-clj-window) (ivk.clojure/find-repl-window))
    (evil-window-left 1)))


(defun ivk.clojure/open-and-switch-to-or-out-of-repl-window ()
  "Switch to (or out of) the CIDER REPL window."
  (interactive)
  (if (not (ivk.clojure/find-repl-window))
      (ivk.clojure/show-repl)
    (ivk.clojure/switch-to-or-out-of-repl-window)))


(defun ivk.clojure/zprint-function ()
  "Format function at point."
  (interactive)
  (backward-paragraph)
  (evil-visual-line)
  (forward-paragraph)
  (zprint))


;;; ivk-clojure.el ends here
