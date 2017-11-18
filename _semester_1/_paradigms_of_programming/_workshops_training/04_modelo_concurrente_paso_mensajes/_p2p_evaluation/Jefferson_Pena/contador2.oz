%%% Authors:
%%%   Jefferson A Pena
%%%
%%% This file is part of Course Models And Paradigms 
%%% 2017-2
%%% 
%%% Spa: 
%%% By JAPeTo
%%%
%%% version del servidor Contador usando la abstraccion NuevoObjetoPuerto
%%%
declare fun {NuevoObjetoPuerto Comp Inic}
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
declare fun {Counter Output}
   %% que retorna un objeto puerto.
   fun {Aux Msg Estado}
      fun {Occurrences A Char} % Funcion que cuenta la ocurrencias 
	 case A of nil then [Char#1] % en caso de vacia solo hay una ocurrencia
	 [] H|T then % De lo contrario Head | Tail
	    case H of E#N then % Si H es tupla
	       if E==Char then E#(N+1)|T % Si E es igual al caracter cree la tupa E#Incremento con la cola
	       else H|{Occurrences T Char} % de lo contrario cree la lista con el valor y el llamado recursivo
	       end
	    end
	 end
      end
      Occ
   in
      Occ={Occurrences Estado Msg}
      {Send Output Occ}  %% enviar el estado al puerto de salida
      Occ %%  retorna un objeto puerto
   end
in
   {NuevoObjetoPuerto Aux nil} %% Uso de la abstraccion
end

declare S
Output={NewPort S} %%La variable Output corresponde al flujo de salida
P = {Counter Output}
MaxDelay = 30  %% Demora para los clientes
%%% Otros clientes
thread T in T={OS.rand} mod MaxDelay {Browse 'Envio en: '#T#' milliseconds' }{Delay T } {Send P a} end
thread T in T={OS.rand} mod MaxDelay {Browse 'Envio en: '#T#' milliseconds' }{Delay T } {Send P b} end
thread T in T={OS.rand} mod MaxDelay {Browse 'Envio en: '#T#' milliseconds' }{Delay T } {Send P a} end
thread T in T={OS.rand} mod MaxDelay {Browse 'Envio en: '#T#' milliseconds' }{Delay T } {Send P b} end
thread T in T={OS.rand} mod MaxDelay {Browse 'Envio en: '#T#' milliseconds' }{Delay T } {Send P a} end
thread T in T={OS.rand} mod MaxDelay {Browse 'Envio en: '#T#' milliseconds' }{Delay T } {Send P c} end
thread T in T={OS.rand} mod MaxDelay {Browse 'Envio en: '#T#' milliseconds' }{Delay T } {Send P d} end 
thread T in T={OS.rand} mod MaxDelay {Browse 'Envio en: '#T#' milliseconds' }{Delay T } {Send P e} end
%%%
{Browse 'Salida:'#S}
