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
%%% Calcula el valor fibonacci de N
%%%
declare
fun{Fib N}
   local
      Sum = {NewCell 0} %% Celda para el acumulador
      Fn1 = {NewCell 0} %% Celda para el primer sumando
      Fn2 = {NewCell 1} %% Celda para el segundo sumando
   in    
      for I in 1..N do %% Va hasta el valor de la entrada
	 Sum := @Fn1 + @Fn2 %% Suma los operandos 
	 Fn1 := @Fn2 
	 Fn2 := @Sum
      end
      @Fn1
   end
end
%%%%%%%%
declare X = {Fib 6}
{Browse X} % Display 8
declare Y = {Fib 8}
{Browse Y} % Display 21