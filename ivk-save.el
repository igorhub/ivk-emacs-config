(provide 'ivk-save)
(require 'ivk-notes)
(require 'ivk-browser-integration)
(require 'ivk-save-babashka)
(require 'ivk-save-go)
(require 'ivk-save-notes-file)
(require 'ivk-save-python)
(require 'ivk-save-sql)


(defun ivk.save/update-emacshelper ()
  "Update emacshelper after saving a file."
  (let ((fname (buffer-file-name)))
    (cond ((s-suffix? ".render.adoc" fname)
           (ivk.save/on-save-asciidoc))
          ((or (s-suffix? ".tv5" fname) (s-suffix? ".tvv" fname))
           (ivk.save/on-save-tv5))
          ((s-suffix? ".bb.clj" fname)
           (ivk.save/on-save-babashka))
          ((s-suffix? ".sql" fname)
           (ivk.save/on-save-sql))
          ((s-suffix? ".py" fname)
           (ivk.save/on-save-python)))))

(defun ivk/save-buffer ()
  "Save the buffer and generate emacshelper page.

Can't use the standard hook, for I need to generate the page even
if the buffer is already saved."
  (interactive)
  (when (not (eq (ivk.notes/format) ""))
    (ivk.notes/import))
  (save-buffer)
  (ivk.save/update-emacshelper))


;;; ivk-save.el ends here
