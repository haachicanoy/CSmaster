% Modelo de programación relacional
% Ejemplos

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Funciones necesarias
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

declare

fun {Solve Script}
   {SolStep {Space.new Script} nil}
end

fun {SolStep S Rest}
   case {Space.ask S}
   of failed then Rest
   [] succeeded then {Space.merge S}|Rest
   [] alternatives(N) then {SolLoop S 1 N Rest}
   end
end

fun lazy {SolLoop S I N Rest}
   if I>N then Rest
   elseif I==N then
      {Space.commit S I}
      {SolStep S Rest}
   else Right C in
      Right={SolLoop S I+1 N Rest}
      C={Space.clone S}
      {Space.commit C I}
      {SolStep C Right}
   end
end

fun {SolveOne F}
   L={Solve F}
in
   if L==nil then nil else [L.1] end
end

fun {SolveAll F}
   L={Solve F}
   proc {TouchAll L}
      if L==nil then skip else {TouchAll L.2} end
   end
in
   {TouchAll L}
   L
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Ejemplo escogencia de pinta
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

declare
fun {Claro}
   choice blanco [] habano end
end
fun {Oscuro}
   choice negro [] azul end
end
proc {Contraste P1 P2}
   choice P1={Claro} P2={Oscuro} [] P1={Oscuro} P2={Claro} end
end
fun {Pinta}
   Camisa Pantalon Medias
in
   {Contraste Camisa Pantalon}
   {Contraste Pantalon Medias}
   if Camisa==Medias then fail end
   pinta(Camisa Pantalon Medias)
end
% {Browse Pinta}
% {Browse pinta#{Pinta}}

declare
Pintas={SolveAll Pinta}
{Browse Pintas}