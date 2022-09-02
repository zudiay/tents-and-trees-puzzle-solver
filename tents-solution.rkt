#lang scheme

; returns if two coordinates are adjacent, including diagonals
(define (ADJACENT a b)
  (cond [(< (- (cadr a) (cadr b)) -1) #f]
        [(> (- (cadr a) (cadr b)) 1) #f]
        [(< (- (car a) (car b)) -1) #f]
        [(> (- (car a) (car b)) 1) #f]
        [else #t]))

; returns if the given coordinate is adjacent with at least one of the coordinates in list
(define (ADJACENT-WITH-LIST a list)
  ( cond [(null? list) #f]
         [(ADJACENT a (car list)) #t]
         [else (ADJACENT-WITH-LIST a (cdr list))]))

; returns if two coordinates are neighbors, excluding diagonals
(define (NEIGHBOR a b)
  (cond [(and (eqv? (car a) (car b)) (eqv? (- (cadr a) (cadr b)) 1)) #t]
        [(and (eqv? (car a) (car b)) (eqv? (- (cadr a) (cadr b)) -1)) #t]
        [(and (eqv? (cadr a) (cadr b)) (eqv? (- (car a) (car b)) -1)) #t]
        [(and (eqv? (cadr a) (cadr b)) (eqv? (- (car a) (car b)) 1)) #t]
        [else #f]))

; returns neighbor-list for a pair, excluding diagonals
(define (NEIGHBOR-LIST a)
  (list
         ( list (car a) (+ (cadr a) 1))
         ( list (+ (car a) 1) (cadr a))
         ( list (car a) (- (cadr a) 1))
         ( list (- (car a) 1) (cadr a))))

; returns list of neighbors of all the elements in the list
(define (NEIGHBOR-LIST-LIST neig list)
  (if (zero? (length list))
      neig
      (NEIGHBOR-LIST-LIST (append neig (NEIGHBOR-LIST (car list))) (cdr list))))

; returns if the given coordinate is neighbor with at least one of the coordinates in list
(define (NEIGHBOR-WITH-LIST a list)
  ( cond [(null? list) #f]
         [(NEIGHBOR a (car list)) #t]
         [else (NEIGHBOR-WITH-LIST a (cdr list))]))


; returns the nth element of a list
(define (GET-NTH n list)
  (cond [(<= n 0) #f]
        [(> n (length list)) #f]
        [(eq? n 1) (car list)]
        [else (GET-NTH (- n 1) (cdr list))]))

; replaces nth element of the list 
(define (REPLACE-NTH list n x)
  ( cond [(= n 1) (cons x (cdr list))]
         [#t (cons (car list) (REPLACE-NTH (cdr list) (- n 1) x))]))

; decreases nth element of the list by one
(define (DECREASE-NTH-ONE list n)
  (REPLACE-NTH list n (- (GET-NTH n list) 1)))

; returns if a list is all zeroes
(define (ALL-ZERO list)
  (cond [(null? list) #t]
        [(eqv? (car list) 0) (ALL-ZERO (cdr list))]
        [else #f]))

; forming the first possibles list (neighbors of trees)
(define (NO-DUPS l)
  (cond ((null? l)
         '())
        ((member (car l) (cdr l))
         (NO-DUPS (cdr l)))
        (else
         (cons (car l) (NO-DUPS (cdr l))))))

; filtering coordinates out of boundaries
(define (BOUNDARIES rownum colnum list)  
  (cond [(null? list) '()]
        [(> (caar list) rownum) (BOUNDARIES rownum colnum (cdr list))]
        [(< (caar list) 1) (BOUNDARIES rownum colnum (cdr list))]
        [(> (cadar list) colnum) (BOUNDARIES rownum colnum (cdr list))]
        [(< (cadar list) 1) (BOUNDARIES rownum colnum (cdr list))]
        [else (cons (car list) (BOUNDARIES rownum colnum (cdr list)))]))

; returns if the possible list is able to form a solution ie. there are enough tent places to satisfy the constraints
(define (SOLVABLE constraint whatihave n)
  (cond [(null? constraint) #t]
        [(< (COUNT-IN-LIST whatihave n) (car constraint)) #f]
        [else (SOLVABLE (cdr constraint) whatihave (+ 1 n))]))

; placing all tents, no unmatched tree, no leftover places means reaching a solution
(define (SOLUTION trees tents row col)
  (cond [(not(eqv? (length trees) (length tents))) #f]
        [(not (ALL-ZERO row)) #f]
        [(not (ALL-ZERO col)) #f]
        [(not (CORRESPONDING trees tents)) #f]
        [else #t]))

; there is no tree without a tent
(define (CORRESPONDING trees tents)
  (cond [(null? trees) #t]
        [(NEIGHBOR-WITH-LIST (car trees) tents) (CORRESPONDING (cdr trees) tents )]
        [else #f] ))

; deletes adjacent places from the possible list when a tent is placed
(define (DELETE-ADJ all tent)
  (cond [(not(ADJACENT-WITH-LIST tent all)) all]
        [(ADJACENT tent (car all)) (DELETE-ADJ (cdr all) tent)]
        [else (cons (car all) (DELETE-ADJ (cdr all) tent))]))

; if the row col constraints allow you to put a tent there
(define (IS-PLACE  row col pair)
  (cond [(<= (GET-NTH (car pair) row)  0) #f]
        [(<= (GET-NTH (cadr pair) col)  0) #f]
        [else #t]))

; given a list of lists, returns all elements n'th elements as a list
(define (GET-ALL-NTH list n)
  (cond [(null? list) '()]
        [else (cons (GET-NTH n (car list)) (GET-ALL-NTH (cdr list) n))]))

; counts how many time x occurs in the given list
(define (COUNT-IN-LIST list x)
  (cond [(null? list) 0]
        [(eqv? x (car list)) (+ 1 (COUNT-IN-LIST (cdr list) x))]
        [else (COUNT-IN-LIST (cdr list) x)]))


;backtracking, deleting adjacents at each insertion
(define (HELPER row col trees tents possible)
  (cond [(SOLUTION trees tents row col) tents]
        [(null? possible) #f]
        [(not (SOLVABLE row (GET-ALL-NTH possible 1) 1) ) #f]
        [(not (SOLVABLE col (GET-ALL-NTH possible 2) 1) ) #f]
        [(if (IS-PLACE row col (car possible))
         (or (HELPER (DECREASE-NTH-ONE row (caar possible))
                      (DECREASE-NTH-ONE col (cadar possible))
                      trees (append tents (list (car possible)))
                      (DELETE-ADJ (cdr possible) (car possible)))
              (HELPER row col trees tents (cdr possible)))
          (HELPER row col trees tents (cdr possible)))]
        [else #f]))

; solver function
(define (TENTS-SOLUTION info)
  (HELPER (car info) (cadr info) (caddr info) '() 
          (NO-DUPS (BOUNDARIES (length (car info)) (length (cadr info)) (NEIGHBOR-LIST-LIST '() (caddr info ))))))

