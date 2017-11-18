%%% Authors:
%%%   Jefferson A Pena
%%%
%%% This file is part of Course Models And Paradigms 
%%% 2017-2
%%%
%%% Spa: 
%%% By JAPeTo
%%%
declare
fun {NuevoObjetoPuerto Comp Inic}
   proc {MsgLoop S1 Estado}
      case S1 of Msg|S2 then
	 {MsgLoop S2 {Comp Msg Estado}}
      [] nil then skip
      end
   end
   Sin
in
   thread {MsgLoop Sin Inic} end
   {NewPort Sin}
end

declare
fun{Portero}
   %% Crea un puerto 
   {NuevoObjetoPuerto 
    fun{$ Msg Estado} %% Funcion que recibe un mensaje y un estados
       {Show 'Mensaje Recibido: '#Msg} %% mensaje de depuracion
       case Msg of 
	  getIn(N) then Estado+N  % Incrementa el estado
       [] getOut(N) then Estado-N % Decrementa el estado
       [] getCount(N) then N=Estado % Asigna el estado en la var N
       end
    end
    0}
end
%%% PRUEBA %%%
declare En P in
P={Portero}
{Send P getIn(70)}     %% In 70
{Send P getOut(9)}     %% Out 61 = 70 - 9
{Send P getCount(En)}   %% save in C
{Browse En}             %% Display 61
{Send P getIn(12)}     %% In 73 = 61 + 12
{Browse {Send P getCount($)}} %% Display 73