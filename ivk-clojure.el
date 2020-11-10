(provide 'ivk-clojure)


(defun ivk.clojure/find-repl-buffer ()
  "Find the REPL buffer."
  (car
    (-filter (lambda (buffer)
               (eq (with-current-buffer buffer major-mode)
                   'cider-repl-mode))
             (buffer-list))))


;;; ivk-clojure.el ends here
