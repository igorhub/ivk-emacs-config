(provide 'ivk-ydl)


(defun ivk.ydl/enqueue (id)
  "Enqueue a youtube link with a certain `ID'."
  (call-process "bash" nil nil nil
                "-c" (concat "ydl-enqueue.bb.clj https://youtu.be/" id)))


;;; ivk-ydl.el ends here
