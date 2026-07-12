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

/*

Si se puede resolver con forall o not, no usamos findall!!
nuncaMurio(Jugador):-
    jugador(Jugador),
    findall(Death, kda(_, Jugador, _, Death, _), Deaths),
    sum_list(Deaths, 0).

*/

nuncaMurio(Jugador):-
    jugador(Jugador),
    not(murioAlgunaVez(Jugador)).

murioAlgunaVez(Jugador):-
    kda(_, Jugador, _, Deaths, _),
    Deaths > 0.


%Acá si es necesario usar findall, necesitamos acumular las kills para sumarlas
killsTotales(Jugador, CantidadKills):-
    jugador(Jugador),
    findall(Kill, kda(_, Jugador, Kill, _, _), Kills),
    sum_list(Kills, CantidadKills).

/*
Esta versión es MENOS declarativa

fueHardCarryAlgunaVez(Jugador):-
    jugador(Jugador),
    findall(Partida, composicion(Partida, Jugador, _, hardCarry), PartidasEnLaQueFueCarry),
    length(PartidasEnLaQueFueCarry, VecesQueFueCarry),
    VecesQueFueCarry >= 1.
*/

%Se puede resolver con la regla: fue hard carry alguna vez si existe una composición donde fue hard carry
fueHardCarryAlgunaVez(Jugador):-
    composicion(_, Jugador, _, hardCarry).

/*Que siempre gano se puede decir como "para cada partida que jugó, la gano" -> se puede resolver con forall
siempreGano(Equipo):-
    composicion(_, _, Equipo, _),
    findall(Partida, gano(Partida, _), PartidasTotales),
    findall(PartidaQueGano, gano(PartidaQueGano, Equipo), PartidasQueGanaron),
    length(PartidasTotales, CantidadPartidasTotales),
    length(PartidasQueGanaron, CantidadPartidasTotales).
*/

equipo(Equipo):-
    composicion(_, _, Equipo, _).

jugo(Equipo, Partida):-
    composicion(Partida, _, Equipo, _).

siempreGano(Equipo):-
    equipo(Equipo),
    forall(jugo(Equipo, Partida), gano(Partida, Equipo)).

/* Esto se puede pensar como "para todo rol, el jugador jugo ese rol" -> se puede resolver con forall
fueDeTodosLosRoles(Jugador):-
    jugador(Jugador),
    findall(Rol, composicion(_, Jugador, _, Rol), RolesQueUso),
    member(hardCarry, RolesQueUso),
    member(mid, RolesQueUso),
    member(offlane, RolesQueUso),
    member(hardsupport, RolesQueUso),
    member(softSupport, RolesQueUso).
*/

rol(Rol):-
    composicion(_, _, _, Rol).

fueDeTodosLosRoles(Jugador):-
    jugador(Jugador),
    forall(rol(Rol), composicion(_, Jugador, _, Rol)).


% Necesito el findall porque necesito acumular los roles en una cantidad
cantidadDeRolesQueUso(Jugador, Cantidad):-
    jugador(Jugador),
    findall(Rol, composicion(_, Jugador, _ , Rol), RolesQueUso),
    list_to_set(RolesQueUso, RolesSinRepetidos),
    length(RolesSinRepetidos, Cantidad).

/* Se puede pensar como "para toda partida que jugo, la gano" -> uso forall
nuncaPerdio(Jugador):-
    jugador(Jugador),
    findall(Partida, (composicion(Partida, Jugador, Equipo , _ ), not(gano(Partida, Equipo))), PartidasPerdidas),
    length(PartidasPerdidas, 0).
*/

nuncaPerdio(Jugador):-
    jugador(Jugador),
    forall(composicion(Partida, Jugador, _, _), laGano(Jugador, Partida)).

laGano(Jugador, Partida):-
    composicion(Partida, Jugador, Equipo, _),
    gano(Partida, Equipo).

/* Se puede pensar como no existe una partida donde el rol haya sido diferente
siempreUsoElMismoRol(Jugador):-
    jugador(Jugador),
    findall(Rol, composicion(_, Jugador, _, Rol), RolesQueUso),
    list_to_set(RolesQueUso, RolesSinRepetidos),
    length(RolesSinRepetidos, 1).
*/

siempreUsoElMismoRol(Jugador):-
    composicion(_, Jugador, _, Rol),
    not(usoRolDiferente(Jugador, Rol)).

usoRolDiferente(Jugador, Rol):-
    composicion(_, Jugador, _, OtroRol),
    OtroRol \= Rol.

%%%%%%%%%%% Nuevos requerimientos %%%%%%%%%%%%%

%valor/3 -> Jugador, Partida, Valor
valor(Jugador, Partida, Valor):-
    kda(Partida, Jugador, Kills, Deaths, Assists),
    Valor is Kills * 2 + Assists / 4 - Deaths * 3.

%cumplioSuRolEn/2 -> Jugador, Partida
cumplioSuRolEn(Jugador, Partida):-
    composicion(Partida, Jugador, _, Rol),
    valor(Jugador, Partida, Valor),
    valorEsperadoPara(Rol, ValorEsperado),
    Valor > ValorEsperado.

% valorEsperadoPara/2 -> Rol, ValorEsperado
valorEsperadoPara(Rol, Valor):-
    categoriaDe(Rol, Categoria),
    valorParaCategoria(Categoria, Valor).

% valorParaCategoria/2 -> Categoria, Valor
valorParaCategoria(offlane, 400).
valorParaCategoria(support, 250).
valorParaCategoria(danio, 500).

%categoriaDe/2 -> Rol, Categoria
categoriaDe(offlane, offlane).
categoriaDe(hardsupport, support).
categoriaDe(softSupport, support).
categoriaDe(mid, danio).
categoriaDe(hardCarry, danio).

%leGustaSupportear/1 -> Jugador - Para cada rol que tuvo el jugador, el rol es support
leGustaSupportear(Jugador):-
    jugador(Jugador),
    forall(composicion(_, Jugador, _, Rol), categoriaDe(Rol, support)).

%fueMvp/2 -> Jugador, Partida - Para cada valor que hubo en esa partida, el valor del jugador es mayor o igual
fueMvp(Jugador, Partida):-
    valor(Jugador, Partida, Valor),
    forall(valor(_, Partida, OtroValor), Valor >= OtroValor).

%noTuvoSuMomento/1 -> Jugador - No existe una partida donde haya sido mvp
noTuvoSuMomento(Jugador):-
    jugador(Jugador),
    not(fueMvp(Jugador, _)).