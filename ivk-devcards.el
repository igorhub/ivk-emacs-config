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
            (file-exists-p (concat path "devcards-settings.json")))
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


;; OBSOLETE
(defun ivk.devcards/set-project (project)
  (request "http://localhost:50050/api/set-project"
    :type "POST"
    :data (json-encode `(("project" . ,project)))
    :success (cl-function
              (lambda (&key data &allow-other-keys)
                (ivk/refresh-emacshelper)))))


;; OBSOLETE
(defun ivk.devcards/set-devcard (card)
  (request "http://localhost:50050/api/set-devcards"
    :type "POST"
    :data (json-encode `(("devcards" . [,card])))
    :success (cl-function
              (lambda (&key data &allow-other-keys)
                (ivk/refresh-emacshelper)))))


;; OBSOLETE
(defun ivk.devcards/set-devcard-under-cursor ()
  (interactive)
  (let ((project (ivk.devcards/current-project (buffer-file-name)))
        (card (ivk.devcards/devcard-under-cursor)))
    (message (format "prj: %s; card: %s" project card))
    (ivk.devcards/set-project project)
    (ivk.devcards/set-devcard card)))


(defun ivk.devcards/run-devcard-under-cursor ()
  "Display devcard under cursor in emacshelper."
  (interactive)
  (let* ((cmd (format "ivk-devcc make-url --devcards-file '%s' --line %d 2>/tmp/devcc-make-url-stderr"
                      (buffer-file-name)
                      (line-number-at-pos (point))))
         (url (s-trim (shell-command-to-string cmd))))
      (message cmd)
    (when (not (string= url ""))
      (ivk/open-in-emacshelper url))))


(defun ivk.devcards/run-devcard-under-cursor--keep-scaffolding ()
  "Display devcard under cursor in emacshelper, keep scaffolding."
  (interactive)
  (let* ((cmd (format "ivk-devcc make-url --devcards-file '%s' --line %d --keep-scaffolding 2>/tmp/devcc-make-url-stderr"
                      (buffer-file-name)
                      (line-number-at-pos (point))))
         (url (s-trim (shell-command-to-string cmd))))
      (message cmd)
    (when (not (string= url ""))
      (ivk/open-in-emacshelper url))))


(defun ivk.devcards/new (name)
  "Create new devcards file in the current directory"
  (interactive "sName: ")
  (let ((filename (concat "⚙ devcard."name ".go"))
        (parent (file-name-base (directory-file-name (file-name-directory (buffer-file-name))))))
    (shell-command (format "echo package %s > \"%s\"" parent filename))
    (find-file filename)))


;;; ivk-devcards.el ends here
