% Punto 4.b: Implementando la funcion Contador2
% Implemented by: Harold Achicanoy
% MPP 2017-2

% Abstraccion NuevoObjetoPuerto con estado
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

% Funcion Contador2
declare
fun {Contador Xs}
   local
      fun {ListarContar Patron Xs}
	 case Xs of X|Xr then
	    case X of A#B then
	       if A==Patron then A#B+1|Xr
	       else A#B|{ListarContar Patron Xr}
	       end
	    else nil end
	 else Patron#1|nil end
      end
      fun {Acumulador Xs Patron} Tupla in
	 case Xs of X|Xr then
	    Tupla={ListarContar X Patron}
	    Tupla|{Acumulador Xr Tupla}
	 else nil end
      end
   in
      thread {Acumulador Xs nil} end
   end
end

% Funcion Counter
Counter={NewPort Output}
{Send Counter {Contador Xs}}
