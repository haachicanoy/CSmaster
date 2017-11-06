% Punto 3: Implementando proceso cliente-servidor contador
% Implemented by: Harold Achicanoy
% MPP 2017-2

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

%% Prueba Contador declarativo
declare
X = a|a|a|b|c|a|a|b|b|c|c|c|_
{Browse {Contador X}}

%% Definicion del puerto Servidor con 4 Clientes
declare
proc {Merge L1 L2 L3 L4 Sen}
   Servidor={NewPort Sen} % Creacion del puerto Servidor
   {Browse {Contador Sen}}
   proc {Forward X}
      {Send Servidor X} % Envio de mensajes a traves del Servidor
   end
in % Envio de mensajes por 4 Clientes
   thread {ForAll L1 proc {$ X} {Forward X} {Delay 1000} end} end
   thread {ForAll L2 proc {$ X} {Forward X} {Delay 1000} end} end
   thread {ForAll L3 proc {$ X} {Forward X} {Delay 1000} end} end
   thread {ForAll L4 proc {$ X} {Forward X} {Delay 1000} end} end
end

%% Prueba
declare
L1=a|c|_
L2=b|c|_
L3=a|_
L4=a|a|b|c|_
{Browse {Merge L1 L2 L3 L4}}
