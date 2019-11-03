/* 	Casos de prueba		*/
respuesta("perdida de motor", "llamar a los bomberos").
aeronave(cessna, pequeña).
aeronave(boeing717, mediana).
pista(mediana,"P2-1").
pista(pequeña, "P1").
direccion("P2-1",eo).
/* Verificacion de existencia de emergencia.*/
ver_A:- 1=1.
/* Verificacion de existencia de aeronave.*/
ver_B:- 1=1.
/* Verificacion de tamaño.*/
ver_C:- 1=2.
/* Verificaion de direccion.*/
ver_D(P):- P=eo;P=oe.


/* 	Funcionamiento de inicio	*/
conectar:- write("MayCEy esta en funcionamiento."),nl,read(X),nl,inicio(X).

inicio(hola):- write("Hola ¿en qué lo puedo ayudar?"),nl,read(Q),permiso(Q),write("Con gusto"),nl,read(Y),nl,re_inicio(Y).
inicio(mayday):- write("Buenas, por favor indique su emergencia."),nl,emergencia,write("Con mucho gusto"),nl,read(F),nl,re_inicio(F).
inicio(_):- write("No te entendi."),nl,read(Q),nl,inicio(Q).

re_inicio(hola):- inicio(hola).
re_inicio(mayday):- inicio(mayday).
re_inicio("Cambio y fuera"):- write("Cambio y Fuera.").
re_inicio(_):- write("No te entendi."),nl,read(Q),nl,re_inicio(Q).

/*	Mayday		*/
emergencia:- read(U),ver_A,!,nl,write("Por favor, identifiquece."),nl, matricula(U).
emergencia:- write("No poseo conocimiento sobre esa emergencia."),nl,emergencia.

matricula(U):- U == despegue,!, read(I),nl,write("¿Que tipo de AeroNave es?"),nl,tipo(U,I).
matricula(U):- read(I),nl,write("¿Que tipo de AeroNave es?"),nl,tipo(U,I).
matricula:- read(I),nl,write("¿Que tipo de AeroNave es?"),nl,tipo(I).

tipo(U,I):- U == despegue,!,read(X),nl,write("Por favor indique hora de salida."),nl,salida(U,I,X).
tipo(U,I):- read(L),ver_B,!,nl,aeronave(L,C),tamaño(U,I,C).
tipo(U,I):- write("Ese tipo de AeroNave no se tiene registrada."),nl,tipo(U,I).
tipo(I):- read(L),ver_B,!,nl,aeronave(L,C),tamaño(I,C).
tipo(I):- write("Ese tipo de AeroNave no se tiene registrada."),nl,tipo(I).

tamaño(U,I,C):- ver_C,!,pista(C,O), write(O),write(" asignada y se procedera a "), respuesta(U,J),write(J),write(" y se enviara a "), write(O),nl,read(X).
tamaño(U,I,C):- write("Por favor indique su direccion."),nl,read(P),ver_D(P),!,pista(C,O), write(O),write(" asignada y se procedera a "), respuesta(U,J),write(J),write(" y se enviara a "), write(O),write(", por favor manteja la direccion "),write(P),nl,read(X).
tamaño(U,I,C):- pista(C,O), write(O),write(" asignada y se procedera a "), respuesta(U,J),write(J),write(" y se enviara a "), write(O),write(", por favor alinearse a la direccion "),direccion(O,L),write(L),nl,read(X).
tamaño(I,C):- ver_C,!,pista(C,O),write("Se ha asignado la pista "),write(O),nl,read(X).
tamaño(I,C):- write("Por favor indique su direccion."),nl,read(P),ver_D(P),!,pista(C,O),write("Se ha asignado la pista "),write(", por favor manteja la direccion "),write(P),write(O),nl,read(X).
tamaño(I,C):- pista(C,O),write("Se ha asignado la pista "),write(O),write(", por favor alinearse a la direccion "),direccion(O,L),write(L),nl,read(X).

/*	Aterrizase	*/
permiso(aterrizaje):- write("Por favor, identifiquece."),nl,matricula.

/*	Despegue		*/
permiso(despegue):- write("Por favor, identifiquece."),nl,matricula(despegue).

salida(U,I,X):- read(L),aeronave(X,C),pista(C,O), write(O),write(" asignada por 5 minutos."),nl,read.

