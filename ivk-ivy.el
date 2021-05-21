(provide 'ivk-ivy)

(require 'ivy)

;; (defun parent&file (path)
;;   (concat (file-name-nondirectory (directory-file-name (file-name-directory path)))
;;           " / "
;;           (file-name-nondirectory path)))


;; (defun parent&file (path)
;;   (concat (file-name-nondirectory (directory-file-name (file-name-directory path)))
;;           "/"
;;           (file-name-nondirectory path)))


(defun format-path (path)
  "Format PATH to be used in ivy-switch-buffer."
  (format "%s\t(%s)"
          (file-name-nondirectory path)
          (file-name-nondirectory (directory-file-name (file-name-directory path)))))


(defun ivk.ivy/switch-buffer-transformer (str)
  "Transform candidate STR when switching buffers."
  (let* ((buf (get-buffer str))
         (path (when buf (buffer-file-name buf)))
         (displayed-str (if path (format-path path) str)))
    (cond ((not buf) displayed-str)
          ((let ((remote (ivy--remote-buffer-p buf)))
             (when remote
               (format "%s (%s)" (ivy-append-face displayed-str 'ivy-remote) remote))))
          ((not (verify-visited-file-modtime buf))
           (ivy-append-face displayed-str 'ivy-modified-outside-buffer))
          ((buffer-modified-p buf)
           (ivy-append-face displayed-str 'ivy-modified-buffer))
          (t
           (let* ((mode (buffer-local-value 'major-mode buf))
                  (face (cdr (assq mode ivy-switch-buffer-faces-alist))))
             (ivy-append-face displayed-str face))))))


;;; ivk-ivy.el ends here
