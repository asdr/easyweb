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

(defmacro defview (name &body rest &key url-pattern (arguments nil) &allow-other-keys)
    ;(format t "~S~%~S~%~S~%" name arguments (nthcdr 4 rest))
    (if (and (listp url-pattern)
	     (listp arguments)) ;; the first element of body must include list of arguments
	`(progn
	   
	   (defun ,name (,@(let ((ret (mapcar #'(lambda(arg)
						  (when (listp arg)
						    (setf (cadr arg)
							  (enclose-string (format nil "~A" (cadr arg)))))
						  arg)
					      arguments)))
				(when ret
				  (push '&key ret))))
	     ,@(nthcdr 4 rest))

	   (cl:export ',name)
	   
	   (define-url-patterns ""
	     (,url-pattern ,name)))))
