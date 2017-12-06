% Modelo de programacion relacional
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
   [] alternatives(N) then
      {SolLoop S 1 N Rest}
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
% Ejemplo numeros de un digito
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

declare
fun {Digito}
   choice 0 [] 1 [] 2 [] 3 [] 4 [] 5 [] 6 [] 7 [] 8 [] 9 end
end

{Browse {SolveAll Digito}}

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



% Inicios del taller de programacion relacional
% if t(a 3).2 < t(b 3).2 then {Browse true} else {Browse repeated} end
% if t(a 3).1 < t(b 3).1 then {Browse true} else {Browse repeated} end
% if t(b 3).1 < t(a 3).1 then {Browse true} else {Browse repeated} end
% {Browse t(a 3).2}

%declare
%proc {Menor T1 T2 Minimo}
%   if {Bool.and T1.1<T2.1 T1.2<T2.2} then Minimo=T1
%   else if {Bool.and T2.1<T1.1 T2.2<T1.2} then Minimo=T2
%	else choice Minimo=T1 [] Minimo=T2 end
%	end
%   end
%end

%{Browse {Menor t(a 3) t(b 5)}}
%{Browse {Menor t(b 5) t(a 3)}}
%{Browse {Menor t(a 3) t(b 3)}}
%{Browse {SolveAll proc {$ Min} {Menor t(a 3) t(b 5) Min} end }}
%{Browse {SolveAll proc {$ Min} {Menor t(a 5) t(b 3) Min} end }}
%{Browse {SolveAll proc {$ Min} {Menor t(a 3) t(b 3) Min} end }}

% Punto 1

declare
proc {Menor T1 T2 Minimo}
   if T1.2<T2.2 then Minimo=T1
   else if T2.2<T1.2 then Minimo=T2
	else choice Minimo=T1 [] Minimo=T2 end
	end
   end
end

{Browse {Menor t(a 3) t(b 5)}}
{Browse {Menor t(b 5) t(a 3)}}
{Browse {Menor t(a 3) t(b 3)}}
{Browse {SolveAll proc {$ Min} {Menor t(a 3) t(b 5) Min} end }}
{Browse {SolveAll proc {$ Min} {Menor t(a 5) t(b 3) Min} end }}
{Browse {SolveAll proc {$ Min} {Menor t(a 3) t(b 3) Min} end }}

% Punto 2
declare
proc{Aux H T Minimo}
   case T of nil then Minimo=H
   [] Htail|Ttail then MinimoTemp in
      {Aux Htail Ttail MinimoTemp}
      {Menor H MinimoTemp Minimo}
   end
end

proc {PMinimo Lista Minimo}
   case Lista of nil then Minimo=nil
   [] H|T then {Aux H T Minimo} end      
end

fun {MinimoLista L}
   proc {$ M}
      {PMinimo L M}
   end
end
{Browse {SolveAll {MinimoLista [t(d 2) t(b 3)]}}}
{Browse {SolveAll {MinimoLista [t(d 2) t(b 3) t(c 4) t(a 2) t(e 5)]}}}
