% Punto 7

declare
L1 L2 L3 L4 X1 X2 X3 X4
L1 = [1 2 3]
X1 = done
thread L2 = {Map L1 fun {$ X} {Delay 200} X*X end} X2 = X1 end
thread L3 = {Map L1 fun {$ X} {Delay 200} 2*X end} X3 = X2 end
thread L4 = {Map L1 fun {$ X} {Delay 200} 3*X end} X4 = X3 end
{Wait X4}
{Show L2#L3#L4}
