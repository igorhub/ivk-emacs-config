(provide 'ivk-browser-integration)

(defun ivk/refresh-emacshelper ()
  "Reaction on saving a Go file."
  (start-process "whatever" nil
                 "refresh-emacshelper.sh"
                 (buffer-file-name)))


(defun ivk/open-url-in-primary-browser ()
  "Open the URL at point in qutebrowser."
  (interactive)
  (let ((url (thing-at-point 'url 't)))
    (when url
      (start-process "-" nil "primary-browser.sh" url))))



;;; ivk-browser-integration.el ends here
