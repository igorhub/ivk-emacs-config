(provide 'ivk-time)


(defun ivk.time/time-string (date)
  "Return time of `DATE', formatted as HH:MM."
  (format "%02d:%02d" (car (cddr date)) (cadr date)))


(defun ivk.time/date-string (date)
  "Return date of `DATE', formatted as YYYY-MM-DD."
  (let ((d (cdr (cddr date))))
    (format "%d-%02d-%02d" (car (cddr d)) (cadr d) (car d))))


(defun ivk.time/day-of-week (date)
  "Return abbreviated (3 letters) day of week of `DATE'."
  (case (nth 6 (decode-time))
    (0 "sun")
    (1 "mon")
    (2 "tue")
    (3 "wed")
    (4 "thu")
    (5 "fri")
    (6 "sat")))


;;; ivk-time.el ends here
