(in-package :easyweb)

(defvar *files-be-cloned* '(("_initialize" . "lisp")
			    ("_model" . "lisp")
			    ("_settings" . "lisp")
			    ("_view" . "lisp")
			    ("template-app" . "asd")))

(defvar *easyweb-template-application-dir* "/home/admin-o/pjs/easyweb/template-app")

(defun create-appender (initial-list)
  (let ((acc-list initial-list)
	(tail (nthcdr (1- (length initial-list)) initial-list)))
    (lambda (&rest lists)
      (dolist (al lists acc-list)
	(setf (cdr tail) al)
	(setf tail (nthcdr (1- (length al)) al))))))


(defun write-to-file (in out project-name)
  (html-template:fill-and-print-template (html-template:create-template-printer in) (list ':APPLICATION_NAME project-name) :stream out))

(defun clone-file (if-path of-path project-name)
  (with-open-file (in if-path :direction :input)
    (with-open-file (out of-path :direction :output
			         :if-exists :supersede)
      (write-to-file in out project-name))))

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
				:directory *easyweb-template-application-dir*
				:name name
				:type type))
		      (of-path (progn 
				 (when (string= type "asd")
				   (setf name project-name))
				 (make-pathname 
				  :directory path
				  :name name
				  :type type))))
		  (clone-file if-path of-path project-name))))))))