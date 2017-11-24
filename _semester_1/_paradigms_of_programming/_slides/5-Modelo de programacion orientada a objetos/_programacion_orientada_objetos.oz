% Modelo de programacion orientada a objetos
%
% Ejemplos
%
% Implementado por: Harold Achicanoy

declare
class Contador
   attr val
   meth inic(Valor)
      val:=Valor
   end
   meth browse
      {Browse @val}
   end
   meth inc(Valor)
      val:=@val+Valor
   end
end
{Browse Contador}

%% Ejemplos de uso
declare
C={New Contador inic(0)}
{C inc(6)} {C inc(6)}
{C browse}

%% Son asincronicos los mensajes?
local X in {C inc(X)} X=5 end
{C browse}
%% No

declare S in
local X in
   thread {C inc(X)} S=listo end
   X=5
end
{Wait S} {C browse}

%% Inicializacion de atributos
%% 1. Por instancia
declare
class UnApart
   attr nombreCalle
   meth inic(X) @nombreCalle=X end
   meth browse {Browse @nombreCalle} end
end
Apt1={New UnApart inic(pasoancho)}
Apt2={New UnApart inic(calleQuinta)}
{Apt1 browse}
{Apt2 browse}

%% 2. Por clase
declare
class ApartQuinta
   attr
      nombreCalle:calleQuinta
      numeroCalle:100
      colorPared:_
      superficiePiso:madera
   meth inic skip end
   meth browse {Browse @nombreCalle} end
end
Apt3={New ApartQuinta inic}
Apt4={New ApartQuinta inic}
{Apt3 browse}
{Apt4 browse}

%% 3. Por marca
declare
L=linux
class RedHat attr tiposo:L end
class SuSE attr tiposo:L end
class Debian attr tiposo:L end
