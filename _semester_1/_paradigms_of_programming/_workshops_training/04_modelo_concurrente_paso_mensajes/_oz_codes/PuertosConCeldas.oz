% Punto1: Implementando puertos con celdas
% Implemented by: Harold Achicanoy
% MPP 2017-2

% OPERACIONES BASICAS DE LOS PUERTOS
% {NuevoPuerto S P}; S: flujo; P: puerto
% {Enviar P X}; P: puerto; X: mensaje a ser enviado por el puerto

declare
fun {NuevoPuerto S}
   P = {NewCell nil} % P: celda interna que simula el puerto
   proc {Enviar P X}
      Z in P:=@P|X|Z
   end
in
   proc {$ Msj}
      case Msj of enviar(X) then {Browse run#enviar#X}{Enviar P X} end
   end
end

declare
proc {Enviar P X}
   {P enviar(X)}
end


declare S P
P = {NuevoPuerto S}
{Browse S}
{Browse P}
{Enviar P a}
{Browse S}
{Enviar P b}
{Browse S}
