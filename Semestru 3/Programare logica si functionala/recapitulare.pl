%1.a
%diferenta_multimi(L1:list, L2:list, LREZ:list)
%(i,i,o)- determinist (i,i,i) - determinist

diferenta_multimi([],_,[]).
diferenta_multimi([H|T],L1,[H|REZ]):-
	\+ exista(H,L1),
	diferenta_multimi(T,L1,REZ).
diferenta_multimi([H|T],L1,REZ):-
	exista(H,L1),
	diferenta_multimi(T,L1,REZ).

exista(E,[E|_]):-!.
exista(E,[_|T]):-
	exista(E,T).


%b.
%unu_dupa_pare(L:list, LREZ:list)
%(i,o) - determinist (i,i) determinist

unu_dupa_pare([],[]).
unu_dupa_pare([H|T],[H, 1|REZ]):-
	H mod 2 =:= 0,
	unu_dupa_pare(T,REZ).
unu_dupa_pare([H|T],[H|REZ]):-
	H mod 2 =:= 1,
	unu_dupa_pare(T,REZ).
