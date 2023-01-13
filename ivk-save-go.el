(provide 'ivk-save-go)

(defun ivk.save/on-save-go ()
  "Reaction on saving a Go file."
  (start-process "whatever" nil
                 "refresh-emacshelper.sh"
                 (buffer-file-name))
  (message "Bump!"))


;;; ivk-save-go.el ends here
