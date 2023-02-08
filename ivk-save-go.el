(provide 'ivk-save-go)
(require 'ivk-browser-integration)

(defun ivk.save/on-save-go ()
  "Reaction on saving a Go file."
  (ivk/refresh-emacshelper)
  (message "Bump!"))


;;; ivk-save-go.el ends here
