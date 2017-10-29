%La funcion fun {Suma A B} ... end calcula iterativamente la suma de los
%elementos entre A y B (A y B incluidos). 

%Estado: (I,R) tal que A ≤ I ≥B y R = (Sumatoria desde A hasta B)
%Estado inicial: I=0, R=0
%Estado final: I=B
%Transformacion de estados: (I+1, R+I)

declare
fun {Suma A B}
   R={NewCell 0} in    % El resultado de la suma empieza en 0
   for I in A..B do  % Empieza la sumatoria en I=A y termina cuando I=B (Incluyendo B)
      R:= @R+I       % Ir sumando el resultado anterior con cada nuevo numero.
   end
   @R
end
{Browse {Suma 1 5}}