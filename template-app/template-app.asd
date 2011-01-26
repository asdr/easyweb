(in-package :common-lisp-user)

(defpackage :(% TMPL_VAR APPLICATION_NAME %)-asd
  (:use #:cl #:asdf))

(in-package :(% TMPL_VAR APPLICATION_NAME %)-asd)

(defsystem #:(% TMPL_VAR APPLICATION_NAME %)
    :name "(% TMPL_VAR APPLICATION_NAME %)"
    :version "0.1"

    :serial t
    :depends-on (#:easyweb 
		 #:hunchentoot)

    :components ((:file "_initialize")
		  ;(:file "_model")
		  ;(:file "_templates")
		  (:file "_view")
		  (:file "_settings")))
