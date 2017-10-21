% Punto 9

declare
fun lazy {HagaX} {Browse x} {Delay 3000} 1 end
fun lazy {HagaY} {Browse y} {Delay 6000} 2 end
fun lazy {HagaZ} {Browse z} {Delay 9000} 3 end
X={HagaX}
Y={HagaY}
Z={HagaZ}
{Browse thread X+Y end + Z}
{Browse (X+Y)+Z}

{Browse thread X+Y end + Z} % X+(Y+Z) (X+Y)+Z thread X+Y end + Z
