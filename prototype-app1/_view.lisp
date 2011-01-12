(in-package :common-lisp-user)

(defpackage :prototype-app1.view
  (:use #:cl
	#:easyweb.html)
  (:export #:index-page
	   #:open-link
	   #:mervecigim))

(in-package :prototype-app1.view)

;; abow code can/should be inserted dynamically

(defun index-page ()
  (:doctype ()
    (:html ()
      (:head ()
	(:title ()
	  "Welcome to le-jango project!"))
      (:body (:font-color "green")
	(:p ()
	  (:h2 ()
	    "Hello, world! le-jango is working..."))
	(:p ()
	  (:br ())
	  "For more information, go on and click onto "
	  (:a (:href "http://localhost/le-jango/docs.html")
	      "tutorials")
	  " page.")))))

(defun open-link (&key (link "http://localhost:8000/"))
  (:doctype ()
    (:html ()
      (:head ()
	(:title ()
	  "Links..."))
      (:body ()
	(:a (:href link)
	  "the link")))))

(defun mervecigim ()
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
		      :onkeydown "javascript:this.value=this.value.toUpperCase();"
		      :onkeyup "javascript:this.value=this.value.toUpperCase();"
		      :onBlur "javascript:this.value=this.value.toUpperCase();"
		      :onclick "javascript:this.value=this.value.toUpperCase();"))))))