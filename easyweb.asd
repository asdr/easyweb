(in-package :common-lisp-user)

(defpackage :easyweb-asd
  (:use #:cl #:asdf))

(in-package :easyweb-asd)

(defsystem #:easyweb
    :name "easyweb"
    :serial t
    :depends-on (#:dsgner
		 #:cl-ppcre
		 #:swank
		 #:hunchentoot
		 #:html-template)
    :components ((:file "defpackage")
		 (:file "util")
		 (:file "settings")
		 (:file "server")
		 (:file "application-handler")
		 (:file "misc")
		 (:file "application-util")
		 (:file "html")
		 (:file "initialize")))


