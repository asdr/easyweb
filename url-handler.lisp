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
  "Handlers are stored in this list.")

(defun dispatch-url-handlers (request)
  (loop for ((uri-type . uri-content) acceptor-names easy-handler) in *url-handlers*
     when (and (or (eq acceptor-names t)
		   (find (acceptor-name *acceptor*) acceptor-names :test #'eq))
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
					   (or (equal ,(cdr uri) (cdr (first list)))
					       (eq ',name (third list))))
				       *url-handlers*))
       (push (list ',uri ,acceptor-names ',name) *url-handlers*)
       
       (defun ,name (&key ,@(loop for part in lambda-list
			       collect (make-defun-parameter part
							     default-parameter-type
							     default-request-type)))
         ,@body))))

(export 'dispatch-url-handlers)
(export 'define-url-handler)
