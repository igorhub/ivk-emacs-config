(provide 'ivk)

(require 'ivk-basic)
(require 'ivk-clojure)
(require 'ivk-devcards)
(require 'ivk-git)
(require 'ivk-ivy)
(require 'ivk-notes)
(require 'ivk-os-integration)
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
  (let ((parent (file-name-base (directory-file-name (file-name-directory (buffer-file-name))))))
    (when (s-equals? "-autodelete" parent) (delete-file (buffer-name)))
    (kill-this-buffer)))


;;; ivk.el ends here
