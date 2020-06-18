(provide 'ivk-save-babashka)


(defun ivk.save/on-save-babashka ()
  "Reaction on saving a babashka script."
  (start-process "whatever" nil
                 "on-save-babashka.sh" (buffer-file-name)))


;;; ivk-save-babashka.el ends here
