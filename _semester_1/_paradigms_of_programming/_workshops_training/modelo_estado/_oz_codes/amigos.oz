% Punto 6
% Harold Armando Achicanoy Estrella

declare
fun {PagoDeuda Amistades Deudas}
end

Amistades=[1#2 2#3 4#5]
Deudas = [100 ~75 ~25 ~42 42]

declare
proc {StateTrans GM}
   L={Array.low GM}
   H={Array.high GM}
in
   for K in L..H do
      for I in L..H do
	 if GM.I.K then
	    for J in L..H do
	       GM.I.J:=GM.I.J orelse GM.K.J
	    end
	 end
      end
   end
end
proc {ShowGraph GM}
   L={Array.low GM}
   H={Array.high GM}
in
   for I in L..H do
      for J in L..H do
	 {Browse I#J#GM.I.J}
      end
   end
end

G = {Array.new 1 5 {Array.new 1 6 false}}
G.1.2:=true
G.2.3:=true
G.3.4:=true
G.4.5:=true
G.5.2:=true
G.6.2:=true
{ShowGraph G}


declare
Rfriend={Array.new 1 5 false}
for I in 1..5
do Rfriend.I:={Array.new 1 5 false}
end
Rfriend.1.2:=true
Rfriend.2.3:=true
Rfriend.4.5:=true
proc {ShowGraph GM}
   L={Array.low GM}
   H={Array.high GM}
in
   for I in L..H do
      for J in L..H do
	 {Browse I#J#GM.I.J}
      end
   end
end
{ShowGraph Rfriend}
declare
proc {StateTrans GM}
   L={Array.low GM}
   H={Array.high GM}
in
   for K in L..H do
      for I in L..H do
	 if GM.I.K then
	    for J in L..H do
	       GM.I.J:=GM.I.J orelse GM.K.J
	    end
	 end
      end
   end
end
{ShowGraph {StateTrans Rfriend}}