(in-package :common-lisp-user)

(defpackage :(% TMPL_VAR APPLICATION_NAME %).view
  (:use #:cl
	#:easyweb.html
	#:hunchentoot))

(in-package :(% TMPL_VAR APPLICATION_NAME %).view)

(let ((easyweb::*application-name* "(% TMPL_VAR APPLICATION_NAME %)"))
  (easyweb::defview index-page/get 
      :url-pattern (:prefix "/") 
      :arguments ()
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
  
  (easyweb::defview index-page/post 
      :url-pattern (:prefix "/")
      :arguments ((msg "asdr"))
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
  
  (easyweb::defview form 
      :url-pattern (:absolute "/form")
      :arguments ((url "(% TMPL_VAR APPLICATION_NAME %)"))
      (:doctype ()
		(:html ()
		       (:body ()
			      (:form (:action url
					      :method :post)
				     (:input (:type "textfield"
						    :name "msg"))
				     (:input (:type "submit"
						    :value "send"))))))))
