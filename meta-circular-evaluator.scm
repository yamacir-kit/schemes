(define null? (lambda (x)
  (eq? x ())
))

(null? 'a)
(null? ())

(define not (lambda (x)
  (if x #f #t)
))

(not #t)
(not #f)

(not (eq? 'a 'a))
(not (eq? 'a 'b))

(define and (lambda (x y)
  (if x
    (if y #t #f)
    #f)
))

(and (not (pair? 'a)) (eq? 'a 'a))
(and (not (pair? 'a)) (eq? 'a 'b))

(define append (lambda (x y)
  (if (null? x)
      y
      (cons (car x)
            (append (cdr x) y)))
))

(append '(a b) '(c d))
(append ()     '(c d))

(define list (lambda (x y)
  (cons x (cons y ()))))

(define zip (lambda (x y)
  (if (and (null? x) (null? y))
    ()
  (if (and (pair? x) (pair? y))
    (cons (list (car x) (car y))
          (zip  (cdr x) (cdr y)))
    ()
  ))
))

(zip '(x y z) '(a b c)); => ((x a) (y b) (z c))

(define caar (lambda (x) (car (car x))))
(define cadr (lambda (x) (car (cdr x))))
(define cadar (lambda (x) (car (cdr (car x)))))
(define caddr (lambda (x) (car (cdr (cdr x)))))
(define caddar (lambda (x) (car (cdr (cdr (car x))))))
(define cadddr (lambda (x) (car (cdr (cdr (cdr x))))))

(define assoc (lambda (x y)
  (if (null? x)
    ()
  (if (null? y)
    x
  (if (eq? (caar y) x)
    (cadar y)
    (assoc x (cdr y))
  )))
))

(assoc 'x '((x a) (y b))); => a
(assoc 'x '((x new) (x a) (y b))); => new

(define evcon (lambda (c a)
  (if (eval (caar c) a)
    (eval (cadar c) a)
    (evcon  (cdr c) a))
))

(define evlis (lambda (m a)
  (if (null? m)
    ()
    (cons (eval  (car m) a)
          (evlis (cdr m) a)))
))

(define eval (lambda (e a)
  (if (not (pair? e))
      (assoc e a)
  (if (not (pair? (car e)))
      (if (eq? (car e) 'quote)
          (cadr e)
      (if (eq? (car e) 'atom)
          (not (pair? (eval (cadr e) a)))
      (if (eq? (car e) 'eq)
          (eq? (eval (cadr  e) a)
               (eval (caddr e) a))
      (if (eq? (car e) 'car)
          (car (eval (cadr e) a))
      (if (eq? (car e) 'cdr)
          (cdr (eval (cadr e) a))
      (if (eq? (car e) 'cons)
          (cons (eval (cadr e) a) (eval (caddr e) a))
      (if (eq? (car e) 'cond)
          (evcon (cdr e) a)
          (eval (cons (assoc (car e) a) (cdr e)) a)
      )))))))
  (if (eq? (caar e) 'label)
      (eval (cons (caddar e) (cdr e)) (cons (list (cadar e) (car e)) a))
  (if (eq? (caar e) 'lambda)
      (eval (caddar e) (append (zip (cadar e) (evlis (cdr e) a)) a))
      'error
  ))))
))

(eval '(quote a) ())
(eval ''a ())
(eval '(quote (a b c)) ())

(eval '(atom 'a) ())
(eval '(atom (quote (a b c))) ())
(eval '(atom ()) ())
(eval '(atom (atom 'a)) ())
(eval '(atom (quote (atom 'a))) ())

(eval '(eq 'a 'a) ())
(eval '(eq 'a 'b) ())
(eval '(eq () ()) ())

(eval '(car '(a b c)) ())
(eval '(cdr '(a b c)) ())

(eval '(cons 'a '(b c)) ())
(eval '(cons 'a (cons 'b (cons 'c '()))) ())
(eval '(car (cons 'a '(b c))) ())
(eval '(cdr (cons 'a '(b c))) ())

(eval '(cond ((eq 'a 'b) 'first) ((atom 'a) 'second)) ())

(eval '((lambda (x) (cons x '(b))) 'a) ())
(eval '((lambda (x y) (cons x (cdr y))) 'z '(a b c)) ())
(eval '((lambda (f) (f '(b c))) '(lambda (x) (cons 'a x))) ())

(eval '((label subst (lambda (x y z)
          (cond ((atom z)
                 (cond ((eq z y) x) (#t z)))
                (#t
                 (cons (subst x y (car z))
                       (subst x y (cdr z)))))
        ))
        'm 'b '(a b (a b c) d)
      )
      ())

