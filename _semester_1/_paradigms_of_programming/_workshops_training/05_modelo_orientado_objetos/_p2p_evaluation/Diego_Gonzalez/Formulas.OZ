
declare
class Exp
   attr x y
   meth otherwise(M) raise metodoIndefinido end end
end


class Variable from Exp
   meth inic(Ini ) x:=Ini  end
   meth asg(Value) x:=Value  end
   meth evaluar(Value) Value = @x end
end
class Constante from Exp
   meth inic(Const) x:=Const end
   meth evaluar(Value) Value = @x end
end
class Suma from Exp
   meth inic(Exp1 Exp2) x:=Exp1 y:= Exp2 end
   meth evaluar(Value)
      Value = {@x evaluar($)} + {@y evaluar($)} end
end
class Diferencia from Exp
   meth inic(Exp1 Exp2) x:=Exp1 y:= Exp2 end
   meth evaluar(Value) Value = {@x evaluar($)} / {@y evaluar($)} end
end
class Producto from Exp
   meth inic(Exp1 Exp2) x:=Exp1 y:= Exp2 end
   meth evaluar(Value) Value = {@x evaluar($)} * {@y evaluar($)} end
end

class Potencia from Exp
   meth inic(VarX Exp) x:=VarX y:=Exp end
   meth evaluar(Value)
      Value = {Pow
	       {@x evaluar($)}
	       @y %Para Habilitar la evaluacion del exponente como expresion comentar "@y" y descomentar la siguiente linea de codigo.
	       
	       %{@y evaluar($)}%Debe estar comentada para evaluar con el ejemplo del profesor.
			       } end
end


 
%Prueba ejemplo del taller.

declare VarX={New Variable inic(0.0)}
VarY={New Variable inic(0.0)}
local   
   ExprX2={New Potencia inic(VarX 2.0)}
   Expr3 ={New Constante inic(3.0)}
   Expr3X2={New Producto inic(Expr3 ExprX2)}
   ExprXY={New Producto inic(VarX VarY)}
   Expr3X2mXY={New Diferencia inic(Expr3X2 ExprXY)}
   ExprY3={New Potencia inic(VarY 3.0)}
in
   Formula={New Suma inic(Expr3X2mXY ExprY3)}
end

{VarX asg(7.0)}
{VarY asg(23.0)}
{Browse {Formula evaluar($)}}








%Prueba modificando el ejemplo para evaluar los exponentes como expresiones, tener en cuenta la linea de codigo a descomentar en la clase potencia.
%declare VarX={New Variable inic(0.0)}
%VarY={New Variable inic(0.0)}
%local
%   Exponente1 ={New Constante inic(2.0)}
%   Exponente2 ={New Constante inic(3.0)}
%      
%   ExprX2={New Potencia inic(VarX Exponente1)}
%   Expr3 ={New Constante inic(3.0)}
%   Expr3X2={New Producto inic(Expr3 ExprX2)}
%   ExprXY={New Producto inic(VarX VarY)}
%   Expr3X2mXY={New Diferencia inic(Expr3X2 ExprXY)}
%   ExprY3={New Potencia inic(VarY Exponente2)}
%in
%   Formula={New Suma inic(Expr3X2mXY ExprY3)}
%end

%{VarX asg(7.0)}
%{VarY asg(23.0)}
%{Browse {Formula evaluar($)}}
