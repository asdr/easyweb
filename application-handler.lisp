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
      (when (and starter acceptor)
	(application-load application-name :acceptor-name (hunchentoot:acceptor-name acceptor))
	(pushnew application-name (easy-starter-applications starter))
	(hunchentoot:start acceptor)
	(format t "Application started: ~S~%" application-name)))))

(defun application-stop (application-name &optional (acceptor-name (format nil 
									   "(~A . ~A)" 
									   *listen-address* 
									   *listen-port*)))
  (when application-name
    (let ((starter (gethash acceptor-name *acceptor-table*)))
      (when starter
	(let ((acceptor (easy-starter-acceptor starter)))
	  (when acceptor
	    (application-unload application-name :acceptor-name (hunchentoot:acceptor-name acceptor))
	    (format t "Application stopped: ~S~%" application-name)
	    (setf (easy-starter-applications starter) (delete-if #'(lambda(obj) 
								     (string= application-name obj))
								 (easy-starter-applications starter)))
	    (when (zerop (length (easy-starter-applications starter)))
	      (hunchentoot:stop acceptor)
	      (format t "Acceptor stopped: ~S~%" (hunchentoot:acceptor-name acceptor)))))))))
    
(defun application-load (application-name &key acceptor-name)
  (loop 
     for context in *application-contexts*
     when (and context
	       (string-equal application-name (context-name context)))
     do (if (null acceptor-name) 
	    (setf (context-acceptor-status-list context) (list (cons (nil t))))
	    (let ((target (member acceptor-name (context-acceptor-status-list context) :test #'string= :key #'car)))
	      (if target
		  (setf (cdar (context-acceptor-status-list context)) t)
		  (push (cons acceptor-name t) (context-acceptor-status-list context)))))))
  

(defun application-unload (application-name &key acceptor-name)
  (if (null acceptor-name)
      "Acceptor-name required!"
      (loop 
	 for context in *application-contexts*
	 when (and context
		   (string-equal application-name (context-name context)))
	 do (setf (context-acceptor-status-list context) (delete-if #'(lambda(el)
									(and (car el)
									     (string= (car el) acceptor-name)))
								    (context-acceptor-status-list context))))))
(defmacro define-url-patterns (prefix &body body)
  `(progn
     ,@(mapcar #'(lambda(mapping)
		   (map-one-pattern mapping prefix *acceptor-name*))
	       body)))

(defun map-one-pattern (mapping prefix acceptor-name)
  (let ((uri (car mapping)))
    (let ((uri-type (car uri))
	  (uri-content (format nil "~A~A" prefix (cadr uri)))
	  (handler (cadr mapping)))
      `(define-url-handler (,handler :uri ,(cons uri-type uri-content))))))

(defmacro define-url-handler (description)
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
	     (context-mappings context)))))

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
		    ;(format t "~A" (cdr (find (hunchentoot:acceptor-name hunchentoot:*acceptor*) asl :test #'string= :key #'car)))
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

