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
      thread {Browse Xs}{Acumulador Xs nil} end
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

declare
proc {Merge L1 L2 L3 L4 L}
   P={NewPort L}
   proc {Forward X}
      {Send P X}
   end
in
   thread {ForAll L1 proc {$ X} {Forward X} {Delay 1000} end} end
   thread {ForAll L2 proc {$ X} {Forward X} {Delay 1100} end} end
   thread {ForAll L3 proc {$ X} {Forward X} {Delay 1200} end} end
   thread {ForAll L4 proc {$ X} {Forward X} {Delay 1300} end} end
end

declare
L1={MakeList 1000} {ForAll L1 proc{$ X} X=a end}
L2={MakeList 1000} {ForAll L2 proc{$ X} X=b end}
L3={MakeList 1000} {ForAll L3 proc{$ X} X=c end}
L4={MakeList 1000} {ForAll L4 proc{$ X} X=d end}

{Browse {Merge L1 L2 L3 L4}}
{Browse L1}



declare
proc {ProcServidor Msj}
   case Msj of contador(Xs) then {Browse {Contador Xs}} end
end
Servidor={NuevoObjetoPuerto2 ProcServidor}

declare
proc {ProcCliente Msj}
   case Msj of lista then
      Xs1={MakeList 1000} {ForAll Xs1 proc{$ X} X=a end}
      Xs2={MakeList 1000} {ForAll Xs2 proc{$ X} X=b end}
   in
      {Send Servidor contador(Xs1)}
      {Send Servidor contador(Xs2)}
   end
end
Cliente={NuevoObjetoPuerto2 ProcCliente}
{Send Cliente lista}


{Browse Servidor}







declare
proc {Merge L1 L2 L3 L4 Sen}
   Servidor={NewPort Sen}
   {Browse {Contador Sen}}
   proc {Forward X}
      {Send Servidor X}
   end
in
   thread {ForAll L1 proc {$ X} {Forward X} {Delay 1000} end} end
   thread {ForAll L2 proc {$ X} {Forward X} {Delay 1100} end} end
   thread {ForAll L3 proc {$ X} {Forward X} {Delay 1200} end} end
   thread {ForAll L4 proc {$ X} {Forward X} {Delay 1300} end} end
end

declare
L1={MakeList 10} {ForAll L1 proc{$ X} X=a end}
L2={MakeList 10} {ForAll L2 proc{$ X} X=b end}
L3={MakeList 10} {ForAll L3 proc{$ X} X=c end}
L4={MakeList 10} {ForAll L4 proc{$ X} X=d end}

{Browse {Merge L1 L2 L3 L4}}
