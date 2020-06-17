(provide 'ivk-util)
(require 's)


(defun ivk/current-line ()
  "Return current line number (starts with 1)"
  (string-to-number (format-mode-line "%l")))


(defun ivk/clear-buffer-and-switch (buffer-name)
  "Create a buffer called `BUFFER-NAME' (or clear it if it exists) and switch."
  (when (get-buffer buffer-name)
    (kill-buffer buffer-name))
  (switch-to-buffer buffer-name))


(defun ivk/locate-ivk-snippets ()
  "Find the path to my snippets."
  (let* ((ivk.el (locate-library "ivk"))
         (dir (s-chop-suffix "ivk.el" ivk.el)))
    (s-concat dir "snippets/")))


;;; ivk-util.el ends here
