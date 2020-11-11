(provide 'ivk-clojure)


(defun ivk.clojure/find-repl-buffer ()
  "Find the REPL buffer."
  (car
    (-filter (lambda (buffer)
               (eq (with-current-buffer buffer major-mode)
                   'cider-repl-mode))
             (buffer-list))))


(defun ivk.clojure/find-repl-window ()
  "Find the REPL window."
  (let ((repl-buffer (ivk.clojure/find-repl-buffer)))
    (when repl-buffer (get-buffer-window repl-buffer))))


(defun ivk.clojure/show-repl ()
  "Split the window and open the CIDER REPL in the right pane."
  (interactive)
  (split-window-horizontally 100)
  (other-window 1)
  (switch-to-buffer (ivk.clojure/find-repl-buffer))
  (other-window 1))


(defvar ivk.clojure/last-switch nil)

(defun ivk.clojure/switch-to-or-out-of-repl-window ()
  "Switch to (or out of) the CIDER REPL window."
  (interactive)
  (when (ivk.clojure/find-repl-window)
    (let ((switch-out-of-repl? (or (eq major-mode 'cider-repl-mode)
                                   (and (eq major-mode 'fundamental-mode)
                                        ivk.clojure/last-switch))))
      (if switch-out-of-repl?
          (evil-window-left 1)
        (evil-window-right 1))
      (setq ivk.clojure/last-switch (not switch-out-of-repl?)))))


(defun ivk.clojure/open-and-switch-to-or-out-of-repl-window ()
  "Switch to (or out of) the CIDER REPL window."
  (interactive)
  (if (not (ivk.clojure/find-repl-window))
      (ivk.clojure/show-repl)
    (ivk.clojure/switch-to-or-out-of-repl-window)))


;;; ivk-clojure.el ends here
