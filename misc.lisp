(in-package :easyweb)

#|(defmacro defview (name inner-args (&rest arguments) &body body)
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
     
     (cl:export ',name cl:*package*)))|#

(defmacro defview (name &rest rest &key url-pattern)
  (let ((args (third rest))
	(body (fourth rest)))
    (format t "~S~%~S~%~S~%" name args body)
    (if (and (listp url-pattern)
	     (listp args)) ;; the first element of body must include list of arguments
	`(progn
	   
	   (defun ,name (,@(let ((ret (mapcar #'(lambda(arg)
						  (when (listp arg)
						    (setf (cadr arg)
							  (enclose-string (format nil "~A" (cadr arg)))))
						  arg)
					      args)))
				(when ret
				  (push '&key ret))))
	     (,@body))

	   (cl:export ',name)
	   
	   (define-url-patterns "/"
	     (,url-pattern ,name))))))
