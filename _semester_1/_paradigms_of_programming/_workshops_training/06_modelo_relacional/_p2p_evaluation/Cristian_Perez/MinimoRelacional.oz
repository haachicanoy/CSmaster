% cristian.camilo.perez@correounivalle.edu.co
% Probar en oz 1.4.0

declare
fun {Solve Script}
   {SolveStep {Space.new Script} nil}
end

fun {SolveStep S SolTail}
   case {Space.ask S} of failed then
      SolTail
   [] succeeded then
      {Space.merge S}|SolTail
   [] alternatives(N) then
      {SolveLoop S 1 N SolTail}
   end
end

fun lazy {SolveLoop S I N SolTail}
   if I>N then
      SolTail
   elseif I==N then
      {Space.commit S I}
      {SolveStep S SolTail}
   else
      C={Space.clone S}
      NewTail={SolveLoop S I+1 N SolTail}
   in
      {Space.commit C I}
      {SolveStep C NewTail}
   end
end

fun {SolveOne F}
   L={Solve F}
in
   if L==nil then nil else [L.1] end
end

fun {SolveAll F}
   L={Solve F}
   proc {TouchAll L}
      if L==nil then skip else {TouchAll L.2} end
   end
in
   {TouchAll L}
   L
end

% Procedimiento que relacione dos tuplas T1 y T2 con una variable
% sin ligar Minimo de manera que Minimo representa la tupla con la llave menor.
proc {Menor T1 T2 ?Minimo}
   % El procedimiento tiene dos opciones
   proc {Seleccionar ?X ?Y} choice X=T1 Y=T2 [] X=T2 Y=T1 end end
   X Y
in
   {Seleccionar X Y}
   % fail implicito si los valores son incompatibles
   (X.2=<Y.2)=true
   Minimo=X
end

% Pruebas
{Browse {SolveAll proc {$ Min} {Menor t(a 3) t(b 5) Min} end }}
{Browse {SolveAll proc {$ Min} {Menor t(a 5) t(b 3) Min} end }}
{Browse {SolveAll proc {$ Min} {Menor t(a 3) t(b 3) Min} end }}

% Procedimiento que relaciona una lista L con una variable sin ligar Minimo
% de manera que representa una tupla cuya llave es la menor de todas las
% llaves de la lista.
proc {PMinimo L ?Minimo}
   % Caso base (Solo un elemento en la lista)
   case L of X|nil then Minimo=X 
   % El minimo de la lista es el menor entre la cabeza de la lista y el minimo
   % del resto de la lista
   [] H|T then Minimo={Menor H {PMinimo T $}} end 
end

fun {MinimoLista L}
   proc {$ M}
      {PMinimo L M}
   end
end

% Pruebas
{Browse {SolveAll {MinimoLista [t(d 2) t(b 3) t(c 4) t(a 2) t(e 5)]}}}
{Browse {SolveAll {MinimoLista [t(d 2) t(b 3) t(c 1) t(a 2) t(e 5)]}}}

% Funcion que remueve un elemento de una lista y retorna la lista sin el
% elemento
% In: [t(d 2) t(b 3) t(c 4) t(a 2) t(e 5)] * t(c 4)
% Out: [t(d 2) t(b 3) t(a 2) t(e 5)]
fun {RemoveElement List Element}
   case List of nil then nil
   [] H|T then
      if H==Element then T
      else H|{RemoveElement T Element} end
   end
end

% Procedimiento que recibe una lista de tuplas Lista de la forma t(e ll)
% y una variable sin ligar ListaOrd y las relaciona de forma que ListaOrd
% representa una lista con las mismas tuplas que Lista pero ordenadas
% según sus respectivas llaves
proc {LOrd Lista ListaOrd}
   case Lista of nil then ListaOrd=nil % Caso base
   [] H|T then
      X in
      X={PMinimo Lista $} % Minimo de la lista
      % Crea una lista con el minimo de la lista y el minimo de la lista restante
      ListaOrd=X|{LOrd {RemoveElement Lista X} $}
   end
end

fun {OrdenarLista Lista}
   proc {$ LO}
      {LOrd Lista LO}
   end
end

% SolveAll calcula todas las soluciones posibles
{Browse {SolveAll {OrdenarLista [t(d 2) t(b 3) t(c 4) t(a 2) t(e 5)]}}}
{Browse {SolveAll {OrdenarLista [t(a 8) t(b 4) t(c 2) t(d 1) t(e 5)]}}}