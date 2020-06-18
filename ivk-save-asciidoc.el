(provide 'ivk-save-asciidoc)
(require 'ivk-util)


(defun ivk.save/on-save-asciidoc ()
  "Reaction on saving a notes file (asciidoc)."
  (let ((path (buffer-file-name))
        (line (int-to-string (- (ivk/current-line) 1))))
    (start-process "whatever" nil
                   "on-save-adoc.sh" path line)))


;;; ivk-save-asciidoc.el ends here
