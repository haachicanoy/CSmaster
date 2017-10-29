%%%
%%% Authors:
%%%   Jefferson A Pena
%%%
%%% This file is part of Course Models And Paradigms 
%%% 2017-2
%%%
%%% 
%%% Spa: 
%%% By JAPeTo
%%%
%%% Calcula el factorial de N
%%%
declare
fun {Fact N}
   local
      F = {NewCell 1} %% Valor inicial
   in
      for I in 1..N do %% Va desde 1 hasta al N de entrada
	 F := @F * I  %% Multiplicacion actual con lo que llevo en F
      end
      @F %% Retorno el contenido en F
   end
end
%%%%%%%%%%%%%%%%%
declare X = {Fact 1}
{Browse X} % Display 1
declare Z = {Fact 5}
{Browse Z} % Display 120
