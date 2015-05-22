function [f,A,b,Aeq,beq,lb,ub] = getSolveInfos(d,L)


% fonction objectif 
f = getObjectif(d,L);

% contraintes d'egalite
[Aeq,beq] = getEqConstraints(d,L);

% contraintes d'inegalite
[A,b] = getIneqConstraints(d,L);

% bornes
lb = zeros(size(f));
ub = [];

end
