(provide 'ivk-git)


(defun gd ()
  "Git diff."
  (interactive)
  (when (get-buffer ".gitdiff.diff")
    (kill-buffer ".gitdiff.diff"))
  (shell-command "git diff > /tmp/.gitdiff.diff")
  (find-file "/tmp/.gitdiff.diff")
  (goto-char (point-min)))


;;; ivk-git.el ends here
