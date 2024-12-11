(defun inorder-traversal (tree)
  (if (null tree)
      '()  ; Dacă arborele este gol, întoarcem o listă vidă
      (append 
        (inorder-traversal (second tree))  ; Parcursul subarborelui stâng
        (list (first tree))                ; Nodul curent
        (inorder-traversal (third tree))))) ; Parcursul subarborelui drept

;; Exemplu de arbore
(setq arbore '(A (B) (C (D) (E))))

;; Apelarea funcției
(print (inorder-traversal arbore))
