% Punto3: Implementando proceso cliente-servidor contador
% Implemented by: Harold Achicanoy
% MPP 2017-2

% Abstraccion NuevoObjetoPuerto con estado
declare
fun {NuevoObjetoPuerto Inic Fun}
   Sen Ssal in
   thread {FoldL Sen Fun Inic Ssal} end
   {NewPort Sen}
end

% Abstraccion NuevoObjetoPuerto2 reactivo
declare
fun {NuevoObjetoPuerto2 Proc}
   Sen in
   thread for Msj in Sen do {Proc Msj} end end
   {NewPort Sen}
end

% Funcion Contador
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

declare
X = a|a|a|b|c|a|a|b|b|c|c|c|_
{Browse {Contador X}}

declare P in
local S in
   {NewPort S P}
   thread {Browse {Contador S}} end
end
{Send P a}
{Send P b}
{Send P c}
{Send P a}



declare P1 P2 P3 P4 in
local S1 S2 S3 S4 in
   {NewPort S1 P1}
   {NewPort S2 P2}
   {NewPort S3 P3}
   {NewPort S4 P4}
   thread {Contador S1|S2|S3|S4|_} end
end


declare
proc {ProcServidor Msj}
   case Msj
   of calc(X Y) then
      Y = X*X+2.0*X+2.0
   end
end
Servidor={NuevoObjetoPuerto2 ProcServidor}

declare
proc {ProcCliente Msj}
   case Msj
   of valor(Y) then Y1 Y2 in
      {Send Servidor calc(10.0 Y1)}
      {Wait Y1}
      {Send Servidor calc(20.0 Y2)}
      {Wait Y2}
      Y=Y1+Y2
   end
end
Cliente={NuevoObjetoPuerto2 ProcCliente}
{Browse {Send Cliente valor($)}}
