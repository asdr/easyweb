(in-package :common-lisp-user)

(defpackage :prototype-app1.settings
  (:use #:cl
	#:easyweb
	#:prototype-app1.view))

(in-package :prototype-app1.settings)

;;bound application name as
(let ((easyweb::*application-name* "prototype-app1"))
  (define-url-patterns "/pap1/"
      ((:prefix "") index-page/get)
      ((:prefix "") index-page/post)
      ((:absolute "form") form)
      ((:absolute "argtest") argtest)
      ((:absolute "template1") template1/get)
      ((:regex "asdr[0-9]+$") mervecigim))
  
  
  (set-application-loaded easyweb::*application-name*))
    