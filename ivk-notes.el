(provide 'ivk-notes)
(require 'ivk-time)
(require 'ivk-util)
(require 's)
(require 'dash)


(defun ivk.notes/create-id ()
  "Call 'notes-create-id', return the result."
  (s-trim
   (shell-command-to-string
    (concat "notes-create-id --notes-file " (buffer-file-name)))))


(defun ivk.notes/create-title-line ()
  "Create new note id, return its title line."
  (format "== [%s]"
          (ivk.notes/create-id)))


(defun ivk.notes/create-title-line-dated ()
  "Create new note id, return its title line (with current date and day of week)."
  (let* ((now (decode-time))
         (date (ivk.time/date-string now))
         (id (ivk.notes/create-id)))
    (format "== [%s] %s, %s."
            id date (ivk.time/day-of-week now))))


(defun ivk.notes/get-id ()
  "Return an id of the note at point."
  (save-excursion
    (search-backward "== [")
    (let* ((line (thing-at-point 'line))
           (m (s-match "== \\[\\(.*\\)\\]" line)))
      (substring-no-properties (cadr m)))))


(defun ivk.notes/make-link-short ()
  "Copy the link to the note at point in 'short' format.
Example: link:200617j.html[]."
  (interactive)
  (let ((id (ivk.notes/get-id)))
    (kill-new (s-concat "link:" id ".html[]"))))


(defun ivk.notes/make-link-mini ()
  "Copy the link to the note at point in 'mini' format.
Example: {200617j}."
  (interactive)
  (let ((id (ivk.notes/get-id)))
    (kill-new (s-concat "{" id "}"))))


(defun ivk.notes/headlines ()
  "Open a temporary buffer with the headlines of the current notes document."
  (interactive)
  (let* ((buf (buffer-substring-no-properties 1 (point-max)))
         (lines (s-split "\n" buf))
         (headlines (-filter (lambda (s) (s-starts-with? "==" s)) lines)))
    (ivk/clear-buffer-and-switch "*headlines*")
    (insert (s-join "\n" headlines))
    (insert "\n")))


;;; ivk-notes.el ends here
