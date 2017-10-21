% Punto 4
% Harold Armando Achicanoy Estrella

declare
fun {Fib N}
   case N of 0 then 1
   [] 1 then 1
   else {Fib N-1} + {Fib N-2} end
end
{Browse {Fib 10}}