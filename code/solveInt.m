function [cout,X] = solveInt(d,L)
%SOLVEINT - Implementation et solution du modele lineaire continu
%           avec integralite imposee a certaines variables.

% output   - X     : matrice de taille Tx5 ou l'element x_(i,j)
%                      correspond au nombre de smartphones de type j
%                      produits pendant la semaine i
%                      j correspond a un des types suivants
%                      [x_normal x_suplementaire x_stock x_retard x_sst
%                       n_ouv n_emb n_lic]
%          - cout  : valeur du cout optimal


[f,A,b,Aeq,beq,lb,ub] = getSolveInfos(d,L);

%% solveur
intcon = 1:1:length(f);

[X,cout] = intlinprog(f,intcon,A,b,Aeq,beq,lb,ub);

X = reshape(X,L,d.T+1)';

end