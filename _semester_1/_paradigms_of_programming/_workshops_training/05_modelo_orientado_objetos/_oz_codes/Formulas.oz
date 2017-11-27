% Taller de programación orientada a objetos. Punto 2
% Autor: Harold Achicanoy
% MPP 2017-2

%% Implementación de clases
declare
class Expressions %% Super-clase
   attr
      expr1
      expr2
end
class Variable from Expressions %% Clase variable
   meth inic(Value)
      expr1:=Value
   end
   meth asg(Value)
      expr1:=Value
   end
   meth evaluar($)
      @expr1
   end
end
class Constante from Expressions %% Clase Constante
   meth inic(Valor)
      expr1:=Valor
   end
   meth evaluar($)
      @expr1
   end
end
class Suma from Expressions %% Clase Suma
   meth inic(Value1 Value2)
      expr1:=Value1
      expr2:=Value2
   end
   meth evaluar($)
      {@expr1 evaluar($)}+{@expr2 evaluar($)}
   end
end
class Diferencia from Expressions %% Clase Diferencia
   meth inic(Value1 Value2)
      expr1:=Value1
      expr2:=Value2
   end
   meth evaluar($)
      {@expr1 evaluar($)}-{@expr2 evaluar($)}
   end
end
class Producto from Expressions %% Clase Producto
   meth inic(Value1 Value2)
      expr1:=Value1
      expr2:=Value2
   end
   meth evaluar($)
      {@expr1 evaluar($)}*{@expr2 evaluar($)}
   end
end
class Potencia from Expressions %% Clase Potencia
   meth inic(Value1 Value2)
      expr1:=Value1
      expr2:=Value2
   end
   meth evaluar($)
      {Pow {@expr1 evaluar($)} @expr2}
   end
end

declare
VarX={New Variable inic(0)}
VarY={New Variable inic(0)}
local
   ExprX2    ={New Potencia inic(VarX 2)}
   Expr3     ={New Constante inic(3)}
   Expr3X2   ={New Producto inic(Expr3 ExprX2)}
   ExprXY    ={New Producto inic(VarX VarY)}
   Expr3X2mXY={New Diferencia inic(Expr3X2 ExprXY)}
   ExprY3    ={New Potencia inic(VarY 3)}
in
   Formula={New Suma inic(Expr3X2mXY ExprY3)}
end

%% Pruebas
{VarX asg(7)}
{VarY asg(23)}
{Browse {Formula evaluar($)}}

{VarX asg(5)}
{VarY asg(8)}
{Browse {Formula evaluar($)}}
