(provide 'ivk-tmux)


(defun ivk.tmux/new-shell ()
  "Open current directory in a new shell in tmux."
  (interactive)
  (start-process "whatever" nil "tmux-new-shell.sh"))


(defun ivk.tmux/new-lf ()
  "Open current directory in lf instance in tmux."
  (interactive)
  (start-process "whatever" nil "tmux-new-lf.sh"))


;;; ivk-tmux.el ends here
