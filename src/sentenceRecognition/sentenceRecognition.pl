:- set_prolog_flag(double_quotes, chars).


token(T) -->
        alnum(L),
        token_(Ls),
        !,
        { atom_chars(T, [L|Ls]) }.

spaces --> [].
spaces --> space, spaces.

space --> [S], { char_type(S, space) }.

alnum(A) --> [A], { char_type(A, alnum) }.

token_([L|Ls]) --> alnum(L), token_(Ls).
token_([])     --> [].
tokens([])     --> [].
tokens([T|Ts]) --> token(T), spaces, tokens(Ts).

isMember(X, [X|_]).
isMember(X, [_|Y]):- isMember(X, Y).

verbo(X):- phrase_from_file(tokens(Ts), 'D:/OneDriveTEC/OneDrive - Estudiantes ITCR/GITHUB/MayCEy/MayCEy/src/sentenceRecognition/wordsDatabase/verbos.txt'),
     isMember(X, Ts).

pronombre(X):- phrase_from_file(tokens(Ts), 'D:/OneDriveTEC/OneDrive - Estudiantes ITCR/GITHUB/MayCEy/MayCEy/src/sentenceRecognition/wordsDatabase/pronombres.txt'),
    isMember(X, Ts).

sujeto(X):- phrase_from_file(tokens(Ts), 'D:/OneDriveTEC/OneDrive - Estudiantes ITCR/GITHUB/MayCEy/MayCEy/src/sentenceRecognition/wordsDatabase/sujetos.txt'),
    isMember(X, Ts).

preposicion(X):- phrase_from_file(tokens(Ts), 'D:/OneDriveTEC/OneDrive - Estudiantes ITCR/GITHUB/MayCEy/MayCEy/src/sentenceRecognition/wordsDatabase/preposiciones.txt'),
    isMember(X, Ts).

cosa(X):- phrase_from_file(tokens(Ts), 'D:/OneDriveTEC/OneDrive - Estudiantes ITCR/GITHUB/MayCEy/MayCEy/src/sentenceRecognition/wordsDatabase/cosas.txt'),
    isMember(X, Ts).

objeto--> {preposicion(X)},
    {verbo(Y)},
    {cosa(Z)},
    [Z]->[X]->[Y].
objeto--> {cosa(Z)},
    [Z].

predicado--> {verbo(X)},
    [X]->objeto.

adjetivo--> [] ; [adjetivo]->adjetivo.

sustantivo--> {pronombre(X)},
    {sujeto(Y)},
    [X]->[Y]->adjetivo.

oracion--> predicado, !; predicado->sustantivo, !; sustantivo->predicado, !.