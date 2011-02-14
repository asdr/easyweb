;;here are the initilization of easyweb environment
(in-package :easyweb)

;;ensure ~/*configuration-dir* exists
;;if doesnt exist create and load default setting into it
(let ((configuration-file-path (probe-file (merge-pathnames "easyweb.conf" easyweb.settings:+configuration-dir+))))
  (unless (cl-fad:directory-exists-p easyweb.settings:+default-application-dir+)
    (when (ensure-directories-exist easyweb.settings:+default-application-dir+)
      (let* ((installation-path (asdf:component-pathname (asdf:find-system :easyweb)))
	     (default-application-source (merge-pathnames "template-app/"
							  installation-path)))
	(cl-fad:walk-directory default-application-source #'(lambda(file)
							      (cl-fad:copy-file file 
										(merge-pathnames (concatenate 'string
													      (pathname-name file)
													      "."
													      (pathname-type file))
												 easyweb.settings:+default-application-dir+))))))))

      

(setf hunchentoot:*show-lisp-errors-p* t
      hunchentoot:*show-lisp-backtraces-p* t)

;;set our new dispatcher to hunchentoot
(setf hunchentoot:*dispatch-table* (list #'dispatch-url-handlers))

;;load available applications
;;(quickload-available-applications )
