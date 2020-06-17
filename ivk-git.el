(provide 'ivk-git)


(defun gd ()
  "Git diff."
  (interactive)
  (when (get-buffer ".gitdiff.diff")
    (kill-buffer ".gitdiff.diff"))
  (shell-command "git diff > /tmp/.gitdiff.diff")
  (find-file "/tmp/.gitdiff.diff")
  (goto-char (min-point)))


;;; ivk-git.el ends here
