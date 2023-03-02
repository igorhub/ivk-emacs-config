(provide 'ivk)

(require 'ivk-basic)
(require 'ivk-clojure)
(require 'ivk-git)
(require 'ivk-ivy)
(require 'ivk-notes)
(require 'ivk-ru-dvorak)
(require 'ivk-save)
(require 'ivk-startup-screen)
(require 'ivk-time)
(require 'ivk-tmux)
(require 'ivk-util)
(require 'ivk-ydl)


(defun ivk/dark-mode ()
  "Switch to dark mode."
  (interactive)
  (load-theme 'tsdh-dark)
  (setenv "IVK_DARKNESS" "YES"))


(defun ivk/kill-this-buffer ()
  "Kills the buffer and optionally runs whatever I want it to run."
  (interactive)
  (let ((name (buffer-name)))
    (cond ((s-prefix? "__pk_edit_" name)
           (progn
             (save-buffer)
             (start-process "-" nil "run-personal-kanban.sh"))))
    (kill-this-buffer)))


;;; ivk.el ends here
