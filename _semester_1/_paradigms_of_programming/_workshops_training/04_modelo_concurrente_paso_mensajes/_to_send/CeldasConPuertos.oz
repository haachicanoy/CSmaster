% Punto 2: Implementando celdas con puertos
% Implemented by: Harold Achicanoy
% MPP 2017-2

% OPERACIONES BASICAS DE LAS CELDAS
% {NuevaCelda X C}; C: nueva celda; X: contenido inicial
% {Acceder X C}; X: nueva variable; C: contenido de la celda
% {Asignar X C}; X: valor a ser contenido; C: celda

% Abstraccion NuevoObjetoPuerto con estado
declare
fun {NuevoObjetoPuerto Inic Fun}
   Sen Ssal in
   thread {FoldL Sen Fun Inic Ssal} end
   {NewPort Sen}
end


declare
fun {NuevaCelda X}
   C={NewPort X}
   proc {Acceder X C}
      % Simular el comportamiento de X=@C
      % Liga X con el contenido actual de la celda C
      {Send C acceder(X)}
   end
   proc {Asignar X}
      % Simular el comportamiento de C:=X
      % Coloca a X como el contenido nuevo de la celda C
      {Send C asignar(X)}
   end
in
   proc {$ Msj}
      case Msj
      of acceder(C) then
	 {Browse run#acceder#X}{Acceder X C}
      [] asignar(X) then
	 {Browse run#asignar#C}{Asignar X}
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
