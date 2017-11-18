declare
fun {NuevoObjetoPuerto Inic Fun}
   Sen Ssal in
   thread {FoldL Sen Fun Inic Ssal} end
   {NewPort Sen}
end

fun {NuevaCelda Cont}
   {NuevoObjetoPuerto Cont
    proc {$ Msj}
       case Msj
       of asignar(X) then Cont=X
       [] acceder(X) then X=Cont
       end
    end}
end

proc {Acceder X C}
   {Send C acceder(X)}
end

proc {Asignar X C}
   {Send C asignar(X)}
end


%Prueba
declare C X
C={NuevaCelda 0}
{Browse C}
%{Acceder X C}
%{Browse X}
%{Asignar 4 C}