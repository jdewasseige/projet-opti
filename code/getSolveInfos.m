function [f,A,b,Aeq,beq,lb,ub] = getSolveInfos(d,L)


T = d.T; % nombre de semaines

%% fonction objectif 
f = getObjectif(T,d,L);

%% contraintes d'egalite
[Aeq,beq] = getEqConstraints(T,d,L);

%% contraintes d'inegalite
[A,b] = getIneqConstraints(T,d,L);

%% bornes
lb = zeros(size(f));
ub = [];

end
