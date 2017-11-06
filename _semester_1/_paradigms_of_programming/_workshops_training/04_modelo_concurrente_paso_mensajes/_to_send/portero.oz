% Punto 4.a: Implementando la funcion Portero
% Implemented by: Harold Achicanoy
% MPP 2017-2

% Abstraccion NuevoObjetoPuerto
declare
fun {NuevoObjetoPuerto Inic}
   proc {MsgLoop S1 Estado}
      case S1 of Msg|S2 then
	 case Msg % Adicion de funciones para generar el conteo
	 of getIn(N) then {MsgLoop S2 Estado+N}
	 [] getOut(N) then {MsgLoop S2 Estado-N}
	 [] getCount(N) then N=Estado {MsgLoop S2 Estado}
	 end
      [] nil then skip
      end
   end
   Sin
in
   thread {MsgLoop Sin Inic} end
   {NewPort Sin}
end

%% Prueba
declare
Portero={NuevoObjetoPuerto 0} X Y Z
{Browse X#Y#Z}
{Send Portero getIn(5)}
{Send Portero getOut(2)}
{Send Portero getCount(X)}
{Send Portero getIn(2)}
{Send Portero getOut(5)}
{Send Portero getCount(Y)}
{Send Portero getIn(16)}
{Send Portero getOut(4)}
{Send Portero getCount(Z)}
