(in-package :easyweb)

(defmacro defview (name &key url-pattern (request-type :get) (defun '(() (format nil "default view"))) &allow-other-keys)
  (if (and (listp url-pattern)
	   (listp (car defun))) ;; the first element of body must include list of arguments
      
      `(progn
	 ;;define dispatcher function
	 (defun ,name (,@(let ((ret (mapcar #'(lambda(arg)
						(if (atom arg)
						    arg
						    `(,(car arg) (or (and (boundp 'hunchentoot:*request*)
									  (hunchentoot::compute-parameter (hunchentoot::compute-real-name ',(car arg))
													  'string
													  ,request-type))
								     ,(cadr arg)))))
					    (car defun))))
			      (when ret
				(push '&key ret))))
	   ,@(cdr defun))
	 
	 ;;export dispatcher function
	 (cl:export ',name)

	 ;;map url-pattern to dispatcher function
	 (define-url-patterns ""
	   (,url-pattern ,name)))))
