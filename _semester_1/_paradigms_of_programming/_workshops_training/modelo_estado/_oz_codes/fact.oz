% Punto 3
% Harold Armando Achicanoy Estrella

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
declare
fun {CalcFact N}
   local C={NewCell 1}
   in
      for I in 0..(N-1)
      do
	 C:=(I+1)*@C
      end
      @C
   end
end
{Browse {CalcFact 3}}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%