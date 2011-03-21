(in-package :common-lisp-user)

(defpackage :easyweb.settings
  (:use #:cl)
  (:export #:*configuration-dir*
	   #:*template-start-tag*
	   #:*template-end-tag*))

(in-package :easyweb.settings)

(defvar *configuration-dir* (merge-pathnames ".easyweb.d/" (user-homedir-pathname)))
(defparameter *template-start-tag* "(%")
(defparameter *template-end-tag* "%)")


;;html-template settings
(setf html-template:*template-start-marker* *template-start-tag*
      html-template:*template-end-marker* *template-end-tag*)

