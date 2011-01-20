;;here are the initilization of easyweb environment
(in-package :easyweb)

(setf hunchentoot:*show-lisp-errors-p* t
      hunchentoot:*show-lisp-backtraces-p* t)

;;set our new dispatcher to hunchentoot
(setf hunchentoot:*dispatch-table* (list #'hunchentoot:dispatch-url-handlers))