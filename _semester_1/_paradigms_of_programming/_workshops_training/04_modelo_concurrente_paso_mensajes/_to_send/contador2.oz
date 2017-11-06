% Punto 4.b: Implementando la funcion Contador2
% Implemented by: Harold Achicanoy
% MPP 2017-2

% Creacion y conteo de caracteres
declare
fun {ListarContar Patron Xs}
   case Xs of X|Xr then
      case X of A#B then
	 if A==Patron then A#B+1|Xr
	 else A#B|{ListarContar Patron Xr}
	 end
      else nil end
   else Patron#1|nil end
end

% Abstraccion NuevoObjetoPuerto
declare
fun {NuevoObjetoPuerto Comp Inic}
   proc {MsgLoop S1 Estado}
      case S1 of Msg|S2 then
	 {Browse Estado}
	 {MsgLoop S2 {Comp Msg Estado}}
      [] nil then skip
      end
   end
   Sin
in
   thread {MsgLoop Sin Inic} end
   {NewPort Sin}
end

% Implementacion de la funcion Contador2
declare S P
PuertoSalida={NuevoObjetoPuerto S P}
Contador2={NuevoObjetoPuerto
	   fun {$ Patron Xs} Tupla in
	      Tupla={ListarContar Patron Xs}
	      {Send PuertoSalida Tupla}
	      Tupla
	   end nil}

%% Prueba
{Send Contador2 a}
{Send Contador2 a}
{Send Contador2 b}
{Send Contador2 c}
{Send Contador2 d}

