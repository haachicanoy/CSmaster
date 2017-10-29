%%%
%%% Authors:
%%%   Jefferson A Pena
%%%
%%% This file is part of Course Models And Paradigms 
%%% 2017-2
%%%
%%% Spa: Funciona revisando cada elemento de la lista
%%%      que va a ser ordenada con el siguiente,
%%%      intercambiandolos de posición si estan
%%%      en el orden equivocado.
%%%
%%%
%%% Ordenamiento de burbuja
%%% By JAPeTo
%%%
%%%
declare
proc {BubbleSort A} %%% Entra un arreglo
   for I in 1..{Array.high A} do %%% Itera hasta el mas alto que encuentre
%%%%%%%%%%%%%%% Recorre el todo el arreglo
      {For {Array.high A} I+1 ~1  %% Voy de para atras revisando todos
       proc {$ J}
	  if A.J < A.(J-1) then %% Si el anterior es mayor
	     X = A.I %%%%% Almaceno en la burbuja
	  in
	     {Show X}
	     A.I := A.J %%%%% Intercambio las posiciones
	     A.J := X %%%%% Almaceno el valor de la burbuja
	  end
       end} %%% Parametros de For:
%%%%%%%%%%%%%%% +I1:El mas alto del arreglo
%%%%%%%%%%%%%%% +I2:Posicion actual
%%%%%%%%%%%%%%% +I3:hacia atras (-1) pasos negativos
%%%%%%%%%%%%%%% +P: procedimiento {$ J} que hace el swap
   end
end


%%%%%%%%%%%%%%%%%%%%%%%% Pruebas
declare A  = {Tuple.toArray 8#2#4#6#1#3}     %%%% Cambio un tupla a array
{Browse 'Input'#{Array.toRecord '#' A}}      %%%% Pinto el arreglo entrada
{BubbleSort A}                               %%%% Ordeno burbuja
{Browse 'BubbleSort'#{Array.toRecord '#' A}} %%%% Imprimo el resultado