(provide 'ivk-startup-screen)
(require 'ivk-util)

(defun ivk.startup/show-greetings-screen ()
  "Show startup screen."
  (interactive)
  (ivk/clear-buffer-and-switch "*greetings*")
  (when (file-exists-p "~/.greetings")
    (insert-file-contents "~/.greetings"))
  (goto-char (point-max))
  (insert "\n")
  (goto-char (point-min))
  (forward-paragraph 2))


;;; ivk-startup-screen.el ends here
