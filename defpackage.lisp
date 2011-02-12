(in-package :common-lisp-user)

(defpackage :easyweb
  (:use #:cl)
  (:export ;;APPLICATION-HANDLER
           #:application-start
           #:application-load
	   #:application-unload
	   #:define-url-patterns

	   ;;APPLICATION-UTIL
	   #:make-application

	   ;;MISC
	   #:defview
	   	   
	   ;;SERVER
	   #:get-easy-starter
	   #:get-acceptor
	  
	   ))

(in-package :easyweb)
