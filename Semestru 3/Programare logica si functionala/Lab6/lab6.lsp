(defun suma_atom (x)
(cond
((numberp x) x)
((atom x) 0)
(t (apply #'+ (mapcar #' suma_atom x)))))


(setq ex1 '(1 2 3 4))
(print (suma_atom '(1 2 A (C (10 200)) 4 B)))
(print (suma_atom ex1))
