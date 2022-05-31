(provide 'ivk-notes)
(require 'ivk-time)
(require 'ivk-util)
(require 's)
(require 'dash)
(require 'cl)


(defvar ivk.notes/separator
  "============================================================")


(defun ivk.notes/create-id ()
  "Call 'notes-create-id', return the result."
  (assert (getenv "IVK_NOTES_IDS_FILE"))
  (s-trim
   (shell-command-to-string
    (concat "notes" " generate-id"
            " --state-file " (getenv "IVK_NOTES_IDS_FILE")
            " --notes-file " (buffer-file-name)))))


(defun ivk.notes/uuid-based-id ()
  "Create new note id (with `uuidgen')."
  (concat "u" (s-replace "-" "" (s-trim (shell-command-to-string "uuidgen")))))


(defun ivk.notes/random-id ()
  "Create new random note id (with `uuidgen')."
  (concat "x" (s-left 9 (s-replace "-" "" (shell-command-to-string "uuidgen --random")))))


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


(defun ivk.notes/create-pt-ticket ()
  "Run `create-pt-ticket.bb.clj' on the current file."
  (interactive)
  (save-buffer)
  (call-process "create-pt-ticket.bb.clj" nil nil nil (buffer-name))
  (revert-buffer))


(defun ivk.notes/get-id ()
  "Return the id of the note at point."
  (save-excursion
    (search-backward ivk.notes/separator nil 't)
    (end-of-line)
    (s-trim (substring-no-properties (thing-at-point 'filename)))))


(defun ivk.notes/get-title ()
  "Return the title of the note at point."
  (save-excursion
    (search-backward ivk.notes/separator nil 't)
    (forward-line)
    (s-trim (substring-no-properties (thing-at-point 'line)))))


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


(defun ivk.notes/lookup (sort-by-date?)
  "Lookup a note with rxvt/fzf.
Could be sorted by date wint SORT-BY-DATE? argument."
  (s-trim
   (shell-command-to-string (if sort-by-date?
                                "notes lookup --print+"
                              "notes lookup --print"))))


(defun ivk.notes/open-in-emacshelper (id)
  "Open note ID in emacshelper."
  (call-process "notes" nil nil nil
                "open"
                "--browser" "emacshelper"
                "--id" id))


(defun ivk.notes/insert-id ()
  "Lookup a note, insert its id, and open it in emacshelper."
  (interactive)
  (let ((id (ivk.notes/lookup nil)))
    (insert (s-replace "." "/" id))
    (ivk.notes/open-in-emacshelper id)))


(defun ivk.notes/insert-id--sorted-by-date ()
  "Lookup a note (sorted by date), insert its id, and open it in emacshelper."
  (interactive)
  (let ((id (ivk.notes/lookup 't)))
    (insert id)
    (ivk.notes/open-in-emacshelper id)))


(defun ivk.notes/headlines ()
  "Open a temporary buffer with the headlines of the current notes document."
  (interactive)
  (let ((headlines (shell-command-to-string
                    (concat "notes headlines " (buffer-file-name)))))
    (ivk/clear-buffer-and-switch "*headlines*")
    (insert headlines)))


(defun ivk.notes/own ()
  "Own the current note."
  (interactive)
  (let ((id (ivk.notes/get-id))
        (buf (current-buffer)))
    (save-excursion
      (find-file "/home/ivk/MyNotes/tv5/journal/bullcrap22.tvv")
      (goto-char (point-max))
      (search-backward-regexp ":subtype :summary-notes" nil 't)
      (forward-paragraph)
      (insert "- $" id "\n")
      (ivk/save-buffer)
      (switch-to-buffer buf))))


;;; ivk-notes.el ends here
