% Punto 5

declare
proc {Bar N Xs} % Mesero
   {Delay 3000} % Tiempo entre cervezas: 3 segundos
   case Xs of X|Xr then
      X=N
      {Bar N+1 Xr}
   end
end
fun {Foo ?Xs A Limit} % Estudiante
   {Delay 12000} % Tiempo entre cervezas: 12 segundos
   if Limit>0 then X|Xr=Xs in
      {Foo Xr A+1 Limit-1}
   else A end
end

declare % Memoria intermedia 
proc {MemIntermedia N ?Xs Ys}
   fun {Iniciar N ?Xs}
      if N==0 then Xs
      else Xr in Xs=_|Xr {Iniciar N-1 Xr} end
   end
   proc {CicloAtender Ys ?Xs ?Final}
      case Ys of Y|Yr then Xr Final2 in
	 Xs=Y|Xr
	 Final=_|Final2
	 {CicloAtender Yr Xr Final2}
      end
   end
   Final={Iniciar N Xs}
in
   {CicloAtender Ys Xs Final}
end

local Xs Ys S in
   thread {Bar 1 Xs} end % Bar sirviendo cervezas
   thread {MemIntermedia 5 Xs Ys} end % Memoria intermedia limitando el número de cervezas a servir
   thread S={Foo Ys 0 3600000} end % Estudiante bebiendo cerveza en un lapso de una hora
   {Browse Xs} {Browse Ys}
end

% La necesidad de utilizar memoria intermedia limitada surge debido a que se cuenta con diferentes tiempos de servicio y consumo, generados por el productor y consumidor respectivamente. En este sentido, para que no se sirvan más cervezas de las necesarias y sean consumidas bien frías por parte del consumidor se define como 5 el límite de cervezas servidas en la mesa.