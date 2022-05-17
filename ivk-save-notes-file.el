(provide 'ivk-save-notes-file)
(require 'ivk-util)


(defun ivk.save/on-save-asciidoc ()
  "Reaction on saving a notes file (asciidoc format)."
  (let ((path (buffer-file-name))
        (line (int-to-string (- (ivk/current-line) 1))))
    (start-process "whatever" nil
                   "on-save-asciidoc.bb.clj" path line)))


(defun ivk.save/on-save-tv5 ()
  "Reaction on saving a notes file (tv5 format)."
  (start-process "whatever" nil
                 "notes" "on-save-file" (buffer-file-name) (or (ivk.notes/get-id) "")))


;;; ivk-save-notes-file.el ends here
