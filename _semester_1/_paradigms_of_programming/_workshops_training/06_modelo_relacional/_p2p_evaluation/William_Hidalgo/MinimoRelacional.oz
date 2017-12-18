declare



fun {Solve Script}
   {SolStep {Space.new Script} nil }
end


fun{SolStep S Rest}
   case {Space.ask S}
   of failed then Rest
   [] succeeded then {Space.merge S}| Rest
   [] alternatives(N) then
      {SolLoop S 1 N Rest}
   end
end


fun lazy{SolLoop S I N Rest}
   if I>N then Rest
   elseif I==N then
      {Space.commit S I}
      {SolStep S Rest}
   else Right C in
      Right={SolLoop S I+1 N Rest}
      C={Space.clone S}
      {Space.commit C I}
      {SolStep C Right}
   end
end

fun {SolveOne F}
   L={Solve F}
in
   if L == nil then nil else [L.1] end
end

fun {SolveAll F}
   L={Solve F}
   proc {TouchAll L}
      if L==nil then skip else {TouchAll L.2} end
   end
in
   {TouchAll L}
   L
end


proc {Menor T1 T2 Minimo}

   case T1 of t(_ _)  then
      case T2 of t(_ _) then
	 
	 if (T1.2 <  T2.2) then
	    Minimo =T1
	 elseif  (T2.2 < T1.2) then
	    Minimo = T2

	 elseif(T1.2 == T2.2) then
	    choice Minimo= T1 [] Minimo= T2 end
	      
	 end
      [] nil  then
	 Minimo= T1
      end
   [] nil then
      Minimo = T2
   end
end

proc {PMinimo Lista ?Minimo}
   case Lista of H|T then
      {Recorrer  Lista {List.last Lista}   Minimo}
   [] nil then
      skip
   end
end

proc {Recorrer Lista TActual ?MinimoList} Val in
   case Lista of H|T then
      {Menor TActual H Val}
      {Recorrer T Val MinimoList}
   [] nil then
      MinimoList=TActual
   end
end

fun {MinimoLista L}
   proc {$ M}
      {PMinimo L M}
   end
end

%%%%%%% PROBAR PROC MENOR %%%%%%%
{Browse {SolveAll proc {$ Min} {Menor t(a 3) t(b 5) Min} end }}
{Browse {SolveAll proc {$ Min} {Menor t(a 5) t(b 3) Min} end }}
{Browse {SolveAll proc {$ Min} {Menor t(a 3) t(b 3) Min} end }}
%%%%%% PROBAR MENOR LISTA %%%%%%
{Browse {SolveAll {MinimoLista [t(d 2) t(b 3) t(c 4) t(a 2) t(e 5)]}}}
