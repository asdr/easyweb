(in-package :common-lisp-user)

(defpackage :easyweb-asd
  (:use #:cl #:asdf))

(in-package :easyweb-asd)

(defsystem #:easyweb
    :name "easyweb"
    :serial t
    :depends-on (#:dsgner #:hunchentoot)
    :components ((:file "easyweb")
		 (:file "html")))


