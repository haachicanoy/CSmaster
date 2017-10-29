% Punto 6
% Harold Armando Achicanoy Estrella

declare
fun {PagoDeuda Amistades Deudas}
   local
      % Define an empty relationship friends matrix
      A = {Array.new 1 {Length Deudas} 0}
      for I in 1..{Array.high A}
      do
	 A.I:={Array.new 1 {Array.high A} 0}
      end
      % Define a network of relationships
      
   in

   end
end
Amistades=[1#2 2#3 4#5]
Deudas = [100 ~75 ~25 ~42 42]
