;1

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

(print (insert '(1 2 3 4 5 6) 1 'Z))


;(((A B) C)(D E)) --> (E D C B A)

(defun atomi (x)
(cond
((null x) nil)
((atom (car x)) (append (atomi (cdr x)) (list (car x))))
(t (append (atomi (cdr x)) (atomi (car x))))))

(print (atomi '(((A B) C) (D E))))

;Definiti o functie care intoarce cel mai mare divizor comun al numerelor
;dintr-o lista neliniara.
(defun gdc_two (a b)
(if (= b 0)
	a
	(gdc_two b (mod a b))))

(defun gdc_all (x)
(cond
((null x) 0)
((null (cdr x)) (car x))
(t (gdc_two (car x) (gdc_all (cdr x))))))




(defun liniar_list (x)
(cond
((null x) nil)
((numberp (car x)) (cons (car x) (liniar_list (cdr x))))
(t (append(liniar_list (car x)) (liniar_list (cdr x))))))

(defun am_reusit (x)
(gdc_all (liniar_list x)))

(print (am_reusit '(((15 20) 30) (40 (50 60)))))

; Sa se scrie o functie care determina numarul de aparitii ale unui atom dat
;intr-o lista neliniara


(defun atom_dat (x a)
(cond
((null x) 0)
((= (car x) a) (+ 1 (atom_dat (cdr x) a)))
(t (atom_dat (cdr x) a))))

(print (atom_dat '(1 2 3 4 1 1 5) 1))

;2


;Definiti o functie care selecteaza al n-lea element al unei liste, sau
;NIL, daca nu exista.


(defun n_element (x n)
(cond
((or (null x ) (<= n 0)) nil)
((= n 1) (car x))
(t (n_element (cdr x) (- n 1)))))


;Sa se construiasca o functie care verifica daca un atom e membru al unei
;liste nu neaparat liniara.

(defun find_atom (x at)
(cond
((null x) nil)
((equal (car x) at) t)
((listp (car x)) (or (find_atom (car x) at) (find_atom (cdr x) at)))
(t (find_atom (cdr x) at))))




(print (find_atom '(((a b) c) (d e)) 'c))  ;; Returns T
(print (find_atom '(((a b) c) (d e)) 'f))  ;; Returns NIL
(print (find_atom '(((a b) c) (d e)) 'a))  ;; Returns T
(print (find_atom '(((a b) c) (d e)) 'e))  ;; Returns T



;Sa se construiasca lista tuturor sublistelor unei liste. Prin sublista se
;intelege fie lista insasi, fie un element de pe orice nivel, care este
;lista. Exemplu: (1 2 (3 (4 5) (6 7)) 8 (9 10)) =>
;( (1 2 (3 (4 5) (6 7)) 8 (9 10)) (3 (4 5) (6 7)) (4 5) (6 7) (9 10) ).


(defun sublists (lst)
(cond
((null lst) nil)
((atom lst) nil)
(t (cons lst
		(append
			(if (listp (car lst)) (sublists (car lst)) nil)
			(sublists (cdr lst)))))))
			
(print (sublists '(1 2 (3 (4 5) (6 7)) 8 (9 10))))	

;Sa se scrie o functie care transforma o lista liniara intr-o multime
;list to set :)

(defun multime (lst)
(cond 
((null lst) nil)
((member (car lst) (cdr lst)) (multime (cdr lst)))
(t (cons (car lst) (multime (cdr lst))))))
			
			
(print (multime '(1 2 4 1 2 5 12 1 2 4 3 2 4 5 6 5 6 5 6 69)))
