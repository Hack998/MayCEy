% ======================================================
% *********************** Tablas ***********************
% ======================================================

% Tabla Aeronaves
aeronave(pequena, [cessna, embraerPhenom, beechraft]).
aeronave(mediana, [boeing717, embraer190, airBusA220]).
aeronave(grande, [boeing747, airBusA340, airBusA380]).

% Tabla Pistas
% pista(numero, largo, tipoNave, direccion, disponibilidad, horaOcup)

:-dynamic pista/6.
pista(p1, "1km", [pequena], [ns, eo, oe, sn], na, 0).
pista(p2-1, "2km", [pequena, mediana], [eo], na, 0).
pista(p2-2, "2km", [pequena, mediana], [oe], na, 0).
pista(p3, "3km", [pequena, mediana, grande], [ns, eo, oe, sn], na, 0).

% Tabla Emergencias

respuestaE(perdidaMotor, llamarBomberos).
respuestaE(parto, llamarMedico).
respuestaE(paroCardiaco, llamarMedico).
respuestaE(secuestro, llamarOijFP).

% Tabla Condiciones Aterrizaje
condicion(viento, 0).
condicion(peso, 0).
condicion(distancia, 0).
condicion(velocidad, 0).

% ======================================================
% ********************* Funciones **********************
% ======================================================

miembro(X,[X|_]).

miembro(X, [_|Y]) :-
    miembro(X, Y).

tipoNave(X, Nave):-
    aeronave(X, Y),
    miembro(Nave, Y).

asignarPista(Nave, HoraAsig, Dir):-
    tipoNave(TNave,Nave),
    pista(Pista, _, Tams, Dirs, na, _),
    miembro(TNave, Tams), miembro(Dir, Dirs),
    write(Pista),
    assert(pista(Pista, _, Tams, Dir, Nave, HoraAsig)),
    retract(pista(Pista, _, Tams, _, na, 0)).


liberarPista(Nave, HoraAsig, Dir):-
    tipoNave(TNave, Nave),
    pista(Pista, _, Tams, _, Nave, HoraAsig),
    miembro(TNave, Tams),
    assert(pista(Pista, _, Tams, Dir, na, 0)),
    retract(pista(Pista, _, Tams, Dir, Nave, HoraAsig)).
