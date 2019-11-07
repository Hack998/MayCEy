% *************************************************************************
% ********************************* TABLAS ********************************
% *************************************************************************

% =========================================================================
% Tabla: Aeronaves
% Estructura: aeronave(tipo de Nave, lista de Naves).
% =========================================================================

aeronave(pequena, [cessna, embraerPhenom, beechraft]).
aeronave(mediana, [boeing717, embraer190, airBusA220]).
aeronave(grande, [boeing747, airBusA340, airBusA380]).

% =========================================================================
% Tabla: Pistas
% Estructura: pista(numero, largo, tipoNave, direccion, disponibilidad,
%             horaAsig, Placa)
% =========================================================================

:-dynamic pista/7.
pista(p1, "1km", [pequena], [ns, eo, oe, sn], na, 0, "").
pista(p2-1, "2km", [pequena, mediana], [eo], na, 0, "").
pista(p2-2, "2km", [pequena, mediana], [oe], na, 0, "").
pista(p3, "3km", [pequena, mediana, grande], [ns, eo, oe, sn], na, 0, "").

% =========================================================================
% Tabla: Emergencias
% Estructura: respuestaE(emergencia, respuesta)
% =========================================================================

respuestaE(perdidaMotor, llamarBomberos).
respuestaE(parto, llamarMedico).
respuestaE(paroCardiaco, llamarMedico).
respuestaE(secuestro, llamarOijFP).

% =========================================================================
% Tabla: Condiciones Aterrizaje
% Estructura: condicion(condicion, valor)
% =========================================================================

condicion(viento, 0).
condicion(peso, 0).
condicion(distancia, 0).
condicion(velocidad, 0).

% *************************************************************************
% ****************************** FUNCIONES ********************************
% *************************************************************************

% =========================================================================
% Regla : Miembro
% Params: X  - Valor a buscar en la lista
%         [] - Lista en la que se buscara el valor
% =========================================================================

miembro(X,[X|_]).

miembro(X, [_|Y]) :-
    miembro(X, Y).

% =========================================================================
% Regla: tipoNave
% Params: TNave - Tipo de Nave
%         Nave  - Nombre de la nave a verificar
% =========================================================================

tipoNave(TNave, Nave):-
    aeronave(TNave, Y),
    miembro(Nave, Y).

% =========================================================================
% Regla : asignarPista
% Params: Nave  - Nombre de la nave que se va asginar
%         Dir   - Direccion en la que se mueve o movera
%         Placa - Placa o matricula de la nave
% =========================================================================

asignarPista(Nave, Dir, Placa):-
    tipoNave(TNave,Nave),
    pista(Pista, Dist, Tams, Dirs, na, _, _),
    miembro(TNave, Tams), miembro(Dir, Dirs),
    horaActual(HoraAsig),
    write("Se asigno la pista "), write(Pista),
    write(" para usar a las "), write(HoraAsig), write("hrs"),
    assert(pista(Pista, Dist, Tams, Dirs, Nave, HoraAsig, Placa)),
    retract(pista(Pista, Dist, Tams, _, na, 0, "")).

asignarPista(Nave, Dir, Placa):-
    tipoNave(TNave,Nave),
    horaActual(HoraAsig),
    pista(Pista, Dist, Tams, Dirs, _, HoraAsig, _),
    miembro(TNave, Tams), miembro(Dir, Dirs),
    NHoraAsig is HoraAsig + 5,
    write("Se asigno la pista "), write(Pista),
    write(" para usar a las "), write(NHoraAsig), write("hrs"),
    assert(pista(Pista, Dist, Tams, Dirs, Nave, NHoraAsig, Placa)),
    retract(pista(Pista, Dist, Tams, Dirs, _, HoraAsig, _)).

% =========================================================================
% Regla : asignarPista
% Params: Nave  - Nombre de la nave que se va asginar
%         HoraAsig - Hora en la que se asginara la pista
%         Dir   - Direccion en la que se mueve o movera
%         Placa - Placa o matricula de la nave
% =========================================================================

asignarPista(Nave, HoraAsig, Dir, Placa):-
    tipoNave(TNave,Nave),
    pista(Pista, _, Tams, Dirs, na, _, _),
    miembro(TNave, Tams), miembro(Dir, Dirs),
    write("Se asigno la pista "), write(Pista),
    write(" para usar a las "), write(HoraAsig), write("hrs"),
    assert(pista(Pista, _, Tams, Dirs, Nave, HoraAsig, Placa)),
    retract(pista(Pista, _, Tams, _, na, 0, "")).

asignarPista(Nave, HoraAsig, Dir, Placa):-
    tipoNave(TNave,Nave),
    pista(Pista, Dist, Tams, Dirs, _, HoraAsig, _),
    miembro(TNave, Tams), miembro(Dir, Dirs),
    THoraAsig is HoraAsig + 5, validarHora(THoraAsig, NHoraAsig),
    write("Se asigno la pista "), write(Pista),
    write(" para usar a las "), write(NHoraAsig), write("hrs"),
    assert(pista(Pista, Dist, Tams, Dirs, Nave, NHoraAsig, Placa)),
    retract(pista(Pista, Dist, Tams, Dirs, _, HoraAsig, _)).

% =========================================================================
% Regla : liberarPista
% Params: Nave  - Nombre de la nave que se va asginar
%         HoraAsig - Hora en la que fue asignada la pista
%         Dir   - Direccion en la que se mueve o movera
%         Placa - Placa o matricula de la nave
% =========================================================================

liberarPista(Nave, HoraAsig, Dir, Placa):-
    tipoNave(TNave, Nave),
    pista(Pista, Dist, Tams, Dirs, Nave, HoraAsig, Placa),
    miembro(TNave, Tams), miembro(Dir, Dirs),
    assert(pista(Pista, Dist, Tams, Dirs, na, 0, "")),
    retract(pista(Pista, Dist, Tams, Dirs, Nave, HoraAsig, Placa)).

% =========================================================================
% Regla : liberarTodo
% Params: No hay parametros
% =========================================================================

liberarTodo:-
    retractall(pista(_,_,_,_,_,_,_)),
    assert(pista(p1, "1km", [pequena], [ns, eo, oe, sn], na, 0, "")),
    assert(pista(p2-1, "2km", [pequena, mediana], [eo], na, 0, "")),
    assert(pista(p2-2, "2km", [pequena, mediana], [oe], na, 0, "")),
    assert(pista(p3, "3km", [pequena, mediana, grande], [ns, eo, oe, sn], na, 0, "")).

% =========================================================================
% Regla : obtHora
% Params: H - Hora
%         M - Minutos
% =========================================================================

obtHora(H,M) :-
    get_time(TS),
    stamp_date_time(TS,Date9,'local'),
    arg(4,Date9,H),
    arg(5,Date9,M).

% =========================================================================
% Regla : horaActual
% Params: R - Resultado de transformar la hora a formato militar
% =========================================================================

horaActual(R):-
    obtHora(H,M),
    M >= 60, NM is 0, NH is H+1,
    R is NH*100 + NM.

horaActual(R):-
    obtHora(H,M),
    R is H*100 + M.

% =========================================================================
% Regla : validarHora
% Params: H - Hora en formato militar
%         NH - Nueva hora validada
% =========================================================================

validarHora(H, NH):-
    R is mod(H,100), R >= 60,
    NH is H+40.

validarHora(H, NH):-
    NH is H.
