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
    (let ((op (car exp)) (lhs (getlhs exp)) (rhs (getrhs exp)))
      (cond
       ((and (number? lhs) (number? rhs)) (reduce op lhs rhs)) ;1, 3, 5
       ((and (isTerm lhs) (number? rhs)) (swapNumberTerm op (simplify lhs) rhs)) ;2, 4, 6
       ((and (list? rhs))
	(let ((rhsOp (car rhs)))
	  (case op
	    ('+
	     (if (eq? '+ rhsOp) (applyRule rule7 lhs rhs))
	     )
	    ('*
	     (cond
	      ((eq? '* rhsOp) (applyRule rule8 lhs rhs))
	      ((eq? '+ rhsOp)
	      (if
		(and (number? lhs) (number? (getlhs rhs)))
	         (applyRule rule12 lhs rhs)
		 )
	      )
	      )
	     )
	    )
	  )
	)
       (else
	(let ((s1 (simplify lhs)) (s2 (simplify rhs)))
	  (if (and (equal? s1 lhs) (equal? s2 rhs))
	      (list op s1 s2) ;if the values do not change do not simplify
	      (simplify (list op s1 s2))
	      )
	  )))       
      )))
      
  (define rule7
    (lambda (t1 rhs)
      (let ((t2 (getlhs rhs)) (t3 (getrhs rhs)))
	(simplify (list '+ (list '+ t1 t2) t3))
	)
      )
)

(define rule8
  (lambda (t1 rhs)
    (let ((t2 (getlhs rhs)) (t3 (getrhs rhs)))
      (simplify (list '* (list '* t1 t2) t3))
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
    (or (list? exp) (symbol? exp))
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
