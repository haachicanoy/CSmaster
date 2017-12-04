% Cristian Camilo Perez
% cristian.camilo.perez@correounivalle.edu.co
declare
% Clase OperacionBinaria
class OperacionBinaria
   attr exp1 exp2 % Atributos donde almacenara las dos expresiones
   meth inic(Exp1 Exp2)
      exp1:=Exp1
      exp2:=Exp2
   end
end
% Clase Constante
class Constante
   attr val % Atributo donde almacenara su valor
   meth inic(Valor)
      val:=Valor % Inicializa el atributo
   end
   meth evaluar(R)
      R=@val % Liga el parametro recibido al valor
   end
end
% Clase Variable
% Hereda de la clase constante todos sus metodos y atributo debido a que el comportamiento de una variable es igual al comportamiento de una constante a diferencia que una variable se puede reasignar su valor
class Variable from Constante
   meth asg(Valor) 
      val:=Valor % Asignar el valor recibo como parametro del atributo
   end
end
% Clase Suma
% Hereda el metodo init y los atributos exp1 exp2
class Suma from OperacionBinaria
   % Suma el resultado de evaluar cada objeto
   meth evaluar(R)
      R={@exp1 evaluar($)}+{@exp2 evaluar($)}
   end
end
% Clase Diferencia
% Hereda el metodo init y los atributos exp1 exp2
class Diferencia from OperacionBinaria
   % Resta el resultado de evaluar cada objeto
   meth evaluar(R)
      R={@exp1 evaluar($)}-{@exp2 evaluar($)}
   end
end
% Clase Producto
% Hereda el metodo init y los atributos exp1 exp2
class Producto from OperacionBinaria
   % Multiplica el resultado de evaluar cada objeto
   meth evaluar(R)
      R={@exp1 evaluar($)}*{@exp2 evaluar($)}
   end
end
% Clase Potencia
% Hereda el metodo init y los atributos exp1 exp2
class Potencia from OperacionBinaria
   % Se calcula la potencia del resultado de evaluar cada objeto
   meth evaluar(R)
      R={Pow {@exp1 evaluar($)} {@exp2 evaluar($)}}
   end
end
% **************************** %
% Pruebas
declare VarX={New Variable inic(0)} VarY={New Variable inic(0)}
local
   Cons2={New Constante inic(2)}
   ExprX2={New Potencia inic(VarX Cons2)}
   Expr3 ={New Constante inic(3)}
   Expr3X2={New Producto inic(Expr3 ExprX2)}
   ExprXY={New Producto inic(VarX VarY)}
   Expr3X2mXY={New Diferencia inic(Expr3X2 ExprXY)}
   Cons3={New Constante inic(3)}
   ExprY3={New Potencia inic(VarY Cons3)}
in
   Formula={New Suma inic(Expr3X2mXY ExprY3)}
end

{VarX asg(7)}
{VarY asg(23)}
{Browse {Formula evaluar($)}}

{VarX asg(5)}
{VarY asg(8)}
{Browse {Formula evaluar($)}}