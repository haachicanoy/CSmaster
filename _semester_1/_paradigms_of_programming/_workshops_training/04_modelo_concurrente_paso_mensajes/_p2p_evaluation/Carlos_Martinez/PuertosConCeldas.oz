declare
fun {NuevoPuerto S}
   Flujo={NewCell S}%Celda que contiene el flujo del puerto (S es su cola)
   proc {Enviar X} Flujo:=X|@Flujo {Browse @Flujo} end %"Enviar" toma el nuevo mensaje y lo incorpora al flujo, la cola del flujo es una variable sin asignación
in
   proc {$ Msj}%Procesamiento del mensaje (para celdas solo será enviar)
      case Msj
      of enviar(X) then {Enviar X}
      end
   end
end

proc {Enviar P X}%Interfaz desempaquetada
   {P enviar(X)}
end


%Prueba
declare P S
P={NuevoPuerto S}
{Browse P}
{Browse S}
{Enviar P a}
{Enviar P b}