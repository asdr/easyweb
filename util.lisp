(in-package :common-lisp-user)

(defpackage :easyweb.util
  (:use #:cl)
  (:export #:enclose-string
	   #:null-value-check))

(in-package :easyweb.util)

;;in order to get around the issue with "describe" function,
;;strings must be enclosed with double-quotes.
(defun enclose-string (str)
  (format nil "\"~A\"" str))

(defun null-value-check (argument default-value)
  (if (null argument)
      default-value
      argument))