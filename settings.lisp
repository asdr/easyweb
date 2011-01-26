(in-package :common-lisp-user)

(defpackage :easyweb.settings
  (:use #:cl)
  (:export #:*available-applications*
	   #:*template-directory*))

(in-package :easyweb)

(defun set-application-loaded (application-name)
  (let ((application (find application-name
			   easyweb.settings:*available-applications*
			   :test #'string=
			   :key #'car)))
    (when application
      (setf (cdr application)
	    (cons t nil)))))

(cl:export 'set-application-loaded) 

(in-package :easyweb.settings)

(defparameter *template-directory* "template")
(defparameter *template-start-tag* "(%")
(defparameter *template-end-tag* "%)")


;;html-template settings
(setf html-template:*template-start-marker* *template-start-tag*
      html-template:*template-end-marker* *template-end-tag*)

(defparameter *use-available-check* nil)

(defparameter *available-applications* 
  (vector '("test3" . nil)
	  '("easyweb-default" . nil)
	  '("prototype-app1" . nil)))
	  




