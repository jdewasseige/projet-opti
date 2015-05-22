function [cout,X] = solve(d,L)
%SOLVE - Implementation et solution du modele lineaire continu.

% input    - donnees : si aucun vecteur de donnees n'est utilise en
%                      argument, alors on utilise le fichier 'donnees.mat'
%
% output   - X     : matrice de taille Tx5 ou l'element x_(i,j)
%                      correspond au nombre de smartphones de type j
%                      produits pendant la semaine i
%                      j correspond a un des types suivants
%                      [x_normal x_supplementaire x_stock x_retard x_sst]
%          - fval  : valeur du cout optimal


[f,A,b,Aeq,beq,lb,ub] = getSolveInfos(d,L);

% simplex pour une solution entiere s'il y en a une
options = optimoptions(@linprog, 'Algorithm', 'simplex');

[X,cout] = linprog(f,A,b,Aeq,beq,lb,ub,zeros(size(f)),options);

X = reshape(X,L,d.T+1)';


end