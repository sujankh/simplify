(define simplify
  (lambda (exp)
      (cond
       ((not (list? exp)) exp) ;If it is not a binary expression return it without simplification       
       (else ;Its a binary expression
	(begin
	  (display exp)
	  (handleBinaryExpression exp)
	  )
	)
      )
    )
  )

(define handleBinaryExpression
  (lambda (exp)
    (let ((op (car exp)) (lhs (simplify (getlhs exp))) (rhs (simplify (getrhs exp))))
      (cond
       ((and (number? lhs) (number? rhs)) (reduce op lhs rhs)) ;1, 3, 5
       ((and (isTerm lhs) (number? rhs)) (swapNumberTerm op lhs rhs)) ;2, 4, 6
       ((matchRule78 op lhs rhs) (rule78 op lhs rhs))
       (else
	(let ((s1 (simplify lhs)) (s2 (simplify rhs)))
	  (if (and (equal? s1 lhs) (equal? s2 rhs))
	      (list op s1 s2) ;if the values do not change do not simplify
	      (simplify (list op s1 s2))
	      )
	  )))       
      )))
      
(define matchRule78
  (lambda (op lhs rhs)
    (and (isTerm lhs) (list? rhs) (eq? op (car rhs)) (or (eq? op '+) (eq? op '*)))
  ))

(define rule78
  (lambda (op t1 rhs)
    (let ((t2 (getlhs rhs)) (t3 (getrhs rhs)))
      (simplify (list op (list op t1 t2) t3))
      )
    )
  )

(define rule12
  (lambda (c1 rhs)
    (let ((c2 (getlhs rhs)) (t (getrhs rhs)))
      (simplify (list '+ (list '* c1 c2) (list '* c1 t)))
      )
    )
  )
  
(define swapNumberTerm
  (lambda (op t c)
    (if (eq? '- op)
	(list '+ (- 0 c) t)
	(list op c t)
	)
    )
  )

(define applyRule
  (lambda (rule lhs rhs)
    (rule (simplify lhs) (simplify rhs))
    )
  )

(define reduce
  (lambda (op n1 n2)
    (begin
      (display op)
      (case op
	('+ (+ n1 n2))
	('- (- n1 n2))
	('* (* n1 n2))
	)
      )
    )
  )


;;;an expression is a term if it is a list OR
;;;an expression is a term if it is a variable like x (a symbol)
(define isTerm
  (lambda (exp)
    (or (list? exp) (symbol? exp) (number? exp))
    )
  )

(define getlhs
  (lambda (exp)
    (cadr exp)
    )
  )

(define getrhs
  (lambda (exp)
    (car (cddr exp))
    )
  )
