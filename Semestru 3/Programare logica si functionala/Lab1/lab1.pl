% eMultumie(+Lista)
% Lista - lista care trebuie verificata
% Model de flux: (i)

eMultime([]).
eMultime([H|T]) :-
    not(member_check(H, T)),
    eMultime(T).

% member_check(+Element, +Lista)
% Element - elementul cautat
% Lista - lista în care cautam
% Model de flux: (i, i)

member_check(E, [E|_]).
member_check(E, [_|T]) :-
    member_check(E, T).

% remove3(+Lista, +Element, -Rezultat)
% Lista - lista de intrare
% Element - elementul cautat% Rezultat - lista dupa eliminare
% Model de flux: (i, i, o)

remove3(L, E, R) :-
    remove3_aux(L, E, 0, R).

% remove3_aux(+Lista, +Element, +Contor, -Rezultat)
% Lista - lista curenta
% Element - elementul de eliminat
% Contor - numarul de eliminari efectuate
% Rezultat - lista rezultat
% Model de flux: (i, i, i, o)

remove3_aux([], _, 3, []).

remove3_aux([H|T], E, C, R) :-
    H = E,
    C < 3,
    C1 is C + 1,
    remove3_aux(T, E, C1, R).

remove3_aux([H|T], E, C, [H|R]) :-
    (H \= E ; C >= 3),
    remove3_aux(T, E, C, R).
