(provide 'ivk-save-go)
(require 'ivk-browser-integration)
(require 'ivk-devcards)


(defun ivk.save/on-save-go ()
  "Reaction on saving a Go file."
  (ivk/refresh-emacshelper))


(defun ivk.save/on-save-go-devcard ()
  "Reaction on saving a Go devcard file."
  (ivk.devcards/run-devcard-under-cursor))


;;; ivk-save-go.el ends here
