(provide 'ivk-clojure)


(defun ivk.clojure/repl ()
  "Switch to REPL buffer and enlargen it."
  (interactive)
  (evil-window-next nil)
  (doom/window-enlargen)
  (recenter-top-bottom -1))


(defun ivk.clojure/unrepl ()
  "Switch from REPL buffer back to source."
  (interactive)
  (doom/window-enlargen)
  (evil-window-next nil))


;;; ivk-clojure.el ends here
