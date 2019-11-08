:- set_prolog_flag(double_quotes, chars).

% =========================================================================
% Regla : findInFile
% Params: Lines - Lista de palabras obtenidas del archivo
%         File  - Path donde se encuentra el archivo
% =========================================================================
findInFile(Lines, File):-
    open(File, read, Str),
    read_file(Str, Lines),
    close(Str).

% =========================================================================
% Regla : read_file
% Params: Stream - Entrada que va a ser leída
%         [X|L]  - Lista donde se almacena la información leída
% =========================================================================
read_file(Stream, []) :-
    at_end_of_stream(Stream).

read_file(Stream,[X|L]) :-
    \+ at_end_of_stream(Stream),
    read_line_to_codes(Stream,Codes),
    atom_chars(X, Codes),
    read_file(Stream,L), !.

% =========================================================================
% Regla : isMember
% Params: X  - Elemento a comparar con la lista
% =========================================================================
isMember(X, [X|_]).
isMember(X, [_|Y]):- isMember(X, Y).

% =========================================================================
% Regla : atributo
% Params: X  - atributo encontrado en el archivo de atributos
% =========================================================================
atributo(X):- findInFile(Ts, '/home/samuel/Escritorio/Cursos/Lenguajes/Logico/Prolog/src/sentenceRecognition/wordsDatabase/atributos.txt'),
     isMember(X, Ts).

% =========================================================================
% Regla : keyword
% Params: X  - keyword encontrado en el archivo de keywords
% =========================================================================
keyword(X):- findInFile(Ts, '/home/samuel/Escritorio/Cursos/Lenguajes/Logico/Prolog/src/sentenceRecognition/wordsDatabase/keywords.txt'),
     isMember(X, Ts).

% =========================================================================
% Regla : verbo
% Params: X  - verbo encontrado en el archivo de verbos
% =========================================================================
verbo(X):- findInFile(Ts, '/home/samuel/Escritorio/Cursos/Lenguajes/Logico/Prolog/src/sentenceRecognition/wordsDatabase/verbos.txt'),
     isMember(X, Ts), !.

% =========================================================================
% Regla : pronombre
% Params: X  - pronombre encontrado en el archivo de pronombres
% =========================================================================
pronombre(X):- findInFile(Ts, '/home/samuel/Escritorio/Cursos/Lenguajes/Logico/Prolog/src/sentenceRecognition/wordsDatabase/pronombres.txt'),
    isMember(X, Ts).

% =========================================================================
% Regla : sujeto
% Params: X  - sujeto encontrado en el archivo de sujetos
% =========================================================================
sujeto(X):- findInFile(Ts, '/home/samuel/Escritorio/Cursos/Lenguajes/Logico/Prolog/src/sentenceRecognition/wordsDatabase/sujetos.txt'),
    isMember(X, Ts).

% =========================================================================
% Regla : preposicion
% Params: X  - preposicion encontrado en el archivo de preposiones
% =========================================================================
preposicion(X):- findInFile(Ts, '/home/samuel/Escritorio/Cursos/Lenguajes/Logico/Prolog/src/sentenceRecognition/wordsDatabase/preposiciones.txt'),
    isMember(X, Ts).

% =========================================================================
% Regla : cosa
% Params: X  - cosa encontrado en el archivo de cosas
% =========================================================================
cosa(X):- findInFile(Ts, '/home/samuel/Escritorio/Cursos/Lenguajes/Logico/Prolog/src/sentenceRecognition/wordsDatabase/cosas.txt'),
    isMember(X, Ts).

% =========================================================================
% DCG : objeto
% Params: Z - cosa
%         X - preposicion
%         Y - verbo
% =========================================================================
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

% =========================================================================
% DCG : predicado
% Params: X - keyword
%         Y - preposicion
%         Z - verbo
%         C - cosa
%         A - atributo
%         V - verbo
% =========================================================================
predicado--> [V]->objeto,
    {verbo(V)}.
predicado--> [C]->[Y]->[X],
    {cosa(C)},
    {preposicion(Y)},
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
predicado--> [X]->[Y]->[A]->[C],
    {keyword(X)},
    {keyword(Y)},
    {preposicion(A)},
    {cosa(C)}.
predicado--> objeto.


adjetivo--> [] ; [adjetivo]->adjetivo.

% =========================================================================
% DCG : sustantivo
% Params: X - pronombre
%         Y - sujeto
%         K - keyword
%         C - cosa
% =========================================================================
sustantivo--> [X]->[Y]->adjetivo,
    {pronombre(X)},
    {sujeto(Y)}.
sustantivo--> [X]->[Y],
    {pronombre(X)},
    {sujeto(Y)}.

casoEspecial--> [X]->[C],
    {keyword(X)},
    {cosa(C)}.
casoEspecial--> [K],
    {keyword(K)}.

% =========================================================================
% DCG : oracion
% =========================================================================
oracion--> predicado; predicado->sustantivo; sustantivo->predicado.
oracion--> casoEspecial.

% =========================================================================
% Regla : sentenceQuery
% Params: Z - string de la oracion a analizar
%         Resultado - keyword encontrado
% =========================================================================
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
