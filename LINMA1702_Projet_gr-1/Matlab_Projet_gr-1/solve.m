function [cout,X] = solve(d,L)
%SOLVE - Implementation et solution du modele lineaire continu.

% output   - cout  : valeur du cout optimal
%
%          - X     : matrice de taille Tx5 ou l'element x_(i,j)
%                    correspond au nombre de smartphones de type j
%                    produits pendant la semaine i


[f,A,b,Aeq,beq,lb,ub] = getSolveInfos(d,L);

% Simplexe pour une solution entiere s'il y en a une
options = optimoptions(@linprog, 'Algorithm', 'simplex');

[X,cout] = linprog(f,A,b,Aeq,beq,lb,ub,zeros(size(f)),options);

X = reshape(X,L,d.T+1)';


end