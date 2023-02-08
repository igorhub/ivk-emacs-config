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


;;; ivk.el ends here
