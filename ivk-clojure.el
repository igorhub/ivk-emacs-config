(provide 'ivk-clojure)


(defun ivk.clojure/find-repl-buffer ()
  "Find the REPL buffer."
  (car
    (-filter (lambda (buffer)
               (eq (with-current-buffer buffer major-mode)
                   'cider-repl-mode))
             (buffer-list))))


(defun ivk.clojure/repl ()
  "Switch to REPL buffer."
  (interactive)
  (switch-to-buffer (ivk.clojure/find-repl-buffer)))


(defun ivk.clojure/unrepl ()
  "Switch from REPL buffer back to source."
  (interactive)
  (switch-to-buffer (other-buffer)))


;;; ivk-clojure.el ends here
