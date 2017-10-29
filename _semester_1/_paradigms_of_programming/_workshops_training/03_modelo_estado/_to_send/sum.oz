% Punto 2
% Harold Armando Achicanoy Estrella

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
declare
fun {Q A B}
   local
      fun {GenList From To}
	 if From < To+1 then From|{GenList From+1 To}
	 else nil end
      end
      fun {CalcSum List}
	 Output = {NewCell 0}
	 Input = {NewCell List}
	 proc {CalcSum}
	    case @Input of nil then skip
	    [] H|T then
	       Output := @Output + H
	       Input := T
	       {CalcSum} end end in
	 {CalcSum}
	 @Output
      end
      MyList = {GenList A B}
   in
      if A<B then
	 {CalcSum MyList}
      elseif A==B then A end
   end
end
{Browse {Q 1 10}}
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
