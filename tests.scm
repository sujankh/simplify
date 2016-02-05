(define check
  (lambda (input expected)
    (assert (equal? (simplify input) expected))
    )
  )
  
(check '(+ 5 (+ 6 8)) 19)
(check '(+ x (+ y z)) '(+ (+ x y) z))
(check '(* (- v 2) ( * t2 t3)) ' (+ (* (* -2 t2) t3) (* (* v t2) t3)))
(check '(* (+ 2 (+ 3 4)) 5) 45)
(check '(+ 2 (+ a 3)) '(+ 5 a))
(check '(+ a 3) '(+ 3 a))
(check '(+ 1 (* 2 3)) 7)
(check '(+ 1 2) 3)

(check '(+ t1 (+ t2 t3)) '(+ (+ t1 t2) t3)) ;test7
(check '(* t1 (* t2 t3)) '(* (* t1 t2) t3)) ;test8
(check '(+ (+ 5 t) 7)  '(+ 12 t))           ;test9
(check '(* (* 5 t) 4) '(* 20 t)) ;test10
(check '(* (+ 9 t) 2) '(+ 18 (* 2 t)))
(check '(* 5 (+ 7 t)) '(+ 35 (* 5 t))) ;(∗c1 (+c2 t)) → (+(∗c1 c2)(∗c1 t))
(check '(* (+ t1 t2) 5) '(+ (* 5 t1)(* 5 t2)))  ;(∗(+t1 t2)c) → (+(∗ct1)(∗ct2))
(check '(* 10 (+ t1 t2)) '(+ (* 10 t1)(* 10 t2)))    ;(∗c(+t1 t2)) → (+(∗ct1)(∗ct2))
(check '(* (+ a b) c) '(+ (* a c) (* b c))) ;test17
(check '(* (- a b) c) '(- (* a c) (* b c))) ;test19
(check '(* a (+ b c)) '(+ (* a b) (* a c))) ;rule18
(check '(* a (- b c)) '(- (* a b) (* a c))) ;rule20
