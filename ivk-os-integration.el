(provide 'ivk-os-integration)


(defun ivk/play ()
  (interactive)
  (start-process "ivk/play" nil "remote-play.bb.clj" (buffer-file-name)))


(defun ivk/open-in-vscode ()
  "Open the file in vscode."
  (interactive)
  (start-process "whatever" nil
                 "code" "-g" (concat (buffer-file-name) ":" (format-mode-line "%l"))))



;;; ivk-os-integration.el ends here
