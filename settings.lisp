(in-package :common-lisp-user)

(defpackage :easyweb.settings
  (:use #:cl))

(in-package :easyweb.settings)

(defun build-hash-table (alist)
  (let ((ht (make-hash-table)))
    (dolist (pair alist ht)
      (setf (gethash (car pair) ht) (cdr pair)))))

;;available applications
(defparameter *use-applications*
  (build-hash-table '(
    ("prototype-app1" "/home/a