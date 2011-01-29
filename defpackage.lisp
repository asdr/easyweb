(in-package :common-lisp-user)

(defpackage :easyweb
  (:use #:cl)
  (:export #:make-project
	   #:defview
	   #:define-url-patterns
	   #:server-start
	   #:server-stop))

(in-package :easyweb)
