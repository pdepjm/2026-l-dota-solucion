% ignorar esta linea :)
:-style_check(-discontiguous).

% ===================== PARTIDA 1 =====================

% composicion(Partida, Jugador, Equipo,Rol)
composicion(partida1, arteezy, azul, hardCarry).
composicion(partida1, puppey, azul, hardsupport).
composicion(partida1, ceb, azul, offlane).
composicion(partida1, jerax, azul, softSupport).
composicion(partida1, miracle, azul, hardCarry).

composicion(partida1, topson, rojo, mid).
composicion(partida1, n0tail, rojo, hardsupport).
composicion(partida1, sumail, rojo, mid).
composicion(partida1, bulldog, rojo, offlane).
composicion(partida1, crit, rojo, softSupport).

% kda(Partida, Jugador, Kills, Deaths, Assists)
kda(partida1, arteezy, 14, 4, 5).
kda(partida1, miracle, 13, 3, 6).
kda(partida1, topson, 11, 5, 7).
kda(partida1, sumail, 9, 6, 8).
kda(partida1, ceb, 5, 7, 6).
kda(partida1, bulldog, 4, 8, 5).
kda(partida1, jerax, 7, 5, 12).
kda(partida1, crit, 6, 6, 11).
kda(partida1, puppey, 1, 6, 19).
kda(partida1, n0tail, 1, 0, 22).

gano(partida1, rojo).
% Representa que la partida 1 la ganó el equipo rojo.


% ===================== PARTIDA 2 =====================

% composicion(Partida, Jugador, Equipo, Rol)
composicion(partida2, ramzes, azul, hardCarry).
composicion(partida2, dendi, azul, mid).
composicion(partida2, s4, azul, offlane).
composicion(partida2, gh, azul, softSupport).
composicion(partida2, kuroky, azul, hardsupport).

composicion(partida2, ana, rojo, hardCarry).
composicion(partida2, somnus, rojo, mid).
composicion(partida2, faithbian, rojo, offlane).
composicion(partida2, xnova, rojo, softSupport).
composicion(partida2, fy, rojo, hardsupport).

% kda(Partida, Jugador, Kills, Deaths, Assists)
kda(partida2, ana, 16, 2, 8).
kda(partida2, ramzes, 12, 5, 9).
kda(partida2, somnus, 10, 4, 11).
kda(partida2, dendi, 8, 6, 10).
kda(partida2, faithbian, 6, 7, 9).
kda(partida2, s4, 5, 6, 12).
kda(partida2, gh, 3, 4, 17).
kda(partida2, fy, 2, 5, 18).
kda(partida2, xnova, 4, 6, 15).
kda(partida2, kuroky, 1, 7, 20).

gano(partida2, rojo).


jugador(Jugador):-
    composicion(_,Jugador,_,_).

nuncaMurio(Jugador):-
    jugador(Jugador),
    findall(Death, kda(_, Jugador, _, Death, _), Deaths),
    sum_list(Deaths, 0).

killsTotales(Jugador, CantidadKills):-
    jugador(Jugador),
    findall(Kill, kda(_, Jugador, Kill, _, _), Kills),
    sum_list(Kills, CantidadKills).

fueHardCarryAlgunaVez(Jugador):-
    jugador(Jugador),
    findall(Partida, composicion(Partida, Jugador, _, hardCarry), PartidasEnLaQueFueCarry),
    length(PartidasEnLaQueFueCarry, VecesQueFueCarry),
    VecesQueFueCarry >= 1.

siempreGano(Equipo):-
    composicion(_, _, Equipo, _),
    findall(Partida, gano(Partida, _), PartidasTotales),
    findall(PartidaQueGano, gano(PartidaQueGano, Equipo), PartidasQueGanaron),
    length(PartidasTotales, CantidadPartidasTotales),
    length(PartidasQueGanaron, CantidadPartidasTotales).

fueDeTodosLosRoles(Jugador):-
    jugador(Jugador),
    findall(Rol, composicion(_, Jugador, _, Rol), RolesQueUso),
    member(hardCarry, RolesQueUso),
    member(mid, RolesQueUso),
    member(offlane, RolesQueUso),
    member(hardsupport, RolesQueUso),
    member(softSupport, RolesQueUso).

cantidadDeRolesQueUso(Jugador, Cantidad):-
    jugador(Jugador),
    findall(Rol, composicion(_, Jugador, _ , Rol), RolesQueUso),
    list_to_set(RolesQueUso, RolesSinRepetidos),
    length(RolesSinRepetidos, Cantidad).

nuncaPerdio(Jugador):-
    jugador(Jugador),
    findall(Partida, (composicion(Partida, Jugador, Equipo , _ ), not(gano(Partida, Equipo))), PartidasPerdidas),
    length(PartidasPerdidas, 0).

siempreUsoElMismoRol(Jugador):-
    jugador(Jugador),
    findall(Rol, composicion(_, Jugador, _, Rol), RolesQueUso),
    list_to_set(RolesQueUso, RolesSinRepetidos),
    length(RolesSinRepetidos, 1).
