% Modelo de concurrencia por paso de mensajes
%
% Ejemplos
%
% Implementado por: Harold Achicanoy

declare S P in
{NewPort S P}
{Browse S} % S: variable sin ligar
{Send P a} % Enviar mensaje "a" por el puerto P
{Send P b} % Enviar mensaje "b" por el puerto P
% Ellos aparecen en el flujo S
{Browse P} % P es un puerto

% Objetos flujo

declare
proc {EstadoProximo M X1 N X2}
   case M of hola then X2 = X1+1 N = hi
   else X2 = X1 N = uh
   end
end

declare
proc {ObjetoFlujo S1 X1 ?T1}
   case S1 of M|S2 then N X2 T2 in
      {EstadoProximo M X1 N X2}
      T1 = N|T2
      {ObjetoFlujo S2 X2 T2}
   [] nil then T1 = nil
   end
end

declare S0 X0 T0 in
thread
   {ObjetoFlujo S0 X0 T0}
end

X0=0 S0=hola|_ {Browse T0}

% Alimentar el flujo
S0=hola|que|tal|_
S0=hola|que|tal|hola|_

declare S0 T0 U0 V0 in
thread {ObjetoFlujo S0 0 T0} end
thread {ObjetoFlujo T0 0 U0} end
thread {ObjetoFlujo U0 0 V0} end
{Browse S0} {Browse T0} {Browse U0} {Browse V0}

% Alimentar flujos
S0=hola|que|tal|_
S0=hola|que|tal|hola|_

% Objetos puerto

declare P in
local S in
   {NewPort S P}
   thread {ForAll S Browse} end
end
{Send P hola}

%% Abstraccion NuevoObjetoPuerto
declare
fun {NuevoObjetoPuerto Inic Fun}
   Sen Ssal in
   thread {FoldL Sen Fun Inic Ssal} end
   {NewPort Sen}
end

%% Abstraccion NuevoObjetoPuerto reactivo
declare
fun {NuevoObjetoPuerto2 Proc}
   Sen in
   thread for Msj in Sen do {Proc Msj} end end
   {NewPort Sen}
end

% Enviar la bola entre tres jugadores
declare
fun {Jugador Otros Nombre}
   {NuevoObjetoPuerto2
    proc {$ Msg}
       case Msg of bola then
	  Ran={OS.rand} mod {Width Otros}+1
       in
	  {Browse Nombre#enviandoA#Otros#Ran}
	  {Delay 1000}
	  {Send Otros.Ran bola}
       end
    end}
end

declare
J1={Jugador otros(J2 J3) a}
J2={Jugador otros(J1 J3) b}
J3={Jugador otros(J1 J2) c}
{Browse j1#J1}
{Send J1 bola}
