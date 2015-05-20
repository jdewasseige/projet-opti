function [realVal,x,f_dual] = solveDual(donnees,printInfos)
%SOLVEDUAL - Analyse de l'effet de la modification de la demande sur la
%fonction objectif.

%% load data, fonction objectif et constantes
if nargin==0
    d = importdata('donnees.mat');
else
    d = donnees;
end

T = d.T; % nombre de semaines

% vecteur x_s = [x_n x_sup x_stock x_retard x_sst]'
L = 5; % taille de x_s

%% infos du primal

% objectif
f_primal = getObjectif(T,d);

% contraintes d'egalite
[Aeq,beq] = getEqConstraints(T,d);

% contraintes d'inegalite
[A,b] = getIneqConstraints(T,d);

%% implementation dual
[meq, neq] = size(Aeq);
[m, n] = size(A);
A_dual = [Aeq;A]';
b_dual = f_primal;
f_dual = [beq;b];
ub_dual = [inf(meq,1);zeros(m,1)];

%% solveur

options = optimoptions(@linprog, 'Algorithm', 'simplex');
[x, fval] = linprog(-f_dual, A_dual, b_dual,...
    [], [], [], ub_dual);
realVal = f_dual'*x - d.stock_initial*d.cout_stockage ...
    + T*35*d.nb_ouvriers*d.cout_horaire;

end