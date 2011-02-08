(in-package :easyweb)

(defparameter *application-contexts* nil)

(defstruct (application-context
	     (:conc-name context-))
  name
  mappings
  loaded-p nil)

(defstruct (url-mapping
	     (:conc-name mapping-))
  uri
  acceptor-names
  handler
  request-method)

(defmacro define-url-patterns (prefix &body body)
  