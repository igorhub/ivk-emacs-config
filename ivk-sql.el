(provide 'ivk-sql)

(defun ivk.sql/format-file ()
  "Format the file with sqlfluff."
  (interactive)
  (let ((cmd (concat "sqlfluff format " (buffer-file-name) " --dialect postgres")))
    (message (shell-command-to-string cmd))))


;;; ivk-sql.el ends here
