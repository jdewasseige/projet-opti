function [cout,X] = solveInt(donnees,printInfos)
%SOLVE - Implementation et solution du modele lineaire continu de 
%            la ligne d'assemblage personnel variable.

% input    - donnees : si aucun vecteur de donnees n'est utilise en
%                      argument, alors on utilise le fichier 'donnees.mat'
%
% output   - X     : matrice de taille Tx5 ou l'element x_(i,j)
%                      correspond au nombre de smartphones de type j
%                      produits pendant la semaine i
%                      j correspond a un des types suivants
%                      [x_normal x_suplementaire x_stock x_retard x_sst]
%          - fval  : valeur du cout optimal

%% load data, fonction objectif et constantes
if nargin==0
    d = importdata('donnees.mat');
else
    d = donnees;
end

T = d.T; % nombre de semaines

% fonction objectif 
f = getObjectif(T,d);

% vecteur x_s = [x_n x_sup x_stock x_retard x_sst]'
L = 8; % taille de x_s

%% contraintes d'egalite
[Aeq,beq] = getEqConstraints(T,d);

%% contraintes d'inegalite
[A,b] = getIneqConstraints(T,d);

%% bornes
lb = zeros(size(f));
ub = [];

%% solveur
intcon = 1:1:length(f);
[X,cout] = intlinprog(f,intcon,A,b,Aeq,beq,lb,ub);

cout = cout - 35*d.nb_ouvriers*d.cout_horaire ...
    - d.stock_initial*d.cout_stockage ;

%% affichage 
X = reshape(X,L,T+1)';

if nargin <2 || printInfos
    printSol(X);
    %printmat(X)
    fprintf('\n\nLe cout total vaut %d.\n',cout);
end

end