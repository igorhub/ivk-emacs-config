(provide 'ivk-clojure)


(defun ivk.clojure/repl ()
  "Switch to REPL buffer and enlargen it."
  (interactive)
  (evil-window-next nil)
  (doom/window-enlargen)
  (recenter-top-bottom -1))


;; Dirty.
(defun --current-window-enlargen? ()
  "Return 't, if the current window has been enlargen by `doom/window-enlargen'."
  (> (window-total-height) 20))


(defun ivk.clojure/unrepl ()
  "Switch from REPL buffer back to source."
  (interactive)
  (when (--current-window-enlargen?)
    (doom/window-enlargen))
  (evil-window-next nil))


;;; ivk-clojure.el ends here
