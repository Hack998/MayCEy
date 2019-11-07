:- set_prolog_flag(double_quotes, chars).

findInFile(Lines, File):-
    open(File, read, Str),
    read_file(Str, Lines),
    close(Str).

read_file(Stream, []) :-
    at_end_of_stream(Stream).

read_file(Stream,[X|L]) :-
    \+ at_end_of_stream(Stream),
    read_line_to_codes(Stream,Codes),
    atom_chars(X, Codes),
    read_file(Stream,L), !.

isMember(X, [X|_]).
isMember(X, [_|Y]):- isMember(X, Y).

atributo(X):- findInFile(Ts, 'D:/OneDrive TEC/OneDrive - Estudiantes ITCR/GITHUB/MayCEy/MayCEy/src/sentenceRecognition/wordsDatabase/atributos.txt'),
     isMember(X, Ts).

keyword(X):- findInFile(Ts, 'D:/OneDrive TEC/OneDrive - Estudiantes ITCR/GITHUB/MayCEy/MayCEy/src/sentenceRecognition/wordsDatabase/keywords.txt'),
     isMember(X, Ts).

verbo(X):- findInFile(Ts, 'D:/OneDrive TEC/OneDrive - Estudiantes ITCR/GITHUB/MayCEy/MayCEy/src/sentenceRecognition/wordsDatabase/verbos.txt'),
     isMember(X, Ts), !.

pronombre(X):- findInFile(Ts, 'D:/OneDrive TEC/OneDrive - Estudiantes ITCR/GITHUB/MayCEy/MayCEy/src/sentenceRecognition/wordsDatabase/pronombres.txt'),
    isMember(X, Ts).

sujeto(X):- findInFile(Ts, 'D:/OneDrive TEC/OneDrive - Estudiantes ITCR/GITHUB/MayCEy/MayCEy/src/sentenceRecognition/wordsDatabase/sujetos.txt'),
    isMember(X, Ts).

preposicion(X):- findInFile(Ts, 'D:/OneDrive TEC/OneDrive - Estudiantes ITCR/GITHUB/MayCEy/MayCEy/src/sentenceRecognition/wordsDatabase/preposiciones.txt'),
    isMember(X, Ts).

cosa(X):- findInFile(Ts, 'D:/OneDrive TEC/OneDrive - Estudiantes ITCR/GITHUB/MayCEy/MayCEy/src/sentenceRecognition/wordsDatabase/cosas.txt'),
    isMember(X, Ts).

objeto--> [Z]->[X]->[Y],
    {verbo(Y)},
    {preposicion(X)},
    {cosa(Z)},
    !.
objeto--> [Z]->[X]->[Y],
    {cosa(Y)},
    {preposicion(X)},
    {cosa(Z)},
    !.
objeto--> [Z],
    {cosa(Z)},
    !.
objeto-->  [Y],
    {verbo(Y)},
    !.
objeto--> [X],
    {keyword(X)}.

predicado--> [X]->objeto,
    {verbo(X)}.
predicado--> [Y]->[Z]->[X],
    {cosa(Y)},
    {preposicion(Z)},
    {keyword(X)}.
predicado--> [X]->[Y]->[C],
    {keyword(X)},
    {preposicion(Y)},
    {cosa(C)}.
predicado--> [X]->[Y]->[A]->[C],
    {keyword(X)},
    {preposicion(Y)},
    {atributo(A)},
    {cosa(C)}.

predicado--> objeto.


adjetivo--> [] ; [adjetivo]->adjetivo.

sustantivo--> [X]->[Y]->adjetivo,
    {pronombre(X)},
    {sujeto(Y)}.
sustantivo--> [X]->[Y],
    {pronombre(X)},
    {sujeto(Y)}.

oracion--> predicado; predicado->sustantivo; sustantivo->predicado.

sentenceQuery(Z, Resultado):-
    string_to_atom(Z, W),
    downcase_atom(W, X),
    tokenize_atom(X, L),
    phrase(oracion, L),
    keyword(R),
    isMember(R, L),
    atom_string(R, Resultado),
    !.
sentenceQuery(Z, Resultado):-
    string_to_atom(Z, W),
    downcase_atom(W, X),
    keyword(X),
    atom_string(X, Resultado),
    !.
sentenceQuery(_, Resultado):-
    atom_string("-1", Resultado),
    !.
