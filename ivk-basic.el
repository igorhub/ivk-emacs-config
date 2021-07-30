;;; Basic interactive functions.
(provide 'ivk-basic)


(defun ivk/copy-buffer-file-name ()
  "Copy the file name of the current buffer to clipboard."
  (interactive)
  (kill-new buffer-file-name)
  (message buffer-file-name))


(defun ivk/switch-to-previous-buffer ()
  "Switch to previous buffer.

FIXME: This function doesn't work all the time."
  (interactive)
  (switch-to-buffer (other-buffer -1)))


(defun ivk/comment-or-uncomment-region-or-line ()
  "Comment/uncomment a region if Transient Mark is active.
If not, comment/uncomment the current line."
  (interactive)
  (if (region-active-p)
      (comment-or-uncomment-region (region-beginning) (region-end))
    (save-excursion
      (let ((beg (progn (beginning-of-line) (point)))
            (end (progn (end-of-line) (point))))
        (comment-or-uncomment-region beg end)))))


(defun ivk/revisit ()
  "Kill the current file and open it again."
  (interactive)
  (let ((file-name (buffer-file-name)))
    (when file-name
      (kill-buffer (current-buffer))
      (find-file file-name))))


(defun ivk/insert-uuid ()
  "Insert a UUID (generated with with `uuidgen')."
  (interactive)
  (insert (s-trim (shell-command-to-string "uuidgen"))))


;;; ivk-basic.el ends here
