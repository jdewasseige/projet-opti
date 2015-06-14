function [f,A,b,Aeq,beq,lb,ub] = getSolveInfos(d,L)

% Fonction objectif 
f = getObjectif(d,L);

% Contraintes d'egalite
[Aeq,beq] = getEqConstraints(d,L);

% Contraintes d'inegalite
[A,b] = getIneqConstraints(d,L);

% Bornes
lb = zeros(size(f));
ub = [];

end
