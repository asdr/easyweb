(in-package :common-lisp-user)

(defpackage :easyweb.aserver
  (:use #:cl #:usocket))

(in-package :easyweb.aserver)

(defun handle-connection (stream)
  (format (socket-stream client-socket)
	  "~A"
	  (read-line (socket-stream client-socket)))
  (force-output (socket-stream client-socket)))

;a Simple echo server
(defun start-sequential ()
  (let ((server (socket-listen "localhost" 4499)))
    (do ()
	(nil)
      (let ((client-socket (socket-accept server)))
	(handle-connection (socket-accept server))))))

(defun start-threaded ()
  (let ((
