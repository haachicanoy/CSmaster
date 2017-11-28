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

% Operar con la clase
declare
C={New Contador inic(0)}
{C inc(6)}{C inc(6)}
{C browse}

% Test 1: no funciona
local X in {C inc(X)} X=5 end
{C browse}

% Test 2: funciona
declare S in
local X in thread {C inc(X)} S=listo end X=5 end
{Wait S}{C browse}

%% Inicializacion de atributos
%% Por instancia
declare
class UnApart
   attr nombreCalle
   meth inic(X) @nombreCalle=X end
   meth browse {Browse @nombreCalle} end
end
Apt1 = {New UnApart inic(pasoancho)}
Apt2 = {New UnApart inic(calleQuinta)}
{Apt1 browse}
{Apt2 browse}

%% Inicializacion de atributos
%% Por clase
declare
class ApartQuinta
   attr
      nombreCalle:calleQuinta
      numeroCalle:100
      colorPared:_
      superficiePiso:madera
   meth inic skip end
   meth browse {Browse @nombreCalle#@numeroCalle#@colorPared#@superficiePiso} end
end
Apt3={New ApartQuinta inic}
Apt4={New ApartQuinta inic}
{Apt3 browse}
{Apt4 browse}

%% Inicializacion de atributos
%% Por marca
declare
L=linux
class RedHat
   attr tiposo:L
   meth browse {Browse @tiposo} end
end
class SuSE
   attr tiposo:L
   meth browse {Browse @tiposo} end
end
class Debian
   attr tiposo:L
   meth browse {Browse @tiposo} end
end

%%% Implementacion clase cuenta
declare
class Cuenta
   attr saldo:0
   meth transferir(Cant)
      saldo:=@saldo+Cant
   end
   meth pedirSaldo(Sal)
      Sal=@saldo
   end
   meth transferEnLote(CantList)
      for A in CantList do {self transferir(A)} end
   end
   meth browse {Browse @saldo} end
end

%% Aplicando herencia
declare
class CuentaVigilada from Cuenta
   meth transferir(Cant)
      {LogObj agregueEntrada(transferir(Cant))}
      Cuenta,transferir(Cant)
   end
end
CtaVig={New CuentaVigilada transferir(100)}





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Implementacion de una clase
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
local
   proc {Inic M S}
      inic(Valor)=M in
      (S.val):=Valor
   end
   proc {Browse2 M S}
      {Browse @(S.val)}
   end
   proc {Inc M S}
      inc(Valor)=M in
      (S.val):=@(S.val)+Valor
   end
in
   Contador=c(atrbs:[val]
	      metodos:m(inic:Inic browse:Browse2 inc:Inc))
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Funcion para crear objetos a partir de  clases
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

declare
fun {New Clase Inic}
   Fs={Map Clase.atrbs fun {$ X} X#{NewCell _} end}
   S={List.toRecord estado Fs}
   proc {Obj M}
      {Clase.metodos.{Label M} M S}
   end
in
   {Obj Inic}
   Obj
end
