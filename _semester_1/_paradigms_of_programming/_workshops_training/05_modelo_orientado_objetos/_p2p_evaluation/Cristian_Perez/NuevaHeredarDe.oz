% Cristian Camilo Perez
% cristian.camilo.perez@correounivalle.edu.co
\insert Set.oz
\insert Empacador.oz
declare
Envolver Desenvolver
{NuevoEmpacador Envolver Desenvolver}

% Funcion que devuelve un registro de clase de acuerdo a las reglas de herencia
% Entrada: Registro de clase base (Clase) * Lista de registros de clases (SuperClases)
% Salida: Registro de clase que hereda de SuperClases
fun {NuevaHeredarDe Clase SuperClases}
   c(metodos:M1 atrbs:A1)={Desenvolver Clase}
   N={List.length SuperClases} % Cantidad de clases
   M={List.make N} % Lista de metodos (Inicialmente variables sin ligar)
   A={List.make N} % Lista de atributos (Inicialmente variables sin ligar)
   for X in 1..N do
      % Liga cada variable de M y A a la tabla de metodos y lista de atributos respectivamente.
      c(metodos:{List.nth M X} atrbs:{List.nth A X})={Desenvolver {List.nth SuperClases X}}
   end
   MA1={Arity M1}
   MA={Map M Arity} % Lista con la aridad de la tabla de metodos de cada clase
   % Comprueba si hay metodos comunes entre las clases que no sean anulados por los metodos de la clase base
   MetEnConfl={Minus {InterForAll MA} MA1}
   % Comprueba si hay atributos comunes entre las clases que no sean anulados por los atributos de la clase base
   AtrEnConfl={Minus {InterForAll A} A1}
in
   if MetEnConfl\=nil then % Si encuentra algun metodo lanza una excepcion
      raise herenciaIlegal(metEnConfl:MetEnConfl) end
   end
   if AtrEnConfl\=nil then % Si encuentra algun atributo lanza una excepcion
      raise herenciaIlegal(atrEnConfl:AtrEnConfl) end
   end
   % Construye la tabla de metodos y la lista de atributos nuevos de la clase base
   {Envolver c(metodos:{Adjoin {FoldL M Adjoin nil} M1}
	       atrbs:{FoldL A Union A1})}
end

% Funcion que opera la interseccion de conjuntos entre todos los elementos de la lista L
% La razon de utilizar esta funcion es porque se debe hallar la interseccion de cada una de las clases con las demas clases.
% In: Lista de Listas
% Out: Lista con los elementos en comun
% Ejemplo:
% L:[[browse inc inic] [inc sum res] [res browse]]
% Salida: [inc browse res]
fun {InterForAll L}  
   case L of nil then nil
   [] H|T then {List.append {InterForEach H T} {InterForAll T}} end
end

% Funcion que opera la interseccion de conjuntos entre la lista E y cada uno de los elementos de la lista L
% In: Lista * Lista de Listas
% Out: Lista con los elementos en comun
% Ejemplo:
% E:[browse inc inic] L:[[browse] [sum inc] [mul res]]
% Salida: [browse inc]
fun{InterForEach E L}
   case L of nil then nil
   [] H|T then {List.append {Inter E H} {InterForEach E T}} end
end