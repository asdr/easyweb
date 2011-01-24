(in-package :easyweb)

(defvar *files-be-cloned* '(("_initialize" . "lisp")
			    ("_model" . "lisp")
			    ("_settings" . "lisp")
			    ("_view" . "lisp")
			    ("prototype-app1" . "asd")))

(defvar *easyweb-prototype-dir* "/home/asdr/projects/easyweb/prototype-app1")

#|
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
|#

(defun create-appender (initial-list)
  (let ((acc-list initial-list)
	(tail (nthcdr (1- (length initial-list)) initial-list)))
    (lambda (&rest lists)
      (dolist (al lists acc-list)
	(setf (cdr tail) al)
	(setf tail (nthcdr (1- (length al)) al))))))


(defun write-to-file (in out)
  (do ((line (read-line in nil 'eof) (read-line in nil 'eof)))
      ((eql line 'eof) t)
    (format out "~A~A" line #\\Newline)))

(defun clone-file (if-path of-path)
  (with-open-file (in if-path :direction :input)
    (with-open-file (out of-path :direction :output
			         :if-exists :supersede)
      (write-to-file in out))))

(defun remove-trailing-slash (string)
  (if (= (position #\/ string :from-end t)
	 (1- (length string)))
      (subseq string 0 (1- (length string)))
      string))

(defun make-project (project-path)
  (let* ((project-path-n (remove-trailing-slash project-path))
	 (last-position (1+ (position #\/ 
				      project-path-n
				      :from-end t))))
    (let ((project-name (subseq project-path-n
				last-position)))

      (multiple-value-bind (path exist)
          (ensure-directories-exist (format nil 
					    "~A~A" 
					    project-path-n
					    #\/)) ;;in order to use 
	                                          ;;ensure-directories-exist
                                                  ;;we need #\/ at the end of
                                                  ;;a directory path
	(when exist
	  (loop 
	     for (name . type) in *files-be-cloned*
	     do (let ((if-path (make-pathname 
				:directory *easyweb-prototype-dir*
				:name name
				:type type))
		      (of-path (make-pathname 
				:directory path
				:name name
				:type type)))
		  (clone-file if-path of-path))))))))