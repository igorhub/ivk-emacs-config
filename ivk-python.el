(provide 'ivk-python)
(require 'cl)
(require 'pyvenv)
(require 'python)


(defun ivk.python/find-current-venv (path)
  "Given current directory or file, return current python environment.

Note: `PATH' must be absolute."
  (let* ((parent (file-name-directory (directory-file-name path)))
         (maybe-venv (concat path ".venv/")))
    (if (file-directory-p maybe-venv)
        maybe-venv
      (if (not (equalp parent "/"))
          (ivk.python/find-current-venv parent)
        nil))))


(defun ivk.python/correct-python-shell-running? ()
  "Return 't if python shell is running, and the current file is in its load path."
  (when (get-buffer "*Python*")
    (equalp (ivk.python/find-current-venv (buffer-file-name))
            pyvenv-virtual-env)))


(defun ivk.python/restart-python-shell ()
  "(Re-) start python shell.
Called before evaluating buffer or region to avoid various uncanny conflicts,
like not reloding modules even when they are changed."
  (interactive)
  (when (get-process "Python")
    (kill-process "Python"))
  (sleep-for 0.05)
  (when (get-buffer "*Python*")
    (kill-buffer "*Python*"))
  (pyvenv-activate (ivk.python/find-current-venv (buffer-file-name)))
  (let ((default-directory (concat default-directory "../")))
    (run-python)))


;;; ivk-python.el ends here
