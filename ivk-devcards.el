(provide 'ivk-devcards)

(require 'request)


(defun ivk.devcards/current-package ()
  "Return the devcard at point."
  (save-excursion
    (search-backward-regexp "^package +\\([a-zA-Z0-9_]+\\)")
    (buffer-substring-no-properties (match-beginning 1) (match-end 1))))


(defun ivk.devcards/devcard-under-cursor ()
  "Return the devcard at point."
  (save-excursion
    (let ((package (ivk.devcards/current-package)))
      (search-backward-regexp "func +\\([a-zA-Z0-9_]+\\).*\\*devcard.Devcard) {")
      (concat package "." (buffer-substring-no-properties (match-beginning 1) (match-end 1))))))


(defun ivk.devcards/set-devcard-under-cursor ()
  (interactive)
  (request "http://localhost:50050/api/set-devcards"
    :type "POST"
    :data (json-encode `(("devcards" . [,(ivk.devcards/devcard-under-cursor)])))
    :success (cl-function
              (lambda (&key data &allow-other-keys)
                (ivk/refresh-emacshelper)))))


;;; ivk-devcards.el ends here
