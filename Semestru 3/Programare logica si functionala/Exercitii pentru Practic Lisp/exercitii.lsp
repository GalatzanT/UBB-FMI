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
