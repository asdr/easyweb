;;here are the initilization of easyweb environment
(in-package :easyweb)

;;ensure ~/*configuration-dir* exists
;;if doesnt exist create and load default setting into it
(when (ensure-directories-exist easyweb.settings:*configuration-dir*)
  (let ((configuration-file-path (probe-file (merge-pathnames "easyweb.conf" easyweb.settings:*configuration-dir*))))
    (let ((installation-path (asdf:component-pathname (asdf:find-system :easyweb))))
      (defvar *template-application-dir* (merge-pathnames "template-app/"
							  installation-path)))))
	


(setf hunchentoot:*show-lisp-errors-p* t
      hunchentoot:*show-lisp-backtraces-p* t)

;;set our new dispatcher to hunchentoot
(setf hunchentoot:*dispatch-table* (list #'dispatch-url-handlers))

;;load available applications
;;(quickload-available-applications )
