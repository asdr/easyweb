(in-package :common-lisp-user)

(defpackage :easyweb-asd
  (:use #:cl #:asdf))

(in-package :easyweb-asd)

(defsystem #:easyweb
    :name "easyweb"
    :serial t
    :depends-on (#:dsgner
		 #:swank
		 #:hunchentoot
		 #:html-template)
    :components ((:file "defpackage")
		 (:file "util")
		 (:file "settings")
		 (:file "url-handler")
		 (:file "server")
		 (:file "easyweb")
		 (:file "project-util")
		 (:file "html")
		 (:file "initialize")))


