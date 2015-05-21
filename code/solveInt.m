function [cout,X] = solveInt(d,L)
%SOLVEINT - Implementation et solution du modele lineaire continu
%           avec integralite imposee a certaines variables.

% input    - donnees : si aucun vecteur de donnees n'est utilise en
%                      argument, alors on utilise le fichier 'donnees.mat'
%
% output   - X     : matrice de taille Tx5 ou l'element x_(i,j)
%                      correspond au nombre de smartphones de type j
%                      produits pendant la semaine i
%                      j correspond a un des types suivants
%                      [x_normal x_suplementaire x_stock x_retard x_sst
%                       n_ouv n_emb n_lic]
%          - fval  : valeur du cout optimal

%% fonction objectif et constantes

T = d.T; % nombre de semaines

% fonction objectif 
f = getObjectif(T,d,L);

%% contraintes d'egalite
[Aeq,beq] = getEqConstraints(T,d,L);

%% contraintes d'inegalite
[A,b] = getIneqConstraints(T,d,L);

%% bornes
lb = zeros(size(f));
ub = [];

%% solveur
intcon = 1:1:length(f);
[X,cout] = intlinprog(f,intcon,A,b,Aeq,beq,lb,ub);

end