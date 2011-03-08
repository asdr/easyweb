(in-package :common-lisp-user)

(defpackage :(% TMPL_VAR APPLICATION_NAME %).settings
  (:use #:cl
	#:easyweb
	#:(% TMPL_VAR APPLICATION_NAME %).view))

(in-package :(% TMPL_VAR APPLICATION_NAME %).settings)

;;bound application name as
(let ((easyweb::*application-name* "(% TMPL_VAR APPLICATION_NAME %)"))
  #|(define-url-patterns "/(% TMPL_VAR APPLICATION_NAME %)/"
      ((:prefix "") index-page/get)
      ((:prefix "") index-page/post)
      ((:absolute "form") form)
      ((:absolute "argtest") argtest)
      ((:absolute "template1") template1/get)
      ((:regex "asdr[0-9]+$") mervecigim))|#


  ;;view resolver defines the view (template) files & paths
  #|(define-view-resolver
      (:path "/lsp" :file-matches "*.lsp")
      (:path "/jsp" :file-matches "**/*.jsp"))|#
)

