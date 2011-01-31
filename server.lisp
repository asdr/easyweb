(in-package :easyweb)

(defstruct (easy-starter)
  "Easy Starter"
  handle
  acceptor
  applications)

(defparameter *acceptor-table* (make-hash-table :test #'equal)
  "Defined acceptors are kept.")

(defparameter *listen-address* nil
  "Listens connections from this address, if nil all ip address will be listened.")

(defparameter *listen-port* 8000)

(defparameter *httpd* nil) 

(defparameter *swank-port* 4991)

(defparameter *swank* nil) 

(defun server-start (&key (port *listen-port*) (address *listen-address*))
  (setf *httpd* (hunchentoot:start (make-instance 'hunchentoot:acceptor 
						  :port port
						  :name "easyweb-default-acceptor"
						  :address address))))

(defun server-stop ()
  (hunchentoot:stop *httpd*)
  (setf *httpd* nil))

(defun get-easy-starter (&key (port *listen-port*) (address *listen-address*) name)
  (let ((key (format nil "~A" (cons address port))))
    (or (gethash key *acceptor-table*)
	(setf (gethash key *acceptor-table*)
	      (make-easy-starter :acceptor (make-instance 'hunchentoot:acceptor 
							  :address address
							  :port port
							  :name name))))))

(defun application-start (application-name &key (port *listen-port*) (address *listen-address*))
  (when application-name
    (let ((starter (get-easy-starter :address address
				     :port port)))
      )))