(in-package :easyweb)

(defparameter *listen-address* "localhost")

(defparameter *listen-port* 8000) 

(defparameter *httpd* nil) 

(defparameter *swank-port* 4991)

(defparameter *swank* nil) 

(defun server-start (&key (port *listen-port*) (address *listen-address*))
  (setf *httpd* (hunchentoot:start (make-instance 'hunchentoot:acceptor 
						  :port port
						  :name "easyweb-default-acceptor"
						  #|:address address|#))))

(defun server-stop ()
  (hunchentoot:stop *httpd*)
  (setf *httpd* nil))

