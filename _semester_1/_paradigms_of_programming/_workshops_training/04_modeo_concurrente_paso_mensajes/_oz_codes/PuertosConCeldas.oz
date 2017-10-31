% Punto1: Implementando puertos con celdas
% Implemented by: Harold Achicanoy
% MPP 2017-2

% OPERACIONES BASICAS DE LOS PUERTOS
% {NuevoPuerto S P}; S: flujo; P: puerto
% {Enviar P X}; P: puerto; X: mensaje a ser enviado por el puerto

fun {PilaNueva}
   C={NewCell nil}
   proc {Colocar E} C:=E|@C end
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

fun {Puerto}
   C={NewCell nil}
   fun {NuevoPuerto} end
   fun {Enviar} end
end

declare S P
{NewPort S P}
declare P X
{Send P X}