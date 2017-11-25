\insert Set.oz
\insert Empacador.oz
\insert NuevaHeredarDe.oz

declare
%% Creación de las funciones Envolver y Desenvolver
%Envolver Desenvolver
%{NuevoEmpacador Envolver Desenvolver}



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



% Un ejemplo para probar la herencia múltiple.
% Debe fallar porque hay un método presente
% en las superclases Disminuir y DisminuirMul,
% pero no está en la clase Contador

local Contador Disminuir DisminuirMul Restaurar ClaseResultado Obj
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
      TablaDeMetodos = m(dism:Dism2 dismmul:DismMul)
      proc {Dism2 M S Self}
	 X
	 dism(Valor) = M
      in
	 X = {Access S.val}
	 {Assign S.val X-Valor}
      end
      proc {DismMul M S Self}
	 dismmul(Valor Factor) = M
      in	 
	 {Assign S.val {Access S.val}-(Valor*Factor)}
      end
   in
      DisminuirMul = {Envolver c(metodos:TablaDeMetodos atrbs:Atrbs)}
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
   ClaseResultado = {NuevaHeredarDe Contador [Disminuir DisminuirMul Restaurar]}
 
    Obj = {Nuevo ClaseResultado inic(10)}
    {Obj browse}
    {Obj inc(3)}
    {Obj browse}
    {Obj dismmul(4 2)}
    {Obj browse}
    {Obj restaurar(0)}
    {Obj browse}
end

