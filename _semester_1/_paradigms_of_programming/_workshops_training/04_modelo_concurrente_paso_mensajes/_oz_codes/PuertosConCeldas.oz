% Punto 1: Implementando puertos con celdas
% Implemented by: Harold Achicanoy
% MPP 2017-2

% OPERACIONES BASICAS DE LOS PUERTOS
% {NuevoPuerto S P}; S: flujo; P: puerto
% {Enviar P X}; P: puerto; X: mensaje a ser enviado

declare
fun {NuevoPuerto S}
   P = {NewCell S} % P: celda que simula el puerto
   proc {Enviar X} % {Enviar P X}
      %P:=@P|X
      %{Browse @P}
      Z Ant in {Exchange P Ant Z} % X: valor a ser enviado
      Ant=X|Z
      % Z: variable sin ligar
      %{Browse @P}
   end
in
   proc {$ Msj} % Invocacion del procedimiento Enviar
      case Msj
      of enviar(X) then
	 {Enviar X}%{Browse run#enviar#X}{Enviar X}
      end
   end
end

declare
proc {Enviar P X}
   {P enviar(X)}
end


declare S P
P = {NuevoPuerto S}
{Enviar P a}
{Enviar P b}
{Enviar P c}
{Enviar P a}