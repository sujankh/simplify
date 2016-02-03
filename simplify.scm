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
       ((and (number? e1) (number? e2)) (reduce op e1 e2))
       (else
	(let ((s1 (simplify e1)) (s2 (simplify e2)))
	  (simplify (list op s1 s2))
	  )	      
       )
      )
    )
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
