%Implementacion del algoritmo de ordenamiento BubbleSort
%Este algoritmo funciona comparando desde el primer elemento, los elementos adyacentes e intercambiando si no estan en orden,
%luego se sigue con el segundo elemento y asi sucesivamente hasta llegar al ultimo elemento cuando la lista ya esta ordenada
declare
proc {BubbleSort List ?R}
   Lista = {Tuple.toArray List} %Convertir a Array la tupla recibida para poder intercambiar los elementos con mas facilidad
   N = {Array.high Lista}       %Tamaño de la lista   
   Aux = {NewCell nil}          %Celda auxiliar para guardar valores
in
   for I in 3..N do
      for J in 1..(N-I+2) do
	 if Lista.J > Lista.(J+1) then
	    Aux:= Lista.J
	    {Put Lista J Lista.(J+1)}
	    {Put Lista (J+1) @Aux}
	 end
      end
   end
   R = {Record.toList {Array.toRecord r Lista}} %El resultado final se convierte a registro para la visualizacion
end

%Pruebas
%El archivo recibe una tupa con los numeros a ordenar
declare L=l(55 86 48 16 82)
{Browse {BubbleSort L}}


