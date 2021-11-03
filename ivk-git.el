(provide 'ivk-git)


(defun ivk.git/gd ()
  "Git diff."
  (interactive)
  (when (get-buffer ".gitdiff.diff")
    (kill-buffer ".gitdiff.diff"))
  (shell-command "git diff > /tmp/.gitdiff.diff")
  (find-file "/tmp/.gitdiff.diff")
  (goto-char (point-min)))


(defun ivk.git/show-lazygit ()
  "Show lazygit window."
  (interactive)
  (start-process "whatever" nil "progs" "show-lazygit" (file-name-directory (buffer-file-name))))


;;; ivk-git.el ends here
