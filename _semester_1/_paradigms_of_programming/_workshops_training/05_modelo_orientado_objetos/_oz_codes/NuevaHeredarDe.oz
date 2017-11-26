% Punto 1: Implementando NuevaHeredarDe
% Implemented by: Harold Achicanoy
% MPP 2017-2

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


declare
fun {NuevaHeredarDe CB ListC}
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
