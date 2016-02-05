(define simplify
  (lambda (exp)
      (cond
       ((not (list? exp)) exp) ;If it is not a binary expression return it without simplification       
       (else ;Its a binary expression
	(let ((s (handleBinaryExpression exp)))
	  (if (equal? s exp) exp (simplify s)) ;run until a fixed point is reached 
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
       ;9, 10 same as 7, 8 after applying 2
       ;11, 13, 15 same as 12, 14, 16 after applying 2
       ((matchRule121416 op lhs rhs) (rule121416 op lhs rhs))
       ((matchRule17 op lhs rhs) (rule17 op lhs rhs))
       ((matchRule18 op lhs rhs) (rule18 op lhs rhs))
       ((matchRule19 op lhs rhs) (rule19 op lhs rhs))
       ((matchRule20 op lhs rhs) (rule20 op lhs rhs))
       (else
	(list op lhs rhs) 
	)))))
      
(define matchRule78
  (lambda (op lhs rhs)
    (and (isTerm lhs) (list? rhs) (eq? op (car rhs)) (or (eq? op '+) (eq? op '*)))
  ))

(define rule78
  (lambda (op t1 rhs)
    (let ((t2 (getlhs rhs)) (t3 (getrhs rhs)))
      (list op (list op t1 t2) t3)
      )
    )
  )

(define matchRule121416
  (lambda (op lhs rhs)
    (and (eq? op '*) (number? lhs) (list? rhs) (not (eq? op (car rhs))))
    )
  )

(define rule121416
  (lambda (op c rhs)
    (let ((op1 (car rhs)) (c2t2 (getlhs rhs)) (c3t3 (getrhs rhs)))
      (list op1 (list op c c2t2) (list op c c3t3))
      )
    )
  )

(define matchRule17
  (lambda (op lhs rhs)
    (and (eq? op '*) (list? lhs) (eq? (car lhs) '+) (isTerm rhs))
    )
  )

(define rule17
  (lambda (op lhs t3)
    (let ((t1 (getlhs lhs)) (t2 (getrhs lhs)))
      (list '+ (list '* t1 t3) (list '* t2 t3)))
    )
    )

(define matchRule18
  (lambda (op lhs rhs)
    (and (eq? op '*) (list? rhs) (eq? '+ (car rhs)))
    )
  )

(define rule18
  (lambda (op t1 rhs)
    (let ((t2 (getlhs rhs)) (t3 (getrhs rhs)))
      (list '+ (list '* t1 t2) (list '* t1 t3))
    )
    )
  )

(define matchRule19
  (lambda (op lhs rhs)
    (and (eq? '* op) (list? lhs) (eq? (car lhs) '-))
    )
  )

(define rule19
  (lambda (op lhs t3)
    (let ((t1 (getlhs lhs)) (t2 (getrhs lhs)))
      (list '- (list '* t1 t3) (list '* t2 t3))
    )
    )
  )

(define matchRule20
  (lambda (op lhs rhs)
    (and (eq? '* op) (list? rhs) (eq? (car rhs) '-))
    )
  )

(define rule20
  (lambda (op t1 rhs)
    (let ((t2 (getlhs rhs)) (t3 (getrhs rhs)))
      (list '- (list '* t1 t2) (list '* t1 t3))
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

(define reduce
  (lambda (op n1 n2)
    (begin
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
