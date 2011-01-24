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
	 (handler (cadr mapping))
	 (handler-name (string handler))
	 (request-method (cond ((eq (search "/get" handler-name :test #'string-equal)
				    (- (length handler-name) 4))
				:GET)
			       ((eq (search "/post" handler-name :test #'string-equal)
				    (- (length handler-name) 5))
				:POST)
			       (t 
				:BOTH))))
    (destructuring-bind (none0 arguments &rest rest)
	(get-lambda-list handler)
      (let ((args (cdr rest))) ;;because the first of rest is &key
	`(define-url-handler (,(gensym) :uri ,(cons uri-type uri-content) :default-request-type ,request-method)
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

