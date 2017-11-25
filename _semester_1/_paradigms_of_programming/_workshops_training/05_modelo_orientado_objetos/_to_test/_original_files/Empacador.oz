declare

proc {NuevoEmpacador ?Envolver ?Desenvolver}
 Llave={NewName} in
    fun {Envolver X}
       {Chunk.new envolver(Llave:X)}
    end
    fun {Desenvolver W}
       try W.Llave catch _ then raise error(desenvolver(W)) end end
    end
 end

% Así se usan estas funciones para darle seguridad y consultar un dato
%{E X} envuelve X y sólo se puede recuperar X a través de D
%{D S} toma S, que deve ser un dato envuelto utilizando E y lo desenvuelve: {D {E X}} == X
% declare E D
% {NuevoEmpacador E D}
% {Browse {D {E a}}}