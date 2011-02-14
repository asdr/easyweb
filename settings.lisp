(in-package :common-lisp-user)

(defpackage :easyweb.settings
  (:use #:cl)
  (:export #:+configuration-dir+
	   #:+default-application-dir+
	   #:+template-start-tag+
	   #:+template-end-tag+))

(in-package :easyweb.settings)

(defconstant +configuration-dir+ (merge-pathnames ".easyweb.d/" (user-homedir-pathname)))
(defconstant +default-application-dir+ (merge-pathnames "default-application/" +configuration-dir+))
(defconstant +template-start-tag+ "(%")
(defconstant +template-end-tag+ "%)")


;;html-template settings
(setf html-template:*template-start-marker* +template-start-tag+
      html-template:*template-end-marker* +template-end-tag+)

