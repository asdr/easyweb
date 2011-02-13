(in-package :easyweb)

(defvar *files-be-cloned* '(("_initialize" . "lisp")
			    ("_model" . "lisp")
			    ("_settings" . "lisp")
			    ("_view" . "lisp")
			    ("template-app" . "asd")))

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

(defun make-application (application-path &key (autoload-at-startup t))
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
	     do (let ((if-path (merge-pathnames (concatenate 'string 
							     name 
							     "." 
							     type)
						easyweb.settings:+default-application-dir+))
		      (of-path (progn 
				 (when (string= type "asd")
				   (setf name application-name))
				 (make-pathname 
				  :directory path
				  :name name
				  :type type))))
		  (clone-file if-path of-path :application_name application-name)))
	  (pushnew path asdf:*central-registry*)
	  (when autoload-at-startup
	    (add-to-init-file application-name path)))))))
		  
	  ;;we need to add the path to the quicklisp autoload directory
	  ;;i am not sure where should i add the path
	  ;;therefore i will, for now, make symbolic link under ~/.local/share/common-lisp/source/
	  ;;(create-symbolic-link (concatenate 'string 
	  ;;				     application-path-n 
	  ;;				     "/")						 
	  ;;			(merge-pathnames (concatenate 'string 
	  ;;						      ".local/share/common-lisp/source/"
	  ;;						      application-name 
	  ;;						      "/")
	  ;;					 (user-homedir-pathname))))))))

(defun create-symbolic-link (destination-path link-name)
  (labels ((path-to-string (path)
	     (when path
	       (let ((path-dir (cdr (pathname-directory path))))
		 (subseq (reduce #'(lambda (x y)
				     (concatenate 'string "/" x "/" y))
				 path-dir)
			 1)))))
    (let ((dest (if (pathnamep destination-path)
		    (concatenate 'string (path-to-string destination-path) "/")
		    destination-path))
	  (name (if (pathnamep link-name)
		    (path-to-string link-name)
		    link-name)))
      #+:sbcl
      (sb-ext:run-program "/bin/ln" (list "-s" dest name)))))

(defun add-to-init-file (application-name application-path)
  #-sbcl
  (error "NO-SBCL")
  #+sbcl
  (let ((init-file-path (merge-pathnames ".sbclrc"
					 (user-homedir-pathname))))
    (with-open-file (stream init-file-path 
			    :direction :output 
			    :if-exists :append 
			    :if-does-not-exist :create)
      (format stream 
	      "~%~%~%~A~A~%~A~S~A~%~%~%"
	      "#-" application-name
	      "(pushnew " application-path " asdf:*central-registry*)"))))

