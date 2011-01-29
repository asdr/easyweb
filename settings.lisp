(in-package :common-lisp-user)

(defpackage :easyweb.settings
  (:use #:cl)
  (:export #:*template-directory*))

(in-package :easyweb.settings)

(defparameter *template-directory* "template")
(defparameter *template-start-tag* "(%")
(defparameter *template-end-tag* "%)")


;;html-template settings
(setf html-template:*template-start-marker* *template-start-tag*
      html-template:*template-end-marker* *template-end-tag*)

