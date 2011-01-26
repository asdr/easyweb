(in-package :common-lisp-user)

(defpackage :(% TMPL_VAR APPLICATION_NAME %).view
  (:use #:cl
	#:easyweb.html
	#:hunchentoot))

(in-package :(% TMPL_VAR APPLICATION_NAME %).view)

(defmacro defview (name (&rest arguments) &body body)
  `(easyweb:defview ,name arguments ,arguments ,@body))

;; abow code can/should be inserted dynamically

(defview index-page/get ()
  (:doctype ()
    (:html ()
      (:head ()
	(:title ()
	  "Welcome to le-jango project!"))
      (:body (:font-color "green")
	(:p ()
	  (:h2 ()
	    "Hello, world! le-jango is working...")
	  (:h4 ()
	    "GET"))
	(:p ()
	  (:br ())
	  "For more information, go on and jump into "
	  (:a (:href "http://localhost/le-jango/docs.html")
	      "tutorials")
	  " page.")))))

(defview index-page/post ((msg "asdr"))
  (:doctype ()
    (:html ()
      (:head ()
	(:title ()
	  "Welcome to le-jango project!"))
      (:body (:font-color "green")
	(:p ()
	  (:h2 ()
	    "Hello, world! le-jango is working...")
	  (:h4 ()
	    "POST: "
	    msg))
	(:p ()
	  (:br ())
	  "For more information, go on and jump into "
	  (:a (:href "http://localhost/le-jango/docs.html")
	      "tutorials")
	  " page.")))))

(defview open-link ((link "http://localhost:8000/"))
  (:doctype ()
    (:html ()
      (:head ()
	(:title ()
	  "Links..."))
      (:body ()
	(:a (:href link)
	  "the link")))))

(defview mervecigim ()
  (:html ()
    (:head ()
      (:script (:type "text/javascript")
	"function upper() { "
	"  key = window.event.keyCode;"
	"  window.event.keyCode = key-32; "
	"}"))
    (:body ()
      (:form ()
	     (:input (:type "text" 
			    :onkeyup "javascript:this.value=this.value.toUpperCase();"))))))

(defview argtest ((arg0 "arg0") arg1 (arg2 123))
  (:html ()
    (:body ()
      (:p ()
	(let ((ret ""))
	  (loop for arg in arguments
	     do (setf ret (format nil "~A~A" ret (:h3 () arg))))
	  ret))
      (:p ()
	"Request Method: "
	(request-method *request*)))))

(defview form ((url "/pap1/"))
  (:doctype ()
    (:html ()
      (:body ()
	(:form (:action url
		:method :post)
	  (:input (:type "textfield"
		   :name "msg"))
	  (:input (:type "submit"
		   :value "send")))))))

(defview template1/get ()
  (:doctype ()
    (:html ()
      (:body ()
	(:form (:action :__self__))))))
