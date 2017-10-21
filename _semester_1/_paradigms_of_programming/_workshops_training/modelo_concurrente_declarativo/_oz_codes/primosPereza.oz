% Punto 8

declare
fun lazy {Gen I}
   I|{Gen I+1}
end
fun lazy {LFilter L F}
   case L of nil then nil
   [] X|L2 then
      if {F X} then X|{LFilter L2 F}
      else {LFilter L2 F}
      end
   end
end
fun lazy {Primes Xs}
   X|Xr=Xs in
   X|{Primes {LFilter Xr fun {$ Y} Y mod X \=0 end}}
end

declare
I=2 PrimesList Y Aux
fun {ShowPrimes N}
   PrimesList = {Primes {Gen I}}
   Aux = {ByNeed {List.nth PrimesList N}}
   Y = PrimesList
end

{Browse {ShowPrimes 12}}
