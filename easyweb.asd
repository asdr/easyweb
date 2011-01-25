(in-package :common-lisp-user)

(defpackage :easyweb-asd
  (:use #:cl #:asdf))

(in-package :easyweb-asd)

(defsystem #:easyweb
    :name "easyweb"
    :serial t
    :depends-on (#:dsgner
		 #:hunchentoot
		 #:html-template)
    :components ((:file "util")
		 (:file "url-handler") ;;url-handling and dispatching for hunchentoot
		 (:file "defpackage")
		 (:file "settings")
		 (:file "server")
		 (:file "easyweb")
		 (:file "project-util")
		 (:file "html")
		 (:file "initialize")))


