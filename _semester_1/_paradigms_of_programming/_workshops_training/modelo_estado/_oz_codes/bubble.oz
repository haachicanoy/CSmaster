% Punto 5
% Harold Armando Achicanoy Estrella

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
declare
fun {BubbleSort A}
   Sc={NewCell false} % Initial state condition
   fun {CalcSort A}
      for I in 1..({Array.high A}-1)
      do
	 if A.(I+1) < A.I then Ip={NewCell 0} in
	    Ip:=A.I
	    A.I:=A.(I+1) % Contenido de A.(I+1)
	    A.(I+1):=@Ip % Contenido de A.I
	    Sc:=true
	 end % End if
      end % End for loop
      @Sc
   end % End CalcSort function
   fun {SimWhile}
      if {CalcSort A} then {SimWhile} else A end
   end
in
   {SimWhile}
end % End BubbleSort function

% Test it
declare
A = {Array.new 1 5 0}
A.1:=3
A.2:=2
A.3:=4
A.4:=1
A.5:=5
for J in 1..5 do
   {Browse J#A.J}
end
{Browse {BubbleSort A}}
for J in 1..5 do
   {Browse J#A.J}
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%