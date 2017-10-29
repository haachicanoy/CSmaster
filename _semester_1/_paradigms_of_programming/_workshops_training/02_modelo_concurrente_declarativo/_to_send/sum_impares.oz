% Punto 3

declare % Creaci�n del generador de n�meros enteros
fun {Producer Start End}
   if Start<End then Start|{Producer Start+1 End}
   else nil end
end
fun {Consumer Xs A} % Consumidor o c�lculo de la suma de n�meros impares
   case Xs of X|Xr then {Consumer Xr A+X}
   [] nil then A end
end
fun {IsOdd X} % Filtro para n�meros impares
   X mod 2 \= 0
end

local Xs Ys S in
   thread Xs={Producer 0 10000} end
   thread Ys={Filter Xs IsOdd} end
   thread S={Consumer Ys 0} end
   {Browse S}
end