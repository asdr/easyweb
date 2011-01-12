(in-package :common-lisp-user)

(defpackage :easyweb
  (:use #:cl #:hunchentoot)
  (:export #:link
           #:map-urls
	   #:start-server))

(in-package :easyweb)

;;static file dispatcher?
;;regex dispatcher?
;;prefix dispatcher?
;;folder dispatcher?
;;
;;GET and POST parameter pass??????
#|(defmacro map-urls (prefix &body mappings)
  (format t "~%~%URL Mapping")
  (and (every #'listp (mapcar #'identity mappings))
       (not (setf *dispatch-table* nil))
       (mapc #'(lambda(m)
		 (destructuring-bind (pattern . view) m
		   (format t "~%~S..::..~S" pattern view)
		   (push (create-regex-dispatcher (format nil "~A~A" prefix pattern) 
						  view)
			 *dispatch-table*)))
	     mappings)))

(defun mapping (prefix &rest mappings)
  (labels ((destruct-mapping (lst)
	     ;(format t "~A" lst)))
	     (destructuring-bind ((pattern pattern-type) (view params)) lst
	       (case pattern-type
		 (:file
		  (format t "file")
		  )
		 (:folder
		  (format t "folder")
		  )
		 (:prefix
		  (format t "prefix")
		  (push (create-prefix-dispatcher (format nil "~A~A" prefix pattern) 
						 view)
			*dispatch-table*))
		 (:regex
		  (format t "~%~S..::..~S" pattern view)
		  (push (create-regex-dispatcher (format nil "~A~A" prefix pattern) 
						 view)
			 *dispatch-table*)))
	       )))
	   (setf *dispatch-table* nil)
	   (mapc #'destruct-mapping mappings)))|#

(defun get-lambda-list (fn)
  ;;may be platform dependent code
  ;;but i still need it
  ;;return the parameter list of given function
  
  ;;as an aexample the output for url-handler is:
  (list (make-symbol "LINK")))
  
(defmacro map-urls (prefix &body body)
    `(progn
       ,@(mapcar #'(lambda (mapping)
                     (let* ((uri-part (car mapping))
                            (type (car uri-part))
                            (uri nil))
                       (case type
                         ((:regex :prefix :file :folder)
                          (let* ((handler (cadr mapping))
                                 (args (get-lambda-list handler))
                                 (uri (format nil "~A~A" prefix (cadr uri-part))))
                            `(define-easy-handler (,(gensym) :uri ,uri)
                                                  ,args
                                                  (,handler ,@(mapcan #'(lambda (arg)
									  `(,(hunchentoot::convert-parameter (string-downcase arg) 'keyword) ,arg))
								      args)))))
                         (:prefix "prefix")
                         (:file "file-")
                         (:folder "folder")
                         (otherwise "other"))))
                 body)))

(defun start-server (&key (port 8000))
  (defparameter *httpd* (start (make-instance 'acceptor :port port))))