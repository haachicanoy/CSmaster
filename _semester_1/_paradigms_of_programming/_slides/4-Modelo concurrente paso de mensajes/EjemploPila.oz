% Ejemplo implementacion de pila con TADs
% Implemented by: Harold Achicanoy
% MPP 2017-2

declare
fun {PilaNueva}
   C={NewCell nil}
   proc {Colocar E} C:=E|@C {Browse @C} end
   fun {Sacar} case @C of X|S1 then C:=S1 X end end
   fun {EsVacia} @C==nil end
in
   proc {$ Msj}
      case Msj
      of colocar(X) then {Colocar X}
      [] sacar(?E) then E={Sacar}
      [] esVacia(?B) then B={EsVacia}
      end
   end
end

declare S X=5
{Browse {S colocar(X)}}
{Show S}
