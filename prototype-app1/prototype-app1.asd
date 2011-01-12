(in-package :common-lisp-user)

(defpackage :prototype-app1-asd
  (:use #:cl #:asdf))

(in-package :prototype-app1-asd)

(defsystem #:prototype-app1
    :name "prototype-app1"
    :version "0.1"

    :serial t
    :depends-on (#:easyweb 
		 #:hunchentoot)

    :components ((:file "_initialize")
		 ;(:file "_model")
		 ;(:file "_templates")
		 (:file "_view")
		 (:file "_settings")))
