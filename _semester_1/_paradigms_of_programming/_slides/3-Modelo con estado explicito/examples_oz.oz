%%%%% Funcion que suma una lista de valores
declare
fun {SumList Xs S}
   case Xs of nil then S
   [] X|Xr then {SumList Xr X+S}
   end
end
Y = [1 2 3 4 5 6]
S = 0
{Show {SumList Y S}}

%%%%% Funcion que suma una lista de valores con estado
declare SumList ContadorSum
local
   C = {NewCell 0}
in
   fun {SumList Xs S}
      C:=@C+1
      case Xs of nil then S
      [] X|Xr then {SumList Xr X+S}
      end
   end
   fun {ContadorSum} @C end
   proc {InicContador} C:=0 end
end
{Browse {SumList [1 2 3 4] 0}}
{Browse {ContadorSum}}
{InicContador}
{Browse {ContadorSum}}

%%%% Modelo de computación con estado
%%%% Reverse implementation
declare
fun {Reverse Xs}
   Rs = {NewCell nil}
in
   for X in Xs do
      Rs := X|@Rs
   end
   @Rs
end
{Browse {Reverse [1 2 3 4]}}

%%% Referencias compartidas
declare X Y
X = {NewCell 0}
Y = X
Y := 10
{Browse @X}

%%%% Operar con atributos
declare
X = persona(edad:25 nombre:"Jorge")
Y = persona(edad:25 nombre:"Jorge")
{Browse X==Y}

declare
X = {NewCell 10}
Y = {NewCell 10}
{Browse X==Y}
{Browse @X == @Y}

%%%% Ejercicio clausura transitiva de un grafo (declarativo)
declare
fun {ClauTransDecl G}
   Xs = {Map G fun {$ X#_} X end}
in
   {FoldL Xs
    fun {$ InG X}
       SX = {Suc X InG} in
       {Map InG
	fun {$ Y#SY}
	   Y#if {Member X SY}
	     then {Unión SY SX}
	     else SY
	     end
	end}
    end G}
end
fun {Suc X G}
   case G of Y#SY|G2 then
      if X == Y then SY
      else {Suc X G2}
      end
   end
end
fun {Unión A B}
   case A#B of nil#B then B
   [] A#nil then A
   [] (X|A2)#(Y#B2) then
      if X == Y then
	 X|{Unión A2 B}
      elseif X<Y then
	 X|{Unión A2 B}
      elseif X>Y then
	 Y|{Unión A B2}
      end
   end
end
fun {Nodes G}
   {Map G fun {$ Y#_} Y end}
end
fun {IncPath X SX Ing}
   {Map Ing
    fun {$ Y#SY}
       Y#if {Member X SY} then {Unión SX SY}
	 else SY
	 end
    end
   }
end

declare
G = [1#[2] 2#[3] 3#[4] 4#[5] 5#[2] 6#[2]]
{Browse {ClauTransDecl G}}

%%% Clausura declarativa con estado
declare
proc {StateTrans GM}
   L = {Array.low GM}
   H = {Array.high GM}
in
   for K in L..H do
      for I in L..H do
	 if GM.I.K then
	    for J in L..H do
	       GM.I.J := GM.I.J orelse GM.K.J
	    end
	 end %% if
      end %% for
   end %% for
end
proc {ShowGraph GM}
   L = {Array.low GM}
   H = {Array.high GM}
in
   for I in L..H do
      for J in L..H do
	 {Browse I#J#GM.I.J}
      end
   end
end
G={Array.new 1 6 {Array.new 1 6 false}}
G.1.2 := true
G.2.3 := true
G.3.4 := true
G.4.5 := true
G.5.2 := true
G.6.2 := true
{ShowGraph G}
{StateTrans G}