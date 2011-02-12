(in-package :easyweb)

(defparameter *acceptor-name* nil)
(defparameter *application-contexts* nil)

(defstruct (application-context
	     (:conc-name context-))
  name
  acceptor-status-list ;default acceptors of application
  mappings)

(defstruct (url-mapping
	     (:conc-name mapping-))
  uri
  handler
  request-method)

(defun application-start (application-name &key (port *listen-port*) (address *listen-address*))
  (when application-name
    (let* ((starter (get-easy-starter :address address
				      :port port))
	   (acceptor (easy-starter-acceptor starter)))
      (when (and starter
		 acceptor)
	(application-load application-name :acceptor-name (hunchentoot:acceptor-name acceptor))
	(hunchentoot:start acceptor)
	(format t "Application started: ~S~%" application-name)))))

(defun application-load (application-name &key acceptor-name)
  (loop 
     for context in *application-contexts*
     when (and context
	       (string-equal application-name (context-name context)))
     do (if (null acceptor-name) 
	    (setf (context-acceptor-status-list context) (list (cons nil t)))
	    (if (member acceptor-name (context-acceptor-status-list context) :test #'string= :key #'car)
		(setf (cdr (context-acceptor-status-list context)) t)
		(push (cons acceptor-name t) (context-acceptor-status-list context))))))

(defun application-unload (application-name &key acceptor-name)
  (loop 
     for context in *application-contexts*
     when (and context
	       (string-equal application-name (context-name context)))
     do (if (null acceptor-name) 
	    (setf (context-acceptor-status-list context) (list (cons nil nil)))
	    (if (member acceptor-name (context-acceptor-status-list context) :test #'string= :key #'car)
		(setf (cdr (context-acceptor-status-list context)) nil)))))


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

(defmacro define-url-patterns (prefix &body body)
  `(progn
     ,@(mapcar #'(lambda(mapping)
		   (map-one-pattern mapping prefix *acceptor-name*))
	       body)))

(defun map-one-pattern (mapping prefix acceptor-name)
  (let ((uri (car mapping)))
    (let ((uri-type (car uri))
	  (uri-content (format nil "~A~A" prefix (cadr uri))))
      (let* ((handler (cadr mapping))
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
	    `(define-url-handler (,(gensym) :uri ,(cons uri-type uri-content)
				   :default-request-type ,request-method)
		 ,(mapcar #'(lambda (arg)
			     (if (listp arg)
				 (car arg)
				 arg))
			 args)
	       (,handler ,@(mapcan #'(lambda (arg)
				       (if (listp arg)
					   `(,(chunga:as-keyword (string-downcase (car arg)) 
								 :destructivep nil) 
					      (null-value-check ,(car arg) ,(cadr arg)))
					   
					   `(,(chunga:as-keyword (string-downcase arg) 
								 :destructivep nil) 
					      ,arg)))
				   args)))))))))

(defun dispatch-url-handlers (request)
  (loop 
     for context in *application-contexts*
     when context
     do (let ((asl (context-acceptor-status-list context)))
	  (loop
	     for mapping in (context-mappings context)
	     do (let ((uri (mapping-uri mapping)))
		  (let ((uri-type (car uri))
			(uri-content (cdr uri))
			(easy-handler (mapping-handler mapping))
			(request-type (mapping-request-method mapping)))
		    (when (and (cdr (find (hunchentoot:acceptor-name hunchentoot:*acceptor*) asl :test #'string= :key #'car))
			       (or (eq :BOTH request-type)
				   (eq request-type (hunchentoot:request-method request)))
			       (cond ((stringp uri-content)
				      (case uri-type
					(:absolute ;;ABOLUTE matching
					 (string= uri-content (hunchentoot:script-name request)))
					(:prefix ;;PREFIX matching
					 (let ((mismatch (mismatch (hunchentoot:script-name request) uri-content
								   :test #'char=)))
					   (and (or (null mismatch)
						    (>= mismatch (length uri-content))))))
					(:regex ;;Regular EXP. matching
					 (let ((scanner (cl-ppcre:create-scanner uri-content)))
					   (not (null (cl-ppcre:scan scanner (hunchentoot:script-name request))))))))
				     (t (funcall uri-content request))))
		      (return-from dispatch-url-handlers easy-handler))))))))
  
(defmacro define-url-handler (description lambda-list &body body)
  (when (atom description)
    (setq description (list description)))
  (destructuring-bind (name &key uri
                            (default-parameter-type ''string)
                            (default-request-type :both))
      description
    `(let ((context (loop for app in *application-contexts*
		       when (string= (context-name app) *application-name*)
		       do (return app))))
       (unless context
	 (setf context (make-application-context :name *application-name*))
	 (push context *application-contexts*))
       
       (setf (context-mappings context) (delete-if #'(lambda (a-mapping)
						       (and (equal ,(cdr uri) (cdr (mapping-uri a-mapping)))
							    (eq ,default-request-type (mapping-request-method a-mapping))))
						   (context-mappings context)))
       (push (make-url-mapping :uri (cons ,(car uri) ,(cdr uri)) 
			       :handler ',name 
			       :request-method ',default-request-type) 
	     (context-mappings context))
       
       (defun ,name (&key ,@(loop for part in lambda-list
			       collect (hunchentoot::make-defun-parameter part
									 default-parameter-type
									 default-request-type)))
	 ,@body))))