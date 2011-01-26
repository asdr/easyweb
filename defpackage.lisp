(in-package :common-lisp-user)

(defpackage :easyweb
  (:use #:cl
	#:easyweb.util
	#:hunchentoot)
  (:export #:make-project
	   #:defview
	   #:define-url-patterns
	   #:server-start
	   #:server-stop))
