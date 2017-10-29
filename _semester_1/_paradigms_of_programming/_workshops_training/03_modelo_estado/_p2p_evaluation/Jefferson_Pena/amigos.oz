%%%
%%% Authors:
%%%   Jefferson A Pena
%%%
%%% This file is part of Course Models And Paradigms 
%%% 2017-2
%%%
%%% 
%%% Spa: 
%%% By JAPeTo
%%%
%%% Se debe determinar si es posible que todas las
%%% deudas sean pagadas entre las personas si solo
%%% se pasa dinero entre personas que a´un son amigas.
%%%
declare
fun {PagoDeuda L1 L2}
   local
      L3 = {Tuple.toArray {List.toTuple '#' L2}} %% Arrego para poder acceder y modificar posiciones
      T = {NewCell 0} %% Celda donde Temporal
      fun {AllDebtsArePaid L3} %% Valida que todo sea pagado
	 T := true %% Asumo que a todo el mundo le pagan
	 {For {Array.low L3} {Array.high L3} 1 
	  proc {$ I} %% Aplica la validacion a cada elemento del arreglo
	     T := {And @T L3.I >= 0} %% Si hay una cantidad negativa a alguien no le pagaron :( false
	  end}
	 @T %% Retorno la validacion
      end
   in
      for E in L1 do
	 case E of F1#F2 then % Leo cada pareja de amigos
	    T := L3.F1+L3.F2 % Sumo lo que deben y lo que tienen (cantidad neta)
	    L3.F1 := @T % Lo que tengo en dinero es de mis amigos
	    L3.F2 := @T % Y si alguno debe, se le presta :)
	 end
      end
      {AllDebtsArePaid L3} %%% Verifico que todas deudas sean pagadas
   end
end
%%%%%%%%%%%%%%%%% PRUEBAS
{Browse {PagoDeuda [1#2 2#3 4#5] [100 ~75 ~25 ~42 42]}}  %% Display: true
{Browse {PagoDeuda [1#3 2#4] [15 20 ~10 ~25]}} %% Display: false

