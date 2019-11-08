% *************************************************************************
% ************************** Sistema Experto ******************************
% *************************************************************************

% =========================================================================
% Regla: conectar
% Params: No hay parametros
% =========================================================================
conectar:- write("MayCEy esta en funcionamiento."),liberarTodo,nl,read(X),sentenceQuery(X,Q),nl,inicio(Q).

% =========================================================================
% Regla: inicio
% Params: String
% =========================================================================
inicio("hola"):- write("Hola ¿en qué lo puedo ayudar?"),nl,read(Q),sentenceQuery(Q,X),permiso(X),write("Con gusto"),nl,read(Y),sentenceQuery(Y,B),nl,re_inicio(B).
inicio("buenas"):- write("Buenas tardes ¿en qué lo puedo ayudar?"),nl,read(Q),sentenceQuery(Q,X),permiso(X),write("Con gusto"),nl,read(Y),sentenceQuery(Y,B),nl,re_inicio(B).
inicio("buenos"):- write("Buenos dias ¿en qué lo puedo ayudar?"),nl,read(Q),sentenceQuery(Q,X),permiso(X),write("Con gusto"),nl,read(Y),sentenceQuery(Y,B),nl,re_inicio(B).
inicio("mayday"):- write("Buenas, por favor indique su emergencia."),nl,emergencia_a,write("Con mucho gusto"),nl,read(F),sentenceQuery(F,B),nl,re_inicio(B).
inicio("7500"):- write("Por favor indique su matricula."),nl,matricula("secuestro"),write("Con mucho gusto"),nl,read(F),sentenceQuery(F,B),nl,re_inicio(B).
inicio(_):- write("No te entendi, por favor repitalo."),nl,read(Q),sentenceQuery(Q,X),nl,inicio(X).

% =========================================================================
% Regla: re_inicio
% Params: String
% =========================================================================
re_inicio("hola"):- inicio("hola").
re_inicio("buenas"):- inicio("buenas").
re_inicio("buenos"):- inicio("buenos").
re_inicio("mayday"):- inicio("mayday").
re_inicio("7500"):- inicio("7500").
re_inicio("cambio"):- write("Cambio y Fuera.").
re_inicio(_):- write("No te entendi, por favor repitalo."),nl,read(Q),sentenceQuery(Q,B),nl,re_inicio(B).

% =========================================================================
% Regla: emergencia_a
% Params: No hay parametros
% =========================================================================
emergencia_a:- read(U),sentenceQuery(U,X),respuestaE(X,_),!,nl,write("Por favor indique su matricula."),nl, matricula(X).
emergencia_a:- write("No poseo conocimiento sobre esa emergencia, por favor ingrese una con la que pueda lidiar."),nl,emergencia_a.

% =========================================================================
% Regla: matricula
% Params: U - accion o emergencia a responder
% =========================================================================
matricula(U):- U == despegue,!, read(I),nl,write("¿Que tipo de AeroNave es?"),nl,tipo(U,I).
matricula(U):- read(I),nl,write("¿Que tipo de AeroNave es?"),nl,tipo(U,I).

% =========================================================================
% Regla: matricula
% Params: No hay parametros
% =========================================================================
matricula:- read(I),nl,write("¿Que tipo de AeroNave es?"),nl,tipo(I).

% =========================================================================
% Regla: tipo
% Params: U - accion o emergencia a responder
%         I - matricula del aeronave
% =========================================================================
tipo(U,I):- U == despegue,read(X),sentenceQuery(X,B),tipoNave(_,B),!,nl,write("Por favor indique hora de salida."),nl,direccion(I,B).
tipo(U,I):- not(U == despegue),read(L),sentenceQuery(L,B),tipoNave(_,B),!,nl,tamaño(U,I,B).
tipo(U,I):- write("Ese tipo de AeroNave no se tiene registrada, por favor ingrese una que conozca."),nl,tipo(U,I).

% =========================================================================
% Regla: matricula
% Params: I - matricula del aeronave
% =========================================================================
tipo(I):- read(L),sentenceQuery(L,B),tipoNave(_,B),!,nl,tamaño(I,B).
tipo(I):- write("Ese tipo de AeroNave no se tiene registrada, por favor ingrese una que conozca."),nl,tipo(I).

% =========================================================================
% Regla: tamaño
% Params: U - accion o emergencia a responder
%         I - matricula del aeronave
%         L - nombre del aeronave
% =========================================================================
tamaño(U,I,L):- write("Por favor indique su direccion."),nl,read(P),sentenceQuery(P,B),direccion(U,I,L,B).

% =========================================================================
% Regla: tamaño
% Params: I - matricula del aeronave
%         L - nombre del aeronave
% =========================================================================
tamaño(I,L):- write("Por favor indique su direccion."),nl,read(P),sentenceQuery(P,B),direccion(I,L,B).

% =========================================================================
% Regla: direccion
% Params: I - matricula del aeronave
%         L - nombre del aeronave
%         P - direccion del aeronave
% =========================================================================
direccion(I,L,P):- asignarPista(L,P,I),!,nl,read(X),sentenceQuery(X,B), agradecimiento(B).
direccion(I,L,P):- write("La direccion "),write(P),write(" no la puedo entender, solicito una direccion que conozca."),nl,read(Q),sentenceQuery(Q,B),direccion(I,L,B).

% =========================================================================
% Regla: direccion
% Params: U - emergencia a responder
%         I - matricula del aeronave
%         L - nombre de nave
%         P - direccion del aeronave
% =========================================================================
direccion(U,I,L,P):- string_to_atom(Y,L),string_to_atom(Q,I),asignarPista(Y,P,Q),!,write(", y se procedera a "), respuestaE(U,J),write(J),write(" y se enviaran a la pista asignada."),nl,read(X),sentenceQuery(X,B),agradecimiento(B).
direccion(U,I,L,P):- write("La direccion "),write(P),write(" no la puedo entender, solicito una direccion que conozca."),nl,read(Q),sentenceQuery(Q,B),direccion(U,I,L,B).

% =========================================================================
% Regla: direccion
% Params: I - matricula del aeronave
%         X - nombre del aeronave
% =========================================================================
direccion(I,X):- read(L), integer(L),!,write("Por favor indique su direccion."),nl,read(P),sentenceQuery(P,B),salida(I,X,L,B).
direccion(I,X):- write("La hora ingresada no es correcta."),nl,direccion(I,X).

% =========================================================================
% Regla: permiso
% Params: String
% =========================================================================
permiso("aterrizar"):- write("Por favor indique su matricula."),nl,matricula.
permiso("despegar"):- write("Por favor indique su matricula."),nl,matricula(despegue).
permiso(_):- write("No entendi tu solicitud, por favor intente denuevo."),nl,read(Q),sentenceQuery(Q,X),permiso(X).


% =========================================================================
% Regla: salida
% Params: I - matricula del aeronave
%         X - nombre del aeronave
%         L - hora del despegue
%         P - direccion del aeronave
% =========================================================================
salida(I,X,L,P):- string_to_atom(Y,X),string_to_atom(Q,I),asignarPista(Y,L,P,Q),!,nl,read(B),sentenceQuery(B,W),agradecimiento(W).
salida(I,X,L,P):- write("La direccion "),write(P),write(" no la puedo entender, solicito una direccion que conozca."),nl,read(Q),salida(I,X,L,Q).

% =========================================================================
% Regla: agradecimiento
% Params: X - String con keyword
% =========================================================================
agradecimiento(X):- verif_gracias(X),!.
agradecimiento(X):- write("No puedo entender "),write(X),nl,read(Q),sentenceQuery(Q,W),nl,agradecimiento(W).
