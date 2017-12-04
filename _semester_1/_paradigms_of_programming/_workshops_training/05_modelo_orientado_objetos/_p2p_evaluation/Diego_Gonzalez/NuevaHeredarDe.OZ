

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%Extendiendo las operaciones simples para trabajar con listas de listas
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%   Busca en una lista de listas las comunes entre ellas
%%   [[a b c e] [d h f g] [i a k l] [i b y z]] = [a b i]
%%Permite encontrar los metodos comunes entre las listas de listas de Aridades de metodos.

fun {InterList List}
   fun {InterFor L1 L2}      
      case L2 of nil then nil
      [] H|T then
	 {Union {Inter L1 H} {InterFor L1 T}}
      end
   end
   fun{AuxList L}
      case L of nil then nil
      [] H|T then
	 if T == nil then nil
	 else {Union {InterFor H T} {AuxList T}} end
      end      
   end   
in
   {AuxList List}
end

%Desempacador de clases, recibe una lista de clases y crea listas de listas que contienen los metodos, atributos, aridad de los metodos
proc{DesempacadorClases List ?LM ?LA ?LMA}
   case List of nil then LM = nil LA = nil LMA = nil
   [] H|T then M A MA TM TA TMA in
      c(metodos:M atrbs:A)={Desenvolver H} %Desenvolver cada clase
      MA = {Arity M}    %Obtener los A, M, MA y adicionarlos a cada lista
      {DesempacadorClases T TM TA TMA}
      LM = M|TM LA = A|TA LMA = MA|TMA %Se generan las listas
      %LM= Lista de listas de metodos.
      %LA= Lista de listas de atributos.
      %LMA= Lista de listas de aridades de metodos.
   end
end

%Operardor de listas de listas, permite aplicar (Union, Adjoin) a una lista de listas
fun {OperarList List Op}
   case List of nil then nil
   []H|T then {Op H {OperarList T Op}} end
end

%NuevaHeredarDe que permite heredar de una lista de clases
fun {NuevaHeredarDe C1 ListClass} LM LA LMA%Listas de listas para los datos de las clases
   c(metodos:M1 atrbs:A1)={Desenvolver C1}
   MA1={Arity M1}
   {DesempacadorClases ListClass LM LA LMA}%Uso del desempacador de clases
   
   MetEnConfl={Minus {InterList LMA} MA1} %InterList obtiene los items en comun
   AtrEnConfl={Minus {InterList LA} A1}   %InterList obtiene los items en comun
in
   if MetEnConfl\=nil then
      raise herenciaIlegal(metEnConfl:MetEnConfl) end
   end
   if AtrEnConfl\=nil then
      raise herenciaIlegal(atrEnConfl:AtrEnConfl) end
   end 
   {Envolver c(metodos:{Adjoin {OperarList LM Adjoin} M1} %Usando OperarList adjuntamos o
	       atrbs:{Union {OperarList LA Union} A1})}   % unimos segun el caso de listas
end



