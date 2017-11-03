% Punto1: Implementando puertos con celdas
% Implemented by: Harold Achicanoy
% MPP 2017-2

% OPERACIONES BASICAS DE LOS PUERTOS
% {NuevoPuerto S P}; S: flujo; P: puerto
% {Enviar P X}; P: puerto; X: mensaje a ser enviado por el puerto

declare
fun {PilaNueva}
   C={NewCell nil}
   proc {Colocar E} C:=E|@C {Browse @C} end
   fun {Sacar} case @C of X|S1 then C:=S1 X end end
   fun {EsVacia} @C==nil end
in
   proc {$ Msj}
      case Msj
      of colocar(X) then {Colocar X}
      [] sacar(?E) then E={Sacar}
      [] esVacia(?B) then B={EsVacia}
      end
   end
end

declare S X=5
{Browse {S colocar(X)}}
{Show S}

declare
fun {Puerto}
   proc {NuevoPuerto ?S ?P}
      P = {NewCell nil}
      S = !!P
   end
   proc {Enviar P X}
      P:=@P|X
   end
in
   proc {$ Msj}
      case Msj
      of nuevoPuerto(S P) then P={NuevoPuerto S}
      [] enviar(X) then {Enviar P X}
      end
   end
end


{Browse Puerto}

declare S P
P = {NuevoPuerto(S)}
{Browse S}
{Enviar P a}
{Enviar P b}


declare S P in
{NewPort S P}
{Browse S}
{Send P a}
{Send P b}
















declare S P
P = {Port}