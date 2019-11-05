% ======================================================
% *********************** Tablas ***********************
% ======================================================

% Tabla Aeronaves
aeronave(pequena, [cessna, embraerPhenom, beechraft]).
aeronave(mediana, [boeing717, embraer190, airBusA220]).
aeronave(grande, [boeing747, airBusA340, airBusA380]).

% Tabla Pistas
:-dynamic pista/6.

pista(p1, "1km", pequena, na, na, "0:00hrs").
pista(p2-1, "2km", mediana, eo, na, "0:00hrs").
pista(p2-2, "2km", mediana, oe, na, "0:00hrs").
pista(p3, "3km", grande, na, na, "0:00hrs").

% Tabla Emergencias
emergencia(perdidaMotor).
emergencia(parto).
emergencia(paroCardiaco).
emergencia(secuestro).

% Tabla Atencion de Emergencias
atencionE(llamarBomberos).
atencionE(llamarMedicos).
atencionE(llamarOij).
atencionE(llamarFP).

% Tabla Condiciones Aterrizaje
condicion(viento).
condicion(peso).
condicion(distancia).
condicion(velocidad).

% ======================================================
% ********************* Funciones **********************
% ======================================================

miembro(X,[X|_]).

miembro(X, [_|Y]) :-
    miembro(X, Y).

tipoNave(X, Nave):-
    aeronave(X, Y),
    miembro(Nave, Y).

despegar(Nave, HoraAsig, Dir):-
    asignarPista(Nave, HoraAsig, Dir).

aterrizar(Nave, HoraAsig, Dir):-
    asignarPista(Nave, HoraAsig, Dir).

asignarPista(Nave, HoraAsig, Dir):-
    tipoNave(mediana, Nave),!,
    pistaDisp(mediana, Pista),
    pista(Pista, _, mediana, Dir, na, _),
    assert(pista(Pista, _, mediana, Dir, Nave, HoraAsig)),
    retract(pista(Pista, _, mediana, Dir, na, "0:00hrs")).

asignarPista(Nave, HoraAsig, Dir):-
    tipoNave(TNave,Nave),
    pistaDisp(TNave, Pista),
    pista(Pista, _, TNave, _, na, _),
    assert(pista(Pista, _, TNave, Dir, Nave, HoraAsig)),
    retract(pista(Pista, _, TNave, _, na, "0:00hrs")).


liberarPista(Nave, HoraAsig, Dir):-
    tipoNave(TNave, Nave), pista(Pista, _, TNave, Dir, Nave, HoraAsig),
    assert(pista(Pista, _, TNave, Dir, na, "0:00hrs")),
    retract(pista(Pista, _, TNave, Dir, Nave, HoraAsig)).

pistaDisp(TNave, Pista):-
    pista(Pista, _, TNave,_, na, _).

gdeOpqn(Nave):-
    tipoNave(pequena, Nave); tipoNave(grande, Nave).






















