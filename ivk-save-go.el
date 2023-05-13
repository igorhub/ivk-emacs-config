(provide 'ivk-save-go)
(require 'ivk-browser-integration)


(defun ivk.save/on-save-go ()
  "Reaction on saving a Go file."
  (ivk/refresh-emacshelper))


(defun ivk.save/on-save-go-devcard ()
  "Reaction on saving a Go devcard file."
  (let* ((cmd (format "ivk-devcc make-url %s 2>/tmp/devcc-make-url-stderr" (buffer-file-name)))
         (url (s-trim (shell-command-to-string cmd))))
      (message url)
    (when (not (string= url ""))
      (ivk/open-in-emacshelper url))))


;;; ivk-save-go.el ends here
