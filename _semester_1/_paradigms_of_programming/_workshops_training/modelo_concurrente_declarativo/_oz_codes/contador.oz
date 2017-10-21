% Punto 4

declare

fun {Counter X}
end
fun {$ P X}
   case X of Xh|Xt then
      case Xh of Chr#Cnt then
	 if Chr == P then
	    Chr#B+1|Xt
	 else
	    Chr#B|{$ P Xt}
	 end
      else nil end
   else P#1|nil end
end
fun {$ X Y}
   Z in
   case X of Xh|Xt then
      Z = {}
end

declare
Xs = a|b|c|d|a|a|b
fun {CountChar X}
   case X of nil then nil
   [] X1 then 1 end
end
{Browse {CountChar Xs.1}}
{Browse Xs}
declare
fun {Counter Xs}
   case Xs of nil then nil
   [] X|Xr then Ys in
      thread Ys = X#{CountChar X}|{Counter Xr} end
   end
end
{Browse {Counter Xs}}



local
   InS
in
   {Browse {Counter InS}}
   InS = a|b|c|_
end
