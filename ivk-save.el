(provide 'ivk-save)
(require 'ivk-save-asciidoc)
(require 'ivk-save-babashka)
(require 'ivk-save-python)


(defun ivk.save/update-emacshelper ()
  "Update emacshelper after saving a file."
  (let ((fname (buffer-file-name)))
    (cond ((s-suffix? ".adoc" fname)
           (ivk.save/on-save-asciidoc))
          ((s-suffix? ".bb.clj" fname)
           (ivk.save/on-save-babashka))
          ((s-suffix? ".py" fname)
           (ivk.save/on-save-python)))))


(defun ivk/save-buffer ()
  "Save the buffer and generate emacshelper page.

Can't use the standard hook, for I need to generate the page even
if the buffer is already saved."
  (interactive)
  (save-buffer)
  (ivk.save/update-emacshelper))


;;; ivk-save.el ends here
