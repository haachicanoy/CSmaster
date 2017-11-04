% Punto2: Implementando celdas con puertos
% Implemented by: Harold Achicanoy
% MPP 2017-2

% OPERACIONES BASICAS DE LAS CELDAS
% {NuevaCelda X C}; C: nueva celda; X: contenido inicial
% {Acceder X C}; X: nueva variable; C: contenido de la celda
% {Asignar X C}; X: valor a ser contenido; C: celda

declare
fun {NuevaCelda X}
   C={NewPort X}
   % {Send C X}
   proc {Acceder X C}
      % Simular el comportamiento de X=@C
      X=C
   end
   proc {Asignar X C}
      % Simular el comportamiento de C:=X
      % C=X
      {Send C X}
   end
in
   proc {$ Msj}
      case Msj
      of acceder(C) then {Browse run#acceder#X}{Acceder X C}
      [] asignar(X) then {Browse run#asignar#C}{Asignar X C}
      end
   end
end

declare
proc {Acceder X C}
   {C acceder(X)}
end
proc {Asignar X C}
   {X asignar(C)}
end

%% Prueba
declare C X
C={NuevaCelda X}
{Browse C}
{Acceder X C}
{Asignar x C}