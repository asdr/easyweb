(in-package :easyweb)

#|
(defparameter *starter-applications* '(("easyweb-default" . nil)))

(defun quickload-available-applications ()
  (dolist (application easyweb.settings:*available-applications*)
    (when (and application
	       (null (cdr application)))
      
      ;; causes recursive infinite loop 
      ;; i should find another solution
      ;;quicklisp-loading 
      ;;(ql:quickload (car application)))))
      ))
  t)

(defun set-application-loaded (application-name)
  (let ((application (find application-name
			   easyweb.settings:*available-applications*
			   :test #'string=
			   :key #'car)))
    (when application
      (setf (cdr application)
	    (cons t nil)))))|#
  
(defmacro defview (name inner-args (&rest arguments) &body body)
  `(progn 
     (defun ,name (&rest ,inner-args ,@(let ((ret (mapcar #'(lambda(arg)
							      (when (listp arg)
								(setf (cadr arg)
								      (enclose-string (format nil "~A" (cadr arg)))))
							      arg)
							  arguments)))
					    (when ret
					      (push '&key ret))))
       
       
       ,@body)
     
     (cl:export ',name cl:*package*)))

