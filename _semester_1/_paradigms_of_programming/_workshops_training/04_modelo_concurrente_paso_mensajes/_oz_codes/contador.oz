% Punto3: Implementando proceso cliente-servidor contador
% Implemented by: Harold Achicanoy
% MPP 2017-2

declare
local
   Ins
   fun{ArmarTuplas Valor L}
      case L of H|T then
	 case H of A#B then
	    if A==Valor then
	       A#B+1|T
	    else
	       A#B|{ArmarTuplas Valor T}
	    end
	 else nil end
      else Valor#1|nil end
   end
   fun{Contar L C} Tupla in
      case L of H|T then
	 Tupla={ArmarTuplas H C}
	 Tupla|{Contar T Tupla}
      else nil end
   end
   fun{Counter L}
      thread {Contar L nil} end
   end
in
   InS=e|f|a|b|c|e|e|a|a|_
   {Browse {Counter InS}}
end