%%% Authors:
%%%   Jefferson A Pena
%%%
%%% This file is part of Course Models And Paradigms 
%%% 2017-2
%%%
%%% Spa: 
%%% By JAPeTo
%%%
declare fun {NuevoObjetoPuerto Inic Fun}
	   Sen Ssal in thread {FoldL Sen Fun Inic Ssal}end {NewPort Sen}
	end
%%% Implementacion de Celda
declare
fun{NuevaCelda X} %% NuevaCelda: X valor a almacenar
   %% Crea una celda nueva, con contenido inicial X
   {NuevoObjetoPuerto estado(X)
    fun{$ estado(X) Msg} %% $: estado-> alamcena los datos, Msg -> Mensaje del cliente
       %% funcion anonima que permite asignar o acceder a la "celda"
       case Msg of %% en caso de las mensajes
	  asignar(E) then estado(E) %% operacion que modifica el estado con el valor de Entrada
       [] acceder(R) then R=X estado(X) %% operacion que asigna el valor de X en R
	                                %% Y retorna el estado sin modificar
       end
    end
   } %% NuevoObjetoPuerto: estado incial, funcion que modifica el estado
end
declare proc{Acceder C X}
	   %% Liga X con el contenido actual de la celda C.
	   {Send C acceder(X)} end
declare proc{Asignar C X}
	   %% Coloca a X como el contenido nuevo de la celda C
	   {Send C asignar(X)} end

declare C1 R R1 in
C1 = {NuevaCelda 36}
{Acceder C1 R}
{Browse 'Celda: '#R}
{Asignar C1 896}
{Acceder C1 R1}
{Browse 'Celda: '#R1}
