(provide 'ivk-os-integration)


(defun ivk/play ()
  (interactive)
  (start-process "ivk/play" nil "remote-play.bb.clj" (buffer-file-name)))


;;; ivk-os-integration.el ends here
