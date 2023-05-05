(provide 'ivk-devcards)

(require 'request)


(defun ivk.devcards/current-package ()
  "Return the devcard at point."
  (save-excursion
    (search-backward-regexp "^package +\\([a-zA-Z0-9_]+\\)")
    (buffer-substring-no-properties (match-beginning 1) (match-end 1))))


(defun ivk.devcards/current-project (path)
  "Return the Golang project for the current buffer."
  (let* ((parent (file-name-directory (directory-file-name path))))
    (if (or (file-exists-p (concat path "go.mod"))
            (file-exists-p (concat path "project.json")))
        path
      (if (not (equalp parent "/"))
          (ivk.devcards/current-project parent)
        nil))))


(defun ivk.devcards/devcard-under-cursor ()
  "Return the devcard at point."
  (save-excursion
    (let ((package (ivk.devcards/current-package)))
      (search-backward-regexp "func +\\([a-zA-Z0-9_]+\\).*\\*devcard.Devcard) {")
      (concat package "." (buffer-substring-no-properties (match-beginning 1) (match-end 1))))))


(defun ivk.devcards/set-project (project)
  (request "http://localhost:50050/api/set-project"
    :type "POST"
    :data (json-encode `(("project" . ,project)))
    :success (cl-function
              (lambda (&key data &allow-other-keys)
                (ivk/refresh-emacshelper)))))


(defun ivk.devcards/set-devcard (card)
  (request "http://localhost:50050/api/set-devcards"
    :type "POST"
    :data (json-encode `(("devcards" . [,card])))
    :success (cl-function
              (lambda (&key data &allow-other-keys)
                (ivk/refresh-emacshelper)))))


(defun ivk.devcards/set-devcard-under-cursor ()
  (interactive)
  (let ((project (ivk.devcards/current-project (buffer-file-name)))
        (card (ivk.devcards/devcard-under-cursor)))
    (message (format "prj: %s; card: %s" project card))
    (ivk.devcards/set-project project)
    (ivk.devcards/set-devcard card)))


;;; ivk-devcards.el ends here
