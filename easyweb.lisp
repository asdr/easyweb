(in-package :common-lisp-user)

(defpackage :easyweb
  (:use #:cl
	#:easyweb.util
	#:hunchentoot)
  (:export #:defview
	   #:map-all-urls
	   #:server-start
	   #:server-stop))

(in-package :easyweb)

(defun get-lambda-list (fn)
  ;;may be platform dependent code
  ;;but i still need it
  ;;returns the parameter list of given function
  (let ((ns (dsgner::empty-string))
	(lambda-list nil))
    (with-output-to-string (stream ns)
      (let ((*standard-output* stream))
	(describe fn)))
    (with-input-from-string (str ns)
      (do ((line (read-line str nil 'eof) (read-line str nil 'eof)))
	  ((eq line 'eof) lambda-list)
	(let ((start (search "Lambda-list: " line :test #'string=)))
	  (when start
	    (setf lambda-list (subseq line (+ start
					      (length "Lambda-list: "))))))))
    (if (search "(&REST ARGUMENTS &KEY " lambda-list :test #'string=)
	(read-from-string lambda-list)
	(read-from-string "(&rest argumets &key)"))))
	

(defun handle-mapping (mapping prefix)
  (let* ((uri (car mapping))
	 (uri-type (car uri))
	 (uri-content (format nil "~A~A" prefix (cadr uri))) 
	 (handler (cadr mapping)))
    (destructuring-bind (none0 arguments &rest rest)
	(get-lambda-list handler)
      (let ((args (cdr rest))) ;;because the first of rest is &key
	`(define-easy-handler (,(gensym) :uri ,uri-content)
	     ,(mapcar #'(lambda(arg)
			  (if (listp arg)
			      (car arg)
			      arg))
		      args)
	   (,handler ,@(mapcan #'(lambda (arg)
				   (if (listp arg)
				       `(,(chunga:as-keyword (string-downcase (car arg)) :destructivep nil) (null-value-check ,(car arg) ,(cadr arg)))
				       `(,(chunga:as-keyword (string-downcase arg) :destructivep nil) ,arg)))
			       args)))))))
	 

(defmacro map-all-urls (prefix &body body)
  `(progn ,@(mapcar #'(lambda(mapping)
			(funcall #'handle-mapping mapping prefix)) 
		    body)))

(defun server-start (&key (port 8000))
  (defparameter *httpd* (start (make-instance 'acceptor :port port))))

(defun server-stop ()
  (stop *httpd*)
  (setf *httpd* nil))


(defmacro defview (name inner-args (&rest arguments) &body body)
  `(progn 
     (defun ,name (&rest ,inner-args ,@(let ((ret (mapcar #'(lambda(arg)
							      (when (listp arg)
								(setf (cadr arg)
								      (enclose-string (format nil "~A" (cadr arg)))))
							      arg)
							  arguments)))
					    (when ret
					      (push '&key ret))))
       
       
       ,@body)
     
     (cl:export ',name cl:*package*)))
