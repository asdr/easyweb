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

(defmacro defview (name &key url-pattern &body body)
  (if (and (listp url-pattern)
	   (listp (car body))) ;; the first element of body must include list of arguments
      `(let ()
	 (defun ,name (,@(let ((ret (mapcar #'(lambda(arg)
						(when (listp arg)
						  (setf (cadr arg)
							(enclose-string (format nil "~A" (cadr arg)))))
						arg)
					   (car body))))
			      (when ret
				(push '&key ret))))
	   ,@(cadr body))
	 
	 (cl:export ',name)

	 (define-url-patterns ""
	     (,url-pattern ',name)))))
