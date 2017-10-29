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
%%% Calcula suma entre A y B
%%%
declare
fun{Q A B}
   local      
      C = {NewCell 0} % Var Declarativa ligada a celda
   in   
      for I in A..B do %% Permite ir desde A hasta B
	 C:=(@C+I) %% Incremento
      end
      @C %% Despues del retorno lo que sumo
   end
end
%%%%%%%%%%%%%%%%%
declare X = {Q 2 5}
{Browse X} % Display 14
declare Y = {Q 1 100}
{Browse Y} % Display 5050
declare Z = {Q 90 1000}
{Browse Z} % Display 496495