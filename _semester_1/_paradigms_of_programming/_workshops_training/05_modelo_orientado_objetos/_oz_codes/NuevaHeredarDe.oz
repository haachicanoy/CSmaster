% Taller de programación orientada a objetos. Punto 1
% Autor: Harold Achicanoy
% MPP 2017-2

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

% Creacion de las funciones Envolver y Desenvolver
declare
Envolver Desenvolver
{NuevoEmpacador Envolver Desenvolver}

% Creacion de la funcion NuevaHeredarDe
declare
fun {NuevaHeredarDe C CList}
   case CList of nil then C
   [] H1|T1 then
      A M
   in
      c(metodos:M atrbs:A)={ForAll {Desenvolver CList}}
      {Inspect c(metodos:M atrbs:A)}
   end
end




      proc {Operador H}
	 c(metodos:M atrbs:A)={ForAll {Desenvolver ListC}}
	 MA={ForAll {Arity M}}
      end

      H1|T1
      
	 MetEnConfl={Minus {Inter MA2 MA3} MA1}


      
      {Browse {List.forAllInd [O1 O2 O3] proc {$ I O} {O do(I)} end}}
      if {Member H1 L2} then {Union T1 L2}
      else H1|{Union T1 L2} end
   end

   
   M A MA in
   c(metodos:M atrbs:A)={ForAll {Desenvolver ListC}}
   %c(metodos:M1 atrbs:A1)={Desenvolver C1}
   %c(metodos:M2 atrbs:A2)={Desenvolver C2}
   %c(metodos:M3 atrbs:A3)={Desenvolver C3}
   MA={ForAll {Arity M}} end
   %MA1={Arity M1}
   %MA2={Arity M2}
   %MA3={Arity M3}
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

%% Pruebas

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
   ClaseResultado = {NuevaHeredarDe Contador Disminuir Restaurar} end
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
