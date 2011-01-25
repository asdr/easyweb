(in-package :common-lisp-user)

(defpackage :easyweb.aserver
  (:use #:cl #:usocket))

(in-package :easyweb.aserver)

(defun handle-connection (stream)
  (princ (read-line stream) stream)
  (princ (code-char 13) stream)
  (princ (code-char 10) stream))

;a Simple echo server
(defun start-sequential ()
  (let ((server (socket-listen "localhost" 4499)))
    (do ()
	(nil)
      (let ((client-socket (socket-accept server)))
	(handle-connection (socket-stream client-socket)))))

(defun start-threaded ()
  (let ((server (socket-listen "localhost" 4499)))
    (do ()
	(nil)
      (let ((client-socket (socket-accept server)))
	(let ((thread (sb-thread:make-thread (lambda()
					       (let ((stream (socket-stream client-socket)))
						 (handle-connection stream)
						 (socket-close client-socket)))))))))
    (socket-close server)))
