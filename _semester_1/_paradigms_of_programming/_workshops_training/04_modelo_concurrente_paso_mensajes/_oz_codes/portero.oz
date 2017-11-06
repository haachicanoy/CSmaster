% Punto 4.a: Implementando la funcion Portero
% Implemented by: Harold Achicanoy
% MPP 2017-2

% Funcion Portero
declare
fun {Portero N}
   proc {GetIn N} end
   proc {GetOut N} end
   proc {GetCount N} end
in
   proc {$ Msj}
      case Msj
      of getIn(N) then {GetIn N}
      [] getOut(N) then {GetOut N}
      [] getCount(N) then {GetCount N}
      end
   end
end

% Abstraccion NuevoObjetoPuerto
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

declare Inic
{NuevoObjetoPuerto Portero Inic}