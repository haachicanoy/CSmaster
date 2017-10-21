declare 
fun lazy {Gen I}
   I|{Generar I+1}
end
fun lazy {LFilter L F}
   case L
   of nil then
      nil
   [] X|L2 then
      if {F X} then
	 X|{LFilter L2 F}
      else {LFilter L2 F}
      end
   end
end
fun lazy {Sieve Xs}
   X|Xr=Xs in
   X | {Sieve
	{LFilter Xr
	 fun {$ Y} Y mod X \=0 end }
       }
end

declare
proc {ShowPrimes N}
Primes={Sieve {Gen 2}}
{Browse Primes}
{Browse {List.nth Primes N}}
end

{ShowPrimes 4}

