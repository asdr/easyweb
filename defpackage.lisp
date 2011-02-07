(in-package :common-lisp-user)

(defpackage :easyweb
  (:use #:cl)
  (:export #:easy-load-application
	   #:make-application
	   #:defview
	   #:define-url-patterns
	   #:server-start
	   #:server-stop))

(in-package :easyweb)
