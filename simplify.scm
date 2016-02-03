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
    (let ((op (car exp)) (e1 (getlhs exp)) (e2 (getrhs exp)))
      (cond
       ((eq? op '*) (simplifyMultiplication e1 e2))
       ((and (isTerm e1) (number? e2)) (swapNumberTerm op e1 e2)) ;2, 4, 6
       ((and (number? e1) (number? e2)) (reduce op e1 e2)) ;1, 3, 5
       (else
	(let ((s1 (simplify e1)) (s2 (simplify e2)))
	  (simplify (list op s1 s2))
	  )	      
       )
      )
    )
    )
  )

(define simplifyMultiplication
  (lambda (t1 t2)
    (
     
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
