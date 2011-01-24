(in-package :easyweb)

(defun create-word-scanner (word)
  (let ((word-buffer (coerce word 'list)))
    (lambda (text-string)
      (let ((s-word nil))
	    (text (coerce text-string 'list)))
	(dolist (ch text)
	  (if (or (eq ch #\Space)
		  (eq ch #\Newline)
		  (eq ch #\Tab))
	      (w
	     

(defun create-appender (initial-list)
  (let ((acc-list initial-list)
	(tail (nthcdr (1- (length initial-list)) initial-list)))
    (lambda (&rest lists)
      (dolist (al lists acc-list)
	(setf (cdr tail) al)
	(setf tail (nthcdr (1- (length al)) al))))))


	      

(defun write-to-file (in out)
  (do ((line (read-line in nil 'eos) (read-line in nil 'eos)))
      ((eq line 'eof) t)
    (princ line out)))

(defun clone-file (if-path of-path)
  (with-open-file (in if-path :direction :input)
    (with-open-file (out of-path :direction :output
			         :if-exists :supersede)
      (write-to-file in out))))



