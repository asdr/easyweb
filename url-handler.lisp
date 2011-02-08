#|
This code is mostly taken from hunchentoot source code. 
Briefly, the work done in here is defining new easy-handler and a dispatcher for le-jango.
In hanchentoot define-easy-handler macro just works for absolute uris, however I need the 
other handling types, e.g. regex and prefix matching, which can also be found in hunchentoot,
but not in define-easy-handler macro. So below is that for...

--asdr 
|#

(in-package :hunchentoot)

(defparameter *url-handlers* nil
  "Handlers will be stored in this list.")

(defun dispatch-url-handlers (request)
  (loop for ((uri-type . uri-content) acceptor-names easy-handler request-type) in *url-handlers*
     when (and (or (eq acceptor-names t)
		   (find (acceptor-name *acceptor*) acceptor-names :test #'eq))
	       (or (eq :BOTH request-type)
		   (eq request-type (request-method request)))
	       (cond ((stringp uri-content)
		      (case uri-type
			(:absolute ;;ABOLUTE matching
			 (string= uri-content (script-name request)))
			(:prefix ;;PREFIX matching
			 (let ((mismatch (mismatch (script-name request) uri-content
						   :test #'char=)))
			   (and (or (null mismatch)
				    (>= mismatch (length uri-content))))))
			(:regex ;;Regular EXP. matching
			 (let ((scanner (create-scanner uri-content)))
			     (not (null (scan scanner (script-name request))))))))
		     (t (funcall uri-content request))))
     do (return easy-handler)))

(defmacro define-url-handler (description lambda-list &body body)
  (when (atom description)
    (setq description (list description)))
  (destructuring-bind (name &key uri (acceptor-names t)
                            (default-parameter-type ''string)
                            (default-request-type :both))
      description
    `(progn 
       (setq *url-handlers* (delete-if #'(lambda (list)
					   (and (or ,acceptor-names
						    (equal ,acceptor-names (second list)))
			 			(equal ,(cdr uri) (cdr (first list)))
						(eq ,default-request-type (fourth list))))
				       *url-handlers*))
       (push (list ',uri ,acceptor-names ',name ',default-request-type) *url-handlers*)
       
       (defun ,name (&key ,@(loop for part in lambda-list
			       collect (make-defun-parameter part
							     default-parameter-type
							     default-request-type)))
         ,@body))))

(cl:export 'dispatch-url-handlers)
(cl:export 'define-url-handler)
#| ---------------------------------------------------------------------------------- |#
(in-package :easyweb)

(defparameter *application-mapping-table* nil)

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
	

(defmacro! map-one-url (o!mapping o!prefix o!acceptor-name)
  `(let ((,g!uri (car ,g!mapping)))
     (let ((,g!uri-type (car ,g!uri))
	   (,g!uri-content (format nil "~A~A" ,g!prefix (cadr ,g!uri))))
       (let* ((,g!handler (cadr ,g!mapping))
	      (,g!handler-name (string ,g!handler))
	      (,g!request-method (cond ((eq (search "/get" ,g!handler-name :test #'string-equal)
					    (- (length ,g!handler-name) 4))
					:GET)
				       ((eq (search "/post" ,g!handler-name :test #'string-equal)
					    (- (length ,g!handler-name) 5))
					:POST)
				       (t 
					:BOTH))))
	 (destructuring-bind (none0 arguments &rest rest)
	     (get-lambda-list ,g!handler)
	   (let ((args (cdr rest))) ;;because the first of rest is &key
	     (hunchentoot::define-url-handler (,(gensym) :uri (,g!uri-type . ,g!uri-content) 
						:acceptor-names '(,g!acceptor-name)
						:default-request-type ,g!request-method)
		 #|,(mapcar #'(lambda (arg)
		 (if (listp arg)
		 (car arg)
		 arg))
		 args)|#
		 ()
	       (funcall ,g!handler #|,@(mapcan #'(lambda (arg)
					 (if (listp arg)
					     `(,(chunga:as-keyword (string-downcase (car arg)) 
								   :destructivep nil) 
						(null-value-check ,(car arg) ,(cadr arg)))
					     
					     `(,(chunga:as-keyword (string-downcase arg) 
								   :destructivep nil) 
						,arg)))
				     args)|#))))))))

(defmacro! easy-load-application (o!application-name o!acceptor-name)
  `(let ((,g!mappings (assoc ,g!application-name *application-mapping-table* :test #'string=)))
     (when ,g!mappings
       (let ((,g!prefix (cadr ,g!mappings))
	     (,g!dmaps (caddr ,g!mappings)))
	 (do ((i 0 (1+ i))
	      (len (length ,g!dmaps)))
	     ((>= i len))
	   (map-one-url (nth i ,g!dmaps) ,g!prefix ,g!acceptor-name))))))

(defmacro define-url-patterns (prefix &body body)
  `(unless (assoc *application-name* *application-mapping-table* :test #'string=)
     (push (cons *application-name* (list ,prefix ',body)) 
	   *application-mapping-table*)))
