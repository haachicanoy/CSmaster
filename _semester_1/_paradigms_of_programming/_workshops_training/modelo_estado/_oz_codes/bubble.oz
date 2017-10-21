% Punto 5
% Harold Armando Achicanoy Estrella

local
   fun {Sort Xs}
      fun {BubbleSort Xs}
         case Xs
         of X1|X2|Xr andthen X2 < X1 then X2|{BubbleSort X1|Xr}
         [] X1|X2|Xr andthen X1 =< X2 then X1|{BubbleSort X2|Xr}
         [] X|nil then X|nil
         end
      end

      fun {Sort Xs I}
         if I > 0 then {Sort {BubbleSort Xs} I-1}
         else Xs
         end
      end
   in
      {Sort Xs {Length Xs}}
   end
in
   {Browse {Sort [3 4 2 1 5]}}
end

procedure bubbleSort( A : list of sortable items )
    n = length(A)
    repeat 
        swapped = false
        for i = 1 to n-1 inclusive do
            /* if this pair is out of order */
            if A[i-1] > A[i] then
                /* swap them and remember something changed */
                swap( A[i-1], A[i] )
                swapped = true
            end if
        end for
    until not swapped
	  end procedure