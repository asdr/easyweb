(in-package :common-lisp-user)

(defpackage :easyweb
  (:use #:cl
	#:easyweb.util
	#:hunchentoot)
  (:export #:defview
           #:map-urls
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
	

(defmacro map-urls (prefix &body body)
    `(progn
       ,@(mapcar #'(lambda (mapping)
                     (let* ((uri-part (car mapping))
                            (type (car uri-part))
                            (uri nil))
                       (case type
                         (:regex "regular exp.")
			 (:prefix "prefix")
                         (:file "file-")
                         (:folder "folder")
                         (otherwise 
			  (let* ((handler (cadr mapping))
                                 (uri (format nil "~A~A" prefix (cadr uri-part))))
			    (destructuring-bind (arg0 arg1 arg2 &rest args)
				(get-lambda-list handler)
			      `(define-easy-handler (,(gensym) :uri ,uri)
				   ,(mapcar #'(lambda(arg)
						 (if (listp arg)
						     (car arg)
						     arg))
					    args)
				 (,handler ,@(mapcan #'(lambda (arg)
							 (if (listp arg)
							     `(,(hunchentoot::convert-parameter (string-downcase (car arg)) 'keyword) (null-value-check ,(car arg) ,(cadr arg)))
							      `(,(hunchentoot::convert-parameter (string-downcase arg) 'keyword) ,arg)))
						     args)))))))))
		 body)))

(defun server-start (&key (port 8000))
  (defparameter *httpd* (start (make-instance 'acceptor :port port))))

(defun server-stop ()
  (stop *httpd*)
  (setf *httpd* nil))


(defmacro defview (name (&rest arguments) &body body)
  `(progn 
     (defun ,name (&rest arguments ,@(let ((ret (mapcar #'(lambda(arg)
							    (when (listp arg)
							      (setf (cadr arg)
								    (enclose-string (format nil "~A" (cadr arg)))))
							    arg)
							arguments)))
					  (when ret
					    (push '&key ret))))
       
       
       ,@body)
     ;; i have explicitly written down 'cl:' prefix
     ;; ftso readability
     (cl:export ',name cl:*package*)))