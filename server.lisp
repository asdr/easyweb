(in-package :easyweb)

(defstruct (easy-starter)
  "Easy Starter"
  acceptor
  applications)

(defparameter *acceptor-table* (make-hash-table :test #'equal)
  "Defined acceptors are kept.")

(defparameter *listen-address* nil
  "Listens connections from this address, if nil all ip address will be listened.")

(defparameter *listen-port* 8000)

(defparameter *httpd* nil) 

(defparameter *swank-port* 4991)


;;start swank server
;;(defparameter *swank*
;;  (swank:create-server :port *swank-port* :dont-close t))

(defun easy-starter-hash (address port)
  (format nil "~A" (cons address port)))

(defun get-easy-starter (&key (port *listen-port*) (address *listen-address*))
  (let ((key (easy-starter-hash address port))) 
    (or (gethash key *acceptor-table*)
	(setf (gethash key *acceptor-table*)
	      (make-easy-starter :acceptor (make-instance 'hunchentoot:acceptor 
							  :address address
							  :port port
							  :name key))))))
 ;(defmethod get-easy-starter (acceptor-name)
 ;  (gethash acceptor-name *acceptor-table*))


(defun get-acceptor (&key (port *listen-port*) (address *listen-address*))
  (let ((starter (get-easy-starter address port)))
    (when starter
      (easy-starter-acceptor starter))))

