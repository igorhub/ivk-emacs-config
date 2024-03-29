(provide 'ivk-notes)
(require 'cl)
(require 'dash)
(require 's)
(require 'ivk-basic)
(require 'ivk-time)
(require 'ivk-util)


(defvar ivk.notes/separator
  "============================================================")


(defun ivk.notes/create-id (size)
  "Call 'notes generate-id `SIZE'', return the result."
  (assert (getenv "IVK_NOTES_IDS_FILE"))
  (s-trim
   (shell-command-to-string
    (concat "notes" " generate-id " (int-to-string size)))))


(defun ivk.notes/insert-id-3 ()
  "Generate and insert a three-letter ID."
  (interactive)
  (insert (ivk.notes/create-id 3)))


(defun ivk.notes/insert-id-4 ()
  "Generate and insert a four-letter ID."
  (interactive)
  (insert (ivk.notes/create-id 4)))


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


(defun ivk.notes/lookup ()
  "Lookup a note with rxvt/fzf.
Could be sorted by date wint SORT-BY-DATE? argument."
  (s-trim
   (shell-command-to-string "ivk-notes lookup print")))


(defun ivk.notes/open-in-emacshelper (id)
  "Open note ID in emacshelper."
  (call-process "ivk-notes" nil nil nil "open" id))


(defun ivk.notes/insert-id ()
  "Lookup a note, insert its id, and open it in emacshelper."
  (interactive)
  (let ((id (ivk.notes/lookup)))
    (when (not (string= id ""))
      (insert "[$" id "]")
      (ivk.notes/open-in-emacshelper id))))


(defun ivk.notes/headlines ()
  "Open a temporary buffer with the headlines of the current notes document."
  (interactive)
  (let ((headlines (shell-command-to-string
                    (concat "notes headlines " (buffer-file-name)))))
    (ivk/clear-buffer-and-switch "*headlines*")
    (insert headlines)))


;; (defun ivk.notes/tmp ()
;;   "Own the current note."
;;   (interactive)
;;   (goto-char 0)
;;   (replace-regexp ":day-circle-180" ":day-regular")
;;   (goto-char 0)
;;   (replace-regexp ":entry-underlined" ":entry-regular")
;;   (goto-char 0)
;;   (replace-regexp ":image-spec.*," "")
;;   (ivk/save-buffer))


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


(defun ivk.notes/rewrite ()
  "Rewrite the notes file in the current buffer."
  (interactive)
  (call-process "notes-rewrite" nil nil nil (buffer-file-name)))


(defun ivk.notes/jot ()
  "Add a jot."
  (interactive)
  (assert (getenv "IVK_NOTES_JOT_FILE"))
  (find-file (getenv "IVK_NOTES_JOT_FILE"))
  (end-of-buffer)
  (backward-paragraph)
  (insert "\n.line\n.pp\n\n")
  (previous-line)
  (evil-insert 0))


(defun ivk.notes/format ()
  (cond ((s-suffix? ".ino" (buffer-name)) "ino")
        ((s-suffix? ".eno" (buffer-name)) "eno")
        (:else "")))


(defun ivk.notes/import ()
  "Import and rewrite. Run on before-save-hook."
  (interactive)
  (when (not (eq (ivk.notes/format) ""))
    (let* ((tmp (make-temp-file "ivk-notes-import-" nil "" (ivk/buffer-content-string (current-buffer))))
           (status (call-process-shell-command (concat "ivk-notes import " (ivk.notes/format)) tmp "*ivk-notes-out*")))
      (if (= status 0)
          (save-excursion
            (replace-buffer-contents "*ivk-notes-out*"))
        (message (ivk/buffer-content-string "*ivk-notes-out*")))
      (kill-buffer "*ivk-notes-out*")
      (delete-file tmp))))


(setq ivk.notes/highlights
      '(("^\\.ino.*\\|^\\.item.*\\|^\\.cont.*" . 'font-lock-comment-delimiter-face)
        ("^\\.pp.*" . 'font-lock-comment-delimiter-face)
        ("^\\.list.*" . 'font-lock-comment-delimiter-face)
        ("^\\.quote.*" . 'font-lock-comment-delimiter-face)
        ("^\\.code.*" . 'font-lock-comment-delimiter-face)
        ("^\\.asciidoc.*" . 'font-lock-comment-delimiter-face)
        ("^\\.html.*" . 'font-lock-comment-delimiter-face)
        ("^\\.line.*" . 'font-lock-builtin-face)
        ("^\\.section.*" . 'font-lock-string-face)
        ("^\\.verbatim.*" . 'font-lock-comment-delimiter-face)
        ("^\\.topics.*" . 'font-lock-comment-delimiter-face)
        ("^\\.backreferences.*" . 'font-lock-string-face)
        ("^\\.subs" . 'font-lock-comment-delimiter-face)
        ("^\\.gras-cutoff.*" . 'font-lock-builtin-face)
        ("^//.*" . 'font-lock-comment-delimiter-face)
        ("^\\:[a-z].*" . 'font-lock-doc-face)
        ("\\$[-.a-zA-Z0-9]+" . 'font-lock-comment-delimiter-face)))


(define-derived-mode eno-mode text-mode "eno"
  "Major mode for editing .eno notes."
  (setq font-lock-defaults '(ivk.notes/highlights)))


;;; ivk-notes.el ends here
