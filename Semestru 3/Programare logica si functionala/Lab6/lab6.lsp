(defun suma_atom (lst)
(cond
((numberp lst) lst)
((listp lst) (apply #'+ (mapcar #' suma_atom lst)))
(t 0)))


(setq ex1 '(1 2 3 4))
(print (suma_atom '(1 2 A (C (10 200)) 4 B)))
(print (suma_atom ex1))