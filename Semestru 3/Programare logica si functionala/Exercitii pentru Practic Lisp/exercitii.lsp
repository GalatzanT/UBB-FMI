; Sa se insereze intr-o lista liniara un atom a dat dupa al 2-lea, al 4-lea,
;al 6-lea,....element.

(defun insert (x index)
(cond
((null x) nil)
((evenp index) (cons (car x) (cons 'A (insert (cdr x) (+ index 1)))))
(t (cons (car x) (insert (cdr x) (+ index 1))))))


;cu orice atom vrea userul de la tastatura
(defun insert (x index atom)
(cond
((null x) nil)
((evenp index) (cons (car x) (cons atom (insert (cdr x) (+ index 1) atom))))
(t (cons (car x) (insert (cdr x) (+ index 1) atom)))))

;(print (insert '(1 2 3 4 5 6) 1 'Z))