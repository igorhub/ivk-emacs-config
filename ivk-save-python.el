(provide 'ivk-save-python)
(require 'ivk-python)


(defun ivk.save/on-save-python ()
  "Reaction on saving a python file."
  (when (s-prefix? "devcards_" (file-name-base (buffer-file-name)))
    (when (not (ivk.python/correct-python-shell-running?))
      (ivk.python/restart-python-shell))
    (python-shell-send-buffer))
  (when (get-buffer "*Python*")
    (let ((cmd (concat "pydevcards.devcards_run(globals(), '" (buffer-file-name) "')")))
      (python-shell-send-string cmd))))


;;; ivk-save-python.el ends here
