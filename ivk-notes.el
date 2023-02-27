(provide 'ivk-notes)
(require 'ivk-time)
(require 'ivk-util)
(require 's)
(require 'dash)
(require 'cl)


(defvar ivk.notes/separator
  "============================================================")


(defun ivk.notes/create-id (size)
  "Call 'notes generate-id `SIZE'', return the result."
  (assert (getenv "IVK_NOTES_IDS_FILE"))
  (s-trim
   (shell-command-to-string
    (concat "notes" " generate-id " (int-to-string size)))))


(defun ivk.notes/uuid-based-id ()
  "Create new note id (with `uuidgen')."
  (concat "u" (s-replace "-" "" (s-trim (shell-command-to-string "uuidgen")))))


(defun ivk.notes/random-id ()
  "Create new random note id (with `uuidgen')."
  (concat "x" (s-left 9 (s-replace "-" "" (shell-command-to-string "uuidgen --random")))))


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
    (when (not (string= id ""))
      (insert (s-replace "." "/" id))
      (ivk.notes/open-in-emacshelper id))))


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
      (find-file "/home/ivk/MyNotes/tv5/journal/bullcrap23.tvv")
      (goto-char (point-max))
      (search-backward-regexp ":subtype :summary-notes" nil 't)
      (forward-paragraph)
      (forward-line -1)
      (insert "- $" id "\n")
      (ivk/save-buffer)
      (switch-to-buffer buf))))


(defun ivk.notes/tmp ()
  "Own the current note."
  (interactive)
  (goto-char 0)
  (replace-regexp ":day-circle-180" ":day-regular")
  (goto-char 0)
  (replace-regexp ":entry-underlined" ":entry-regular")
  (goto-char 0)
  (replace-regexp ":image-spec.*," "")
  (ivk/save-buffer))


(defun ivk.notes/add-to-kanban-board (act status id title)
  "Add the task to write the note onto kanban board."
  (let ((task-title (format "%s: %s" act title id))
        (description (format "id: $%s" id)))
    (start-process "-" nil "personal-kanban" "create-task"
                   "--title" task-title
                   "--description" description
                   "--status" status)))


(defun ivk.notes/kanban-write-todo ()
  "Add the task to write the note onto 'todo' board."
  (interactive)
  (ivk.notes/add-to-kanban-board "write" "todo" (ivk.notes/get-id) (ivk.notes/get-title)))


(defun ivk.notes/kanban-write-doing ()
  "Add the task to write the note onto 'doing' board."
  (interactive)
  (ivk.notes/add-to-kanban-board "write" "doing" (ivk.notes/get-id) (ivk.notes/get-title)))


(defun ivk.notes/kanban-revise-doing ()
  "Add the task to write the note onto 'doing' board."
  (interactive)
  (ivk.notes/add-to-kanban-board "revise" "doing" (ivk.notes/get-id) (ivk.notes/get-title)))


(defun ivk.notes/kanban-write-done ()
  "Add the task to write the note onto 'done' board."
  (interactive)
  (ivk.notes/add-to-kanban-board "write" "done" (ivk.notes/get-id) (ivk.notes/get-title)))

;;; ivk-notes.el ends here
