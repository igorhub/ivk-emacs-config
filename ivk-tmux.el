(provide 'ivk-tmux)


(defun ivk/tmux-ranger-push ()
  "Open current directory in ranger (in tmux session main:rgr)."
  (interactive)
  (let* ((dir default-directory)
         (cmd1 "tmux select-window -t main:rgr")
         (cmd2 "tmux send-keys -t main:rgr ':' && sleep 0.005")
         (cmd3 "tmux send-keys -t main:rgr 'tab_new' C-m && sleep 0.005")
         (cmd4 "tmux send-keys -t main:rgr ':' && sleep 0.005")
         (cmd5 (concat "tmux send-keys -t main:rgr 'cd " dir "' C-m"))
         (cmd6 "wmctrl -s 2"))
    (start-process "whatever" nil "bash" "-c" (concat cmd1 "&&" cmd2 "&&" cmd3 "&&" cmd4 "&&" cmd5 "&&" cmd6))))


;;; ivk-tmux.el ends here
