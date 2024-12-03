;; Problema a: Doublarea elementului de pe poziția n
(defun double-at-n (lst n)
  (cond
    ((or (null lst) (= n 0)) lst)
    ((= n 1) (cons (car lst) (cons (car lst) (cdr lst))))
    (t (cons (car lst) (double-at-n (cdr lst) (- n 1))))))

;; Problema b: Asocierea între două liste
(defun pair-lists (lst1 lst2)
  (cond
    ((or (null lst1) (null lst2)) nil)
    (t (cons (list (car lst1) (car lst2)) (pair-lists (cdr lst1) (cdr lst2))))))

;; Problema c: Determinarea numărului sublistelor
(defun count-sublists (lst)
  (cond
    ((null lst) 0)
    ((listp (car lst)) 
     (+ 1 
        (count-sublists (car lst))  ; Count sublists within this sublist
        (count-sublists (cdr lst))))  ; Count sublists in the rest of the list
    (t (count-sublists (cdr lst)))))  ; If not a list, continue to next element

defun count-sublists-one (lst)
(+ 1 count-sublists (lst))

;; Problema d: Numărarea atomilor la nivel superficial
(defun count-atoms (lst)
  (cond
    ((null lst) 0)
    ((atom (car lst)) (+ 1 (count-atoms (cdr lst))))
    (t (count-atoms (cdr lst)))))
