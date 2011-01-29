(in-package :hunchentoot)

(defclass epoll-taskmaster (taskmaster)
  (#+:easyweb
   (acceptor-process :accessor acceptor-process
		     :documentation "A process that accepts incoming
connections and hands them off for epoll system calls."))
  (:documentation "A taskmaster that starts one thread for listening
to incoming requests, and uses epoll system calls for each incoming 
connection."))

