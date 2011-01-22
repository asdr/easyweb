(defpackage :prototype-app1
  (:use #:cl #:easyweb))

(in-package :prototype-app1)

;;load template files
;;once you load a template file it's created and 
;;changes wont affect by other loads
;;