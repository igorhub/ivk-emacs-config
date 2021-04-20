(provide 'ivk-save-python)
(require 'ivk-python)


(defun ivk.save/on-save-python ()
  "Reaction on saving a python file."
  (start-process "whatever" nil
                 "/home/ivk/dev/devcards/devcards-send.py"
                 (buffer-file-name))
  (message "Bump!"))


;;; ivk-save-python.el ends here
