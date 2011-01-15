(in-package :common-lisp-user)

(defpackage :easyweb
  (:use #:cl #:hunchentoot)
  (:export #:map-urls
	   #:server-start
	   #:server-stop))

(in-package :easyweb)

(defun get-lambda-list (fn)
  ;;may be platform dependent code
  ;;but i still need it
  ;;return the parameter list of given function
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
    lambda-list))

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
                                 (args nil #|(get-lambda-list handler)|#)
                                 (uri (format nil "~A~A" prefix (cadr uri-part))))
                            `(define-easy-handler (,(gensym) :uri ,uri)
                                                  ,args
                                                  (,handler ,@(mapcan #'(lambda (arg)
									  `(,(hunchentoot::convert-parameter (string-downcase arg) 'keyword) ,arg))
								      args))))))))
                 body)))

(defun server-start (&key (port 8000))
  (defparameter *httpd* (start (make-instance 'acceptor :port port))))

(defun server-stop ()
  (stop *httpd*)
  (setf *httpd* nil))