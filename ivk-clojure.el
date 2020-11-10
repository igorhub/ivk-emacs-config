(provide 'ivk-clojure)


(defun ivk.clojure/find-repl-buffer ()
  "Find the REPL buffer."
  (car
    (-filter (lambda (buffer)
               (eq (with-current-buffer buffer major-mode)
                   'cider-repl-mode))
             (buffer-list))))


(defun ivk.clojure/show-repl ()
  "Split the window and open the CIDER REPL in the right pane."
  (interactive)
  (split-window-horizontally 100)
  (other-window 1)
  (switch-to-buffer (ivk.clojure/find-repl-buffer))
  (other-window 1))


;;; ivk-clojure.el ends here
