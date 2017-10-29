%Calculo del factorial

%Estado: (I,R) tal que I<=N y R=I!
%Estado inicial: I=0, R=1
%Estado final: I=N
%Transformacion de estados: (I+1, (I+1)*R)
declare
fun {Factorial N}
   C={NewCell 1} in    %Estado inicial
   for D in 0..(N-1) do  %Hasta I==N (Estado final)
      C:=(D+1) * @C      %Sucesion de estados
   end
   @C
end

%Pruebas
{Browse {Factorial  5}}

