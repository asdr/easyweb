#| HTML Generation takes place ... |#
(in-package :common-lisp-user)

(defpackage :easyweb.html
  (:use #:cl #:dsgner)
  (:export #|#:a #:abbr #:acronym #:address #:applet #:b #:base #:basefont 
	   #:bdo #:big #:blockquote #:body #:br #:button #:caption #:center #:cite 
	   #:code #:col #:colgroup #:dd #:del #:dfn #:dir #:div #:dl #:dt #:em #:fieldset 
	   #:font #:form #:frame #:frameset #:h1 #:h2 #:h3 #:h4 #:h5 #:h6 #:head #:hr
	   #:html #:i #:iframe #:img #:input #:ins #:isindex #:kbd #:label #:legend #:li 
	   #:link #:map #:menu #:meta #:noframes #:noscript #:object #:ol #:optgroup
	   #:option #:p #:param #:pre #:q #:s #:samp #:script #:select #:small #:span 
	   #:strike #:strong #:style #:sub #:sup #:table #:tbody #:td #:textarea #:tfoot
	   #:th #:thead #:title #:tr #:tt #:u #:ul #::var #:xmp #:doctype #:<!--|#))
  
(in-package :easyweb.html)

(defmacro :doctype ((&key (type :xhtml1.0\:strict)) &body body)
  `(format nil "~A~A" 
	   ,(case type
	      (:html4.01\:strict
	       `"<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.01//EN\" \"http://www.w3.org/TR/html4/strict.dtd\">")
	      (:html4.01\:transitional
	       `"<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.01 Transitional//EN\" \"http://www.w3.org/TR/html4/loose.dtd\">")
	      (:html4.01\:frameset
	       `"<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.01 Frameset//EN\" \"http://www.w3.org/TR/html4/frameset.dtd\">")
	      (:xhtml1.0\:transitional
	       `"<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Transitional//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd\">")
	      (:xhtml1.0\:frameset
	       `"<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Frameset//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-frameset.dtd\">")
	      (:xhtml1.1
	       `"<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.1//EN\" \"http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd\">")
	      (otherwise
	       `"<!DOCTYPE html PUBLIC \"-//W3C//DTD XHTML 1.0 Strict//EN\" \"http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd\">"))
	   (progn
	     ,@body)))

(defmacro :<!-- ((&key (type :regular)) &body body)
  (let ((opentag "")
	(closetag "")
	(stream (gensym))
	(output (gensym)))
    (case type
      (:cdata
       (setf opentag "<![CDATA[")
       (setf closetag "]]>"))
      (otherwise
       (setf opentag "<!-- ")
       (setf closetag " -->")))
    `(let ((,output (dsgner::empty-string)))
       (with-output-to-string (,stream ,output)
	 (format ,stream "~A" ,opentag)
	 ,@(mapcar #'(lambda(e)
		       `(format ,stream "~A" ,e))
		   body)
	 (format ,stream "~A" ,closetag))
       ,output)))


;;define tags of HTML 4.01 / XHTML 1.0
(deftags :a :abbr :acronym :address :applet :b :base :basefont 
	 :bdo :big :blockquote :body :br :button :caption :center :cite 
	 :code :col :colgroup :dd :del :dfn :dir :div :dl :dt :em :fieldset 
	 :font :form :frame :frameset :h1 :h2 :h3 :h4 :h5 :h6 :head :hr
	 :html :i :iframe :img :input :ins :isindex :kbd :label :legend :li 
	 :link :map :menu :meta :noframes :noscript :object :ol :optgroup
	 :option :p :param :pre :q :s :samp :script :select :small :span 
	 :strike :strong :style :sub :sup :table :tbody :td :textarea :tfoot
	 :th :thead :title :tr :tt :u :ul :var :xmp)