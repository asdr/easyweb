(in-package :common-lisp-user)

(defpackage :prototype-app1.settings
  (:use #:cl
	#:easyweb
	#:prototype-app1.view))

(in-package :prototype-app1.settings)


;;url dispatching should occur here
(map-urls "/"
  ((:regex "asdr") open-link)
  ((:prefix "serdar") mervecigim)
  ((:prefix "merve") mervecigim)
  ((:file "tmp/fileX" "/home/admin-o/pjs/easyweb/tmp/filex.x" "text/plain"))
  ((:folder "tmp/" "/home/asdr/admin-o/pjs/easyweb/" "text/plain")))