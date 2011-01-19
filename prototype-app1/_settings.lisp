(in-package :common-lisp-user)

(defpackage :prototype-app1.settings
  (:use #:cl
	#:easyweb
	#:prototype-app1.view))

(in-package :prototype-app1.settings)


;;URLs
(map-all-urls "/"
  ((:std "") index-page)
;  ((:std "asdr") open-link)
  ((:std "argtest") argtest))
;  ((:prefix "serdar") mervecigim)
;  ((:std "merve") mervecigim))
;  ((:file "tmp/fileX" "/home/admin-o/pjs/easyweb/tmp/filex.x" "text/plain"))
;  ((:folder "tmp/" "/home/asdr/admin-o/pjs/easyweb/" "text/plain")))