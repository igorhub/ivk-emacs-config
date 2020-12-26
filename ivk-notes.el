(provide 'ivk-notes)
(require 'ivk-time)
(require 'ivk-util)
(require 's)
(require 'dash)
(require 'cl)


(defvar ivk.notes/separator
      ".===============================================================================")


(defun ivk.notes/create-id ()
  "Call 'notes-create-id', return the result."
  (assert (getenv "IVK_NOTES_IDS_FILE"))
  (s-trim
   (shell-command-to-string
    (concat "notes-create-id.bb.clj"
            " --state-file " (getenv "IVK_NOTES_IDS_FILE")
            " --notes-file " (buffer-file-name)))))


(defun ivk.notes/uuid-based-id ()
  "Create new note id (with `uuidgen')."
  (concat "u" (s-replace "-" "" (s-trim (shell-command-to-string "uuidgen")))))


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


(defun ivk.notes/create-title-line-uuid ()
  "Create new note id (with `uuidgen'), return its title line."
  (let* ((now (decode-time))
         (date (ivk.time/date-string now))
         (id (concat "u" (s-replace "-" "" (s-trim (shell-command-to-string "uuidgen"))))))
    (format "== [%s]" id)))


(defun ivk.notes/create-title-line-uuid-dated ()
  "Create new note id (with `uuidgen'), return its title line (with current date and day of week)."
  (let* ((now (decode-time))
         (date (ivk.time/date-string now))
         (id (concat "u" (s-replace "-" "" (s-trim (shell-command-to-string "uuidgen"))))))
    (format "== [%s] %s, %s."
            id date (ivk.time/day-of-week now))))


(defun ivk.notes/get-id ()
  "Return the id of the note at point."
  (save-excursion
    (search-backward ivk.notes/separator nil 't)
    (when (s-equals? (ivk/line-at-point) ivk.notes/separator)
      (forward-line)
      (s-trim (substring-no-properties (thing-at-point 'line))))))


(defun ivk.notes/get-title ()
  "Return the title of the note at point."
  (save-excursion
    (search-backward ivk.notes/separator nil 't)
    (when (s-equals? (ivk/line-at-point) ivk.notes/separator)
      (forward-line 2)
      (s-trim (substring-no-properties (thing-at-point 'line))))))


(defun ivk.notes/copy-id ()
  "Copy the id of the note at point.
Example: link:200617j[]."
  (interactive)
  (kill-new (ivk.notes/get-id)))


(defun ivk.notes/make-link-old-fashioned ()
  "Copy the link to the note at point in 'short' format.
Example: link:200617j[]."
  (interactive)
  (kill-new (format "link:%s[]" (ivk.notes/get-id))))


(defun ivk.notes/make-link-short ()
  "Copy the link to the note at point in 'mini' format.
Example: {r/200617j}."
  (interactive)
  (kill-new (format "{r/%s}" (ivk.notes/get-id))))


(defun ivk.notes/make-link-textless ()
  "Copy the link to the note at point in 'mini' format.
Example: {r/200617j \"\"}."
  (interactive)
  (kill-new (format "{r/%s \"\"}" (ivk.notes/get-id))))


(defun ivk.notes/make-link-full ()
  "Copy the link to the note at point in 'mini' format.
Example: {r/200617j \"Whatever\"}."
  (interactive)
  (kill-new (format "{r/%s \"%s\"}" (ivk.notes/get-id) (ivk.notes/get-title))))


(defun ivk.notes/lookup ()
  "Lookup a note with rxvt/fzf."
  (s-trim
   (shell-command-to-string "notes-lookup.bb.clj --print")))


(defun ivk.notes/open-in-emacshelper (id)
  "Open note ID in emacshelper."
  (call-process "notes-open.bb.clj" nil nil nil
                "--browser" "emacshelper"
                "--id" id))


(defun ivk.notes/insert-id ()
  "Lookup a note, insert its id, and open it in emacshelper."
  (interactive)
  (let ((id (ivk.notes/lookup)))
    (insert id)
    (ivk.notes/open-in-emacshelper id)))


(defun ivk.notes/insert-reference ()
  "Lookup a note, insert its reference, and open it in emacshelper."
  (interactive)
  (let ((id (ivk.notes/lookup))
        (beg (region-beginning))
        (end (region-end)))
    (when (region-active-p) (goto-char beg))
    (insert (concat "{r/" id " "))
    (when (region-active-p) (goto-char (+ end 4 (length id))))
    (insert "}")
    (backward-char)
    (ivk.notes/open-in-emacshelper id)))


(defun ivk.notes/headlines ()
  "Open a temporary buffer with the headlines of the current notes document."
  (interactive)
  (let* ((buf (buffer-substring-no-properties 1 (point-max)))
         (lines (s-split "\n" buf))
         (headlines (-filter (lambda (s) (s-starts-with? "== [" s)) lines)))
    (ivk/clear-buffer-and-switch "*headlines*")
    (insert (s-join "\n" headlines))
    (insert "\n")))


(defun ivk.notes/read-current-file ()
  "DEPRECATED.

Send command to the server to read the current file."
  (interactive)
  (call-process "notes-read-file.bb.clj" nil nil nil (buffer-file-name)))


(defun ivk.notes/notes-file? ()
  "Return 't if a file in current buffer is a notes file."
  (save-excursion
    (goto-char (point-min))
    (search-forward-regexp "^== \\[[0-9a-z.-]+\\]" nil 't)
    (not (= (point) 1))))


;;; ivk-notes.el ends here
