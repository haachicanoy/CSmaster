% Punto 6 

% a.
% ----------------------------- %
% NOT gate
% ----------------------------- %
declare
proc {NOTGate X ?R}
   case X of Xh|Xt then R=(1-Xh)|{NOTGate Xt} end
end
% b.
% ----------------------------- %
% AND gate
% ----------------------------- %
declare
proc {ANDGate X Y ?Z}
   case X#Y of (Xh|Xt)#(Yh|Yt) then Z = Xh*Yh|{ANDGate Xt Yt} end
end
% ----------------------------- %
% OR gate
% ----------------------------- %
declare
proc {ORGate X Y ?Z}
   case X#Y of (Xh|Xt)#(Yh|Yt) then Z = Xh+Yh-Xh*Yh|{ORGate Xt Yt} end
end


declare
G = gate(value:'or'
	 gate(value:'and'
	      input(x)
	      input(y))
	 gate(value:'not'
	      input(z)))
AG NG OG
fun {Simulate G Xs Ys Zs}
   case G of gate(value:'and' input(x:X) input(y:Y)) then
      X = Xs
      Y = Ys
      thread AG = {ANDGate X Y} end
   [] gate(value:'not' input(z:Z)) then
      Z = Zs
      thread NG = {NOTGate Z} end
   [] gate(value:'or' input(x:X) input(y:Y)) then
      X = AG
      Y = NG
      thread OG = {ORGate X Y} end
   end
end
{Simulate G input(x:1|0|1|0|_ y:0|1|0|1|_ z:1|1|0|0|_ )}
declare
R = {Simulate G 1|0|1|0|_ 0|1|0|1|_ 1|1|0|0|_ }
