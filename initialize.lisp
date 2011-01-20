;;here are the initilization of easyweb environment
(in-package :easyweb)

;;set our new dispatcher to hunchentoot
(setf hunchentoot:*dispatch-table* (list #'hunchentoot:dispatch-url-handlers))