% Punto 1
% Harold Armando Achicanoy Estrella

declare
A={NewCell 0}
B={NewCell 0}
T1=@A
T2=@B
{Show A==B}   % a). false
{Show T1==T2} % b). true
{Show T1=T2}  % c). 0
A:=@B
{Show A==B}   % d). false
