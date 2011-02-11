(in-package :easyweb)

(defvar *files-be-cloned* '(("_initialize" . "lisp")
			    ("_model" . "lisp")
			    ("_settings" . "lisp")
			    ("_view" . "lisp")
			    ("template-app" . "asd")))

(defvar *easyweb-template-application-dir* "/home/admin-o/pjs/easyweb/template-app")
;(defvar *easyweb-template-application-dir* "/home/asdr/projects/easyweb/template-app")

(defun write-from-template (in out variables)
  (let ((template-printer (html-template:create-template-printer in)))
    (html-template:fill-and-print-template template-printer 
					   variables
					   :stream out)))

(defun clone-file (if-path of-path &rest variables &key application_name)
  (with-open-file (in if-path :direction :input)
    (with-open-file (out of-path :direction :output
			         :if-exists :supersede)
      (write-from-template in out variables))))

(defun remove-trailing-slash (string)
  (if (= (position #\/ string :from-end t)
	 (1- (length string)))
      (subseq string 0 (1- (length string)))
      string))

(defun seperate-path (path)
  (let* ((correct-path (remove-trailing-slash path))
	 (last-position (1+ (position #\/
				      correct-path
				      :from-end t))))
    (values (subseq correct-path 0 last-position)
	    (subseq correct-path last-position))))

(defun make-application (application-path)
  (let* ((application-path-n (remove-trailing-slash application-path))
	 (last-position (1+ (position #\/ 
				      application-path-n
				      :from-end t))))
    (let ((application-name (subseq application-path-n
				    last-position)))
      
      (multiple-value-bind (path exist)
          (ensure-directories-exist (format nil 
					    "~A~A" 
					    application-path-n
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
				   (setf name application-name))
				 (make-pathname 
				  :directory path
				  :name name
				  :type type))))
		  (clone-file if-path of-path :application_name application-name))))))))
