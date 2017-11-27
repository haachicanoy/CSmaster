% Taller de programación orientada a objetos. Punto 1
% Autor: Harold Achicanoy
% MPP 2017-2

%% Funciones que empaquetan y desempaquetan el contenido de las clases
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
Envolver Desenvolver
{NuevoEmpacador Envolver Desenvolver}

%% Función NuevaHeredarDe
declare
proc {NuevaHeredarDe C CList ?Result}
   case CList of nil then C
   [] H|T then
      proc {Extract C}
	 M A MA
      in
	 c(metodos:M atrbs:A)={Desenvolver C}
	 MA={Arity M}
      end
      {Extract H}|{NuevaHeredarDe C T}
end

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
   ClaseResultado = {NuevaHeredarDe [Contador Disminuir Restaurar]}
end
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

