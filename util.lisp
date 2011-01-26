(in-package :common-lisp-user)

(defpackage :easyweb.util
  (:use #:cl)
  (:export #:enclose-string
	   #:null-value-check))

(in-package :easyweb.util)

;;in order to get around the issue with "describe" function,
;;strings must be enclosed with double-quotes.
(defun enclose-string (str)
  (format nil "\"~A\"" str))

(defun null-value-check (argument default-value)
  (if (null argument)
      default-value
      argument))


(defun macroexpand-tree (tree) 
  (setq tree (macroexpand tree)) 
  (if (atom tree) 
      tree
      (mapcar #'macroexpand-tree tree)))


#| - LET OVER LAMBDA UTILITIES - 
(defun mkstr (&rest args)
  (with-output-to-string (s)
    (dolist (a args) (princ a s))))

(defun symb (&rest args)
  (values (intern (apply #'mkstr args))))

(defun group (source n)
  (if (zerop n) (error "zero length"))
  (labels ((rec (source acc)
             (let ((rest (nthcdr n source)))
               (if (consp rest)
                   (rec rest (cons
			      (subseq source 0 n)
			      acc))
                   (nreverse
		    (cons source acc))))))
    (if source (rec source nil) nil)))

(defun flatten (x)
  (labels ((rec (x acc)
             (cond ((null x) acc)
                   ((atom x) (cons x acc))
                   (t (rec
		       (car x)
		       (rec (cdr x) acc))))))
    (rec x nil)))

(defun g!-symbol-p (s)
  (and (symbolp s)
       (> (length (symbol-name s)) 2)
       (string= (symbol-name s)
                "G!"
                :start1 0
                :end1 2)))

(defmacro defmacro/g! (name args &rest body)
  (let ((syms (remove-duplicates
                (remove-if-not #'g!-symbol-p
                               (flatten body)))))
    `(defmacro ,name ,args
       (let ,(mapcar
               (lambda (s)
                 `(,s (gensym ,(subseq
                                 (symbol-name s)
                                 2))))
               syms)
         ,@body))))

(defun o!-symbol-p (s)
  (and (symbolp s)
       (> (length (symbol-name s)) 2)
       (string= (symbol-name s)
                "O!"
                :start1 0
                :end1 2)))

(defun o!-symbol-to-g!-symbol (s)
  (symb "G!"
        (subseq (symbol-name s) 2)))

(defmacro defmacro! (name args &rest body)
  (let* ((os (remove-if-not #'o!-symbol-p args))
         (gs (mapcar #'o!-symbol-to-g!-symbol os)))
    `(defmacro/g! ,name ,args
       `(let ,(mapcar #'list (list ,@gs) (list ,@os))
          ,(progn ,@body)))))

;;EXAMPLE#1
(defmacro! square (o!x)
  `(progn
     (format t "[~A gave ~A]~%" ',o!x ,g!x)
     (* ,g!x ,g!x)))
|#
