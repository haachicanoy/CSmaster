% Taller de programacion relacional
% Autor: Harold Achicanoy
% MPP 2017-2

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Funciones base
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
% Punto 1
% Implementacion del procedimiento Menor
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

declare
proc {Menor T1 T2 Minimo}
   if T1.2<T2.2 then Minimo=T1
   else if T2.2<T1.2 then Minimo=T2
	else choice Minimo=T1 [] Minimo=T2 end
	end
   end
end

%% Pruebas
{Browse {SolveAll proc {$ Min} {Menor t(a 3) t(b 5) Min} end }}
{Browse {SolveAll proc {$ Min} {Menor t(a 5) t(b 3) Min} end }}
{Browse {SolveAll proc {$ Min} {Menor t(a 3) t(b 3) Min} end }}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Punto 2
% Implementacion del procedimiento PMinimo
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

declare
proc {PMinimo Lista Minimo}
   AuxOperator
in
   proc{AuxOperator H T Minimo}
      case T of nil then Minimo=H
      [] Htail|Ttail then MinimoTemp in
	 {AuxOperator Htail Ttail MinimoTemp}
	 {Menor H MinimoTemp Minimo}
      end
   end
   case Lista of nil then Minimo=nil
   [] H|T then {AuxOperator H T Minimo} end      
end

fun {MinimoLista L}
   proc {$ M}
      {PMinimo L M}
   end
end
{Browse {SolveAll {MinimoLista [t(d 2) t(b 3)]}}}
{Browse {SolveAll {MinimoLista [t(d 2) t(b 3) t(c 4) t(a 2) t(e 5)]}}}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Punto 3
% Implementacion del procedimiento LOrd
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

declare
proc {LOrd Lista ListaOrd}
   if Lista==nil then ListaOrd=nil
   else
      Resto Minimo
   in
      Minimo={PMinimo Lista}
      Resto={List.subtract Lista Minimo}
      ListaOrd=Minimo|{LOrd Resto}
   end
end

fun {OrdenarLista Lista}
   proc {$ LO}
      {LOrd Lista LO}
   end
end
{Browse {SolveAll {OrdenarLista [t(d 2) t(b 3) t(c 4) t(a 2) t(e 5)]}}}
