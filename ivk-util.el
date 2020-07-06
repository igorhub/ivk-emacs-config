(provide 'ivk-util)
(require 's)


(defun ivk/current-line ()
  "Return current line number (starting with 1)."
  (string-to-number (format-mode-line "%l")))


(defun ivk/clear-buffer-and-switch (buffer-name)
  "Create a buffer called `BUFFER-NAME' (or clear it if it exists) and switch."
  (when (get-buffer buffer-name)
    (kill-buffer buffer-name))
  (switch-to-buffer buffer-name))


(defun ivk/create-temporary-buffer-from-file (path)
  "Create a temporary buffer with the contents of file at `PATH'."
  (find-file path)
  (copy-region-as-kill 1 (point-max))
  (kill-buffer)
  (ivk/clear-buffer-and-switch "*temporary buffer*")
  (yank))


(defun ivk/local-repo? ()
  "Return 't if ivk-emacs-config is loaded manually by altering `load-path'."
  (s-suffix? "ivk.el" (locate-library "ivk")))


(defun ivk/locate-ivk-snippets ()
  "Find the path to my snippets."
  (if (ivk/local-repo?)
      (let* ((ivk.el (locate-library "ivk"))
             (dir (s-chop-suffix "ivk.el" ivk.el)))
        (s-concat dir "snippets/"))
    "~/.emacs.d/.local/straight/repos/ivk-emacs-config/snippets/"))


;;; ivk-util.el ends here
