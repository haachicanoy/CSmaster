% Punto 4
% Harold Armando Achicanoy Estrella

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
declare
fun {CalcFib N}
   local
      C={NewCell 1}
   in
      if N<2 then @C
      else
	 for I in 2..N
	 do
	    C:={CalcFib I-1} + {CalcFib I-2}
	 end
	 @C
      end
   end
end
{Browse {CalcFib 7}}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%