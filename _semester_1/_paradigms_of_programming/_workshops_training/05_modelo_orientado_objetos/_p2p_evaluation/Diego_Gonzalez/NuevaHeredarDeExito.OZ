

%%%%%%%%%%%%%%%%%%%%%%%%%%% Chapter 7 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Simple set operations

% Authors: Peter Van Roy and Seif Haridi
% May 9, 2003

% This is the Set module, which defines operations on sets
% represented as unordered lists.  The operations are set union
% (Union), set intersection (Inter), and set difference (Minus).
% These operations take time proportional to the product of the
% argument sizes.  They work with sets of any values represented
% as lists containing the values in any order.
declare
   fun {Union L1 L2}
      case L1 of nil then L2
      [] H1|T1 then
	 if {Member H1 L2} then {Union T1 L2}
	 else H1|{Union T1 L2} end
      end
   end

   fun {Inter L1 L2}
      case L1 of nil then nil
      [] H1|T1 then
	 if {Member H1 L2} then H1|{Inter T1 L2}
	 else {Inter T1 L2} end
      end
   end

   fun {Minus L1 L2}
      case L1 of nil then nil
      [] H1|T1 then
	 if {Member H1 L2} then {Minus T1 L2}
	 else H1|{Minus T1 L2} end
      end
   end
   
   

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Empacador
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

proc {NuevoEmpacador ?Envolver ?Desenvolver}
 Llave={NewName} in
    fun {Envolver X}
       {Chunk.new envolver(Llave:X)}
    end
    fun {Desenvolver W}
       try W.Llave catch _ then raise error(desenvolver(W)) end end
    end
 end

%% Creación de las funciones Envolver y Desenvolver
Envolver Desenvolver
{NuevoEmpacador Envolver Desenvolver}

%% Función para la construcción de objetos a partir de clases
%% No use el New predefinido

fun {Nuevo ClaseEmp MetodoInicial}
   Estado Obj Clase={Desenvolver ClaseEmp}
in
   Estado={MakeRecord s Clase.atrbs}
   {Record.forAll Estado proc {$ A} {NewCell _ A} end}
   proc {Obj M}
      {Clase.metodos.{Label M} M Estado Obj}
   end
   {Obj MetodoInicial}
   Obj
end










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






















%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Prueba NuevaHeredarDe Exitoso
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

local Contador Disminuir Restaurar ClaseResultado Obj
   local
      Atrbs = [val]
      TablaDeMetodos = m(browse:MiBrowse inic:Inic inc:Inc)
      proc {Inic M S Self}
	 inic(Valor) = M
      in
	 {Assign S.val Valor}
      end
      proc {Inc M S Self}
	 X
	 inc(Valor) = M
      in
	 X = {Access S.val}
	 {Assign S.val X+Valor}
      end
      proc {MiBrowse M S Self}
	 M=browse
      in
	 {Browse {Access S.val}}
      end
   in
      Contador = {Envolver c(metodos:TablaDeMetodos atrbs:Atrbs)}
   end
   local
      Atrbs = nil
      TablaDeMetodos = m(dism:Dism)
      proc {Dism M S Self}
	 X
	 dism(Valor) = M
      in
	 X = {Access S.val}
	 {Assign S.val X-Valor}
      end
   in
      Disminuir = {Envolver c(metodos:TablaDeMetodos atrbs:Atrbs)}
   end
   local
      Atrbs = nil
      TablaDeMetodos = m(restaurar:VSet)
      proc {VSet M S Self}
	 restaurar(Valor) = M
      in
	 {Assign S.val Valor}
      end
   in
      Restaurar = {Envolver c(metodos:TablaDeMetodos atrbs:Atrbs)}
   end
in
 
   ClaseResultado = {NuevaHeredarDe Contador [Disminuir Restaurar]}
   % Esto se puede lograr con la función HeredarDe tomada del libro
  %  ClaseResultado = {HeredarDe Contador Disminuir Restaurar}
   % Descomente la línea anterior y comente la línea que invoca NuevaHeredarDe
   % para ver los resultados esperados. 
   Obj = {Nuevo ClaseResultado inic(10)}
   {Obj browse}
   {Obj inc(3)}
   {Obj browse}
   {Obj dism(4)}
   {Obj browse}
   {Obj restaurar(0)}
   {Obj browse}
end
