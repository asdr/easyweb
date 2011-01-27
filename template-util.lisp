(in-package :easyweb)

(defvar *atemplate-reader* '(path printer variables))
(defparameter *template-cache* (make-hash-table :test #'string=))

(defun use-template (path &rest variables)
  (let ((template (gethash path *template-cache*)))
    (unless template
      (multiple-value-bind (dir file)
	  (seperate-path path)
	(setf template (setf (gethash path *template-cache*)
			     (list path 
				   (html-template:create-template-printer (make-pathname
									   :directory dir
									   :name file))
				   variables)))))
    template))