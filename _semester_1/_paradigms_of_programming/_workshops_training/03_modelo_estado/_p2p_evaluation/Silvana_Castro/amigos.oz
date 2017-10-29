%Amigos y dinero:

%Funcion auxiliar que se encarga de crear una los conjuntos de amigos que estan relacionados entre ellos.
%Es decir, entre los conjuntos creados no existe un amigo en comun.
declare
proc {AuxAmigos Par A}
   I#J=Par in
   if @A==nil then  %Si el conjunto de amigos se encuentra vacio (al principio)
      A:= [[I J]]
   else
      Xr = {NewCell nil}    %Se utiliza Xr como celda auxiliar para ir guardando los grupos, al final se iguala a A
      Encuentra= {NewCell false}
   in
      for B in @A do 
	 if {Member I B} orelse {Member J B} then  %Verificar que I o J pertenezcan ya a un grupo amigos 
	    Encuentra:=true
	    if {Not {Member J B}} then
	       Xr:= {Append @Xr [{Append B [J]}]}
	       
	    else
	       if {Not {Member I B}} then
		  Xr:= {Append @Xr [{Append B [I]}]}
	       else
		  Xr:= {Append @Xr [B]}
	       end
	    end
	 else
	    Xr:= {Append @Xr [B]}
	 end
      end
      A:= @Xr
      if {Not @Encuentra} then                 %Si I y J no estan en ningun grupo, se crea uno nuevo 
	 A:= {Append @A [[I J]]}
      end 
   end 
end

%Funcion auxiliar que se encarga de calcular el pago de las deudas entre los amigos,
%si alguna deuda queda sin pagar (la suma es diferente de cero) entonces debe retornar false.
declare
fun {P A D}
   Deudas ={NewCell true} %Resultado
   Suma={NewCell 0}
in
   for B in @A do %El for itera en los elementos de A (grupos de amigos) 
      for C in B do
	 Suma:= @Suma + D.C %Calcula la suma de cada grupo de amigos
      end
      if {Not @Suma==0} then  %Si una deuda entre un grupo no logro ser saldada Deudas = false
	 Deudas := false
      end
      Suma:= 0 %Reinica Suma en 0 para volver a calcular con otro grupo.
   end
   @Deudas   
end

%Funcion Principal
declare
fun {PagoDeuda Amistades Deudas}
   Am = {NewCell nil}  %Aqui se guardaran los grupos de amigos 
   fun {Pago A Ami}
      case A of nil then {P Ami Deudas}  %Cuando ya se crearon los grupos se calcula el pago de las deudas y retonar el resultado
      [] X|Xr then {AuxAmigos X Ami} {Pago Xr Ami}
      end
   end  
in 
   {Pago Amistades Am}
end

%Pruebas
{Browse {PagoDeuda [1#3 2#4] d(15 20 ~10 ~25)}}
{Browse {PagoDeuda [1#2 2#3 4#5] d(100 ~75 ~25 ~42 42)}}
