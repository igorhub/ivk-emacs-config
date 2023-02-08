(provide 'ivk-save)
(require 'ivk-notes)
(require 'ivk-browser-integration)
(require 'ivk-save-notes-file)
(require 'ivk-save-babashka)
(require 'ivk-save-python)
(require 'ivk-save-go)


(defun ivk.save/update-emacshelper ()
  "Update emacshelper after saving a file."
  (let ((fname (buffer-file-name)))
    (cond ((s-suffix? ".render.adoc" fname)
           (ivk.save/on-save-asciidoc))
          ((or (s-suffix? ".tv5" fname) (s-suffix? ".tvv" fname))
           (ivk.save/on-save-tv5))
          ((s-suffix? ".bb.clj" fname)
           (ivk.save/on-save-babashka))
          ((s-suffix? ".py" fname)
           (ivk.save/on-save-python))
          ((s-suffix? ".go" fname)
           (ivk.save/on-save-go))
          ((s-suffix? ".sql" fname)
           (ivk/refresh-emacshelper)))))


(defun ivk/save-buffer ()
  "Save the buffer and generate emacshelper page.

Can't use the standard hook, for I need to generate the page even
if the buffer is already saved."
  (interactive)
  (save-buffer)
  (ivk.save/update-emacshelper))


;;; ivk-save.el ends here
