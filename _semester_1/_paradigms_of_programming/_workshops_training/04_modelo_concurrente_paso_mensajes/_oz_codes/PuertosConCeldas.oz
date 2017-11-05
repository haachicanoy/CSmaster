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
      % Z: variable sin ligar
      % Ant: se liga con el contenido antiguo de la celda P
      % para hacer la concatenacion de X y Z
      Z Ant in {Exchange P Ant Z}
      Ant=X|Z
   end
in
   proc {$ Msj} % Invocacion del procedimiento Enviar
      case Msj
      of enviar(X) then
	 {Enviar X}
      end
   end
end

declare
proc {Enviar P X}
   {P enviar(X)}
end

%% Prueba
declare S P
P = {NuevoPuerto S}
{Browse S}
{Enviar P a}
{Enviar P b}
{Enviar P c}
{Enviar P a}
