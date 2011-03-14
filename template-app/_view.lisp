(in-package :common-lisp-user)

(defpackage :(% TMPL_VAR APPLICATION_NAME %).view
  (:use #:cl
	#:easyweb
	#:easyweb.html
	#:hunchentoot))

(in-package :(% TMPL_VAR APPLICATION_NAME %).view)

(let ((easyweb::*application-name* "(% TMPL_VAR APPLICATION_NAME %)"))
  (defview index-page/get 
      :url-pattern (:prefix "/")
      :request-type :GET
      :defun (((name "mervecigim")) (:doctype ()
				      (:html ()
					(:head ()
					  (:title ()
					    "Welcome to le-jango project!"))
					(:body (:font-color "green")
					  (:p ()
					    (:h2 ()
					      "Hello, world! le-jango is working...")
					    (:h4 ()
					      "GET: "
					      (format nil "~A" name)))
					  (:p ()
					    (:br ())
					    "For more information, go on and jump into "
					    (:a (:href "http://localhost/le-jango/docs.html")
					      "tutorials")
					    " page."))))))
  
  (defview index-page/post 
      :url-pattern (:prefix "/")
      :request-type :POST
      :defun (((msg "asdr")) (:doctype ()
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
				    " page."))))))
  
  (defview form 
      :url-pattern (:absolute "/form")
      :request-type :BOTH
      :defun (((url "(% TMPL_VAR APPLICATION_NAME %)")) (:doctype ()
							 (:html ()
							   (:body ()
							     (:form (:action url
									     :method :post)
							       (:input (:type "textfield"
									      :name "msg"))
							       (:input (:type "submit"
									      :value "send")))))))))
