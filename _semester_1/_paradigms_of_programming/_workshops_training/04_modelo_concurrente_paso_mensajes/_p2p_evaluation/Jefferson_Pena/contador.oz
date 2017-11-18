%%%
%%% Authors:
%%%   Jefferson A Pena
%%%
%%% This file is part of Course Models And Paradigms 
%%% 2017-2
%%% 
%%% Spa: 
%%% By JAPeTo
%%%
%%% Generar un flujo de salida donde cada posicion
%%% del flujo corresponde al total de
%%% ocurrencias hasta ese momento.
%%% y registra las ocurrencias de caracteres en un flujo de entrada
%%%
declare
fun {Contador S}
   %% Contador es una funcion que recibe un flujo y deacuerdo a lo que se envio
   %% antes, realiza el conteo de las ocurrencias
   fun {Aux S R}  % Auxiliar
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
      Occ %%% Retorno la nueva cinta con las ocurrencias contadas
   in
      case S of nil then nil % si la Lista es vacia retorne vacia
      [] H|T then % Si tiene cabeza y cola
	 Occ = {Occurrences R H}
	 Occ|thread {Aux T Occ} end % Hilo creador de listas con ocurrecias
      end
   end
in
   {Aux S nil} %% Retorno lo que se va creando
end

declare P in
local S MaxDelay Low in
   MaxDelay = 30  %% Demora para los clientes
   {NewPort S P}  %% Creo un puerto P con flujo S
   %%% Muestro el flujo
   {Browse 'recibo en el puerto: '#S}
   %%% Explicaccion del cliente
   thread
      T in T={OS.rand} mod MaxDelay                      %% Creo T, un tiempo aleatorio 
      {Browse 'Envio en: '#T#' milliseconds' }{Delay T } %% Muestro un mensaje de demora de este cliente
      {Send P a}                                         %% Envia a al puerto
   end
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
   {Browse 'Salida:'#{Contador S}}
end

%%%%%%%% Esta no es la unica salida posible (La que la figura ilustra).
%% ¿Por que?
%%%% Los usuarios puede enviar sus mensajes en el orden que ellos deseen
%%%% y no hay un orden especifico o de ante mano no se sabe en que orden
%%%% llegaran los mensajes. -
%%%%%% Por esta razon en la solucion se establecieron tiempos
%%%%%% aleatorios, para destacar que no hay un orden.

%% ¿Cuales son las otras posibles salidas para la misma entrada?
%%%% Las salidas en este caso depende del orden en que sean enviados los
%%%% mensajes y como no se encuentra presestablecido se convierten
%%%% en un problema combinatorio, donde depende de cuantos sean los 
%%%% clientes y todos los posibles ordenes en que se envien los mensajes
%%%%%% Note que en esta solucion, los tiempos aleatorios logran modelar 
%%%%%% esta situacion Y cada vez que se ejecuta depende de a que hilo 
%%%%%% "le de la mano" el procesador cada uno de esa es una posible salida.