declare
fun{Cnt L A}
   R in
   case L of X|Xr then
      R={Mezclar X A}
      R|{Cnt Xr R}
   else nil end
end

fun{Mezclar Cabeza L}
   case L of X|Xr then
      case X of H#T then
	 if H==Cabeza then
	    H#T+1|Xr
	 else
	    H#T|{Mezclar Cabeza Xr}
	 end
      else nil end
   else Cabeza#1|nil end
end
   
fun{Counter Xs}
   thread {Cnt Xs nil} end
end

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


declare P
P={NuevoObjetoPuerto {Counter _} nil}
{Send P a|c|_}
{Send P b|c|b|_}
{Send P a|a|_}
