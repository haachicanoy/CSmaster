% Punto 1: Implementando herencia multiple
% Implemented by: Harold Achicanoy
% MPP 2017-2

\insert Set.oz
% Funciones necesarias para evaluar nombres de metodos y atributos
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

\insert Empacador.oz
% Procedimiento NuevoEmpacador que posee las funciones Envolver y Desenvolver
declare
proc {NuevoEmpacador ?Envolver ?Desenvolver}
   Llave={NewName} in
   fun {Envolver X}
      {Chunk.new envolver(Llave:X)}
   end
   fun {Desenvolver W}
      try W.Llave catch _ then raise error(desenvolver(W)) end end
   end
end

\insert NuevaHeredarDe.oz
% For implementing

%% Creación de las funciones Envolver y Desenvolver
declare
Envolver Desenvolver
{NuevoEmpacador Envolver Desenvolver}

%% Función para la construcción de objetos a partir de clases
%% No use el New predefinido
declare
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

%%% La función HeredarDe vista en el curso
%%% Sólo es necesaria si quiere ver los resultados esperados de la prueba
declare
fun {HeredarDe C1 C2 C3}
   c(metodos:M1 atrbs:A1)={Desenvolver C1}
   c(metodos:M2 atrbs:A2)={Desenvolver C2}
   c(metodos:M3 atrbs:A3)={Desenvolver C3}
   MA1={Arity M1}
   MA2={Arity M2}
   MA3={Arity M3}
   MetEnConfl={Minus {Inter MA2 MA3} MA1}
   AtrEnConfl={Minus {Inter A2 A3} A1}
in
   if MetEnConfl\=nil then
      raise herenciaIlegal(metEnConfl:MetEnConfl) end
   end
   if AtrEnConfl\=nil then
      raise herenciaIlegal(atrEnConfl:AtrEnConfl) end
   end
   {Envolver c(metodos:{Adjoin {Adjoin M2 M3} M1}
           atrbs:{Union {Union A2 A3} A1})}
end

%
% Un ejemplo para probar la herencia múltiple.
% Definición de las clases Contador, Disminuir y Restaurar
%
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
   % ClaseResultado = {NuevaHeredarDe Contador [Disminuir Restaurar]}
% Esto se puede lograr con la función HeredarDe tomada del libro
   ClaseResultado = {HeredarDe Contador Disminuir Restaurar}
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
