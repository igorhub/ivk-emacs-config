(provide 'ivk-save-sql)


(defun ivk.save/on-save-sql ()
  "Reaction on saving an .sql file."
  (message (shell-command-to-string "ivk-scriptoid --success-message=- ivk-dev sqlc-generate")))


;;; ivk-save-sql.el ends here
