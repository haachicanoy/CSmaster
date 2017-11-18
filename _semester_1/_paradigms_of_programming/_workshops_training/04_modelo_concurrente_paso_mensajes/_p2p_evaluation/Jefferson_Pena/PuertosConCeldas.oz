%%% Authors:
%%%   Jefferson A Pena
%%%
%%% This file is part of Course Models And Paradigms 
%%% 2017-2
%%%
%%% Spa: 
%%% By JAPeTo
%%%
declare proc {NuevoPuerto S P}
	   %% Crea un nuevo puerto
	   P = {NewCell S} end
declare proc {Enviar P X}
	   %%
	   T in X|T=@P P:=T end
%%% Ejemplos & Pruebas
%% El de las diapos
declare P in
local S in
   {NuevoPuerto S P}
   thread {ForAll S Browse} end
   {Enviar P hola}
end
%% Multiples envios
local S P in
   {Browse S}
   {NuevoPuerto S P}
   {Enviar P esta}
   {Enviar P es}
   {Enviar P una}
   {Enviar P prueba}
   {Enviar P multiple}
   {Enviar P envios}
end
