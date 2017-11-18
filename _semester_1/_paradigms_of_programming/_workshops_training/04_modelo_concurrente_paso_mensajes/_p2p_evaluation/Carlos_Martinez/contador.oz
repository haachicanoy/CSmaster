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

declare P in
local S in
   {NewPort S P}
   thread for M in S do {Browse {Counter M}}end end
end

{Send P a|c|_}
{Send P b|c|_}
{Send P a|_}