(provide 'ivk)

(require 'ivk-basic)
(require 'ivk-clojure)
(require 'ivk-git)
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


(defun ivk/open-url-in-qutebrowser ()
  "Open the URL at point in qutebrowser."
  (interactive)
  (let ((url (thing-at-point 'url 't)))
    (when url
      (start-process "-" nil "qutebrowser" "--basedir" "~/.config/qutebrowser-primary-ii" url))))


;;; ivk.el ends here
