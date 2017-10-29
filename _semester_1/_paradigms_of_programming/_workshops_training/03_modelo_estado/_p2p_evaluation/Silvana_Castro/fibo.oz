%Funcion de fibonacci
% fib(n) = 1 si n<2
% fib(n) = fib(n-1) + fib(n-2)  si n>=2

%Estado: (I,R) tal que I ≤ N y R=fib(n)
%Estado inicial: I=0, R=0
%Estado final: I=N
%Transformacion de estados: (I+1, fib(I-1) + fib(I-2)) 

declare
fun {Fib N}
   R={NewCell 0}   %Resultado
   F1={NewCell 1}  %Corresponde a fib(n-1)
   F2={NewCell 1}  %Corresponde a fib(n-2) 
in
   for I in 0..N do    
      if I<2 then   %Cuando n<2 -> R=1
	 R:=@F1
      else
	 R:= @F1+@F2   %Cuando n>=2 -> R= fib(I-1)+fib(I-2) es decir resultados ya calculados anteriormente
	 F2:=@F1      %Se actualiza F2 
	 F1:=@R       %Se actualiza F1 
      end   
   end
   @R
end
{Browse {Fib 6}}
