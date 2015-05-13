function [fval,X] = solveJohn(donnees,printInfos)
%SOLVEJOHN - Implementation et solution du modele lineaire continu de 
%            la ligne d'assemblage simple (personnel constant).

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
c = [d.cout_materiaux d.cout_materiaux+d.duree_assemblage/60*d.cout_heure_sup ...
    d.cout_stockage d.cout_retard d.cout_sous_traitant]';
f = repmat(c,T+1,1);

% vecteur x_s = [x_n x_sup x_stock x_retard x_sst]'
L = 5; % taille de x_s

% acceder a x_lambda
toNor   = [1 0 0 0 0];
toSup   = [0 1 0 0 0];
toStock = [0 0 1 0 0];
toRetard= [0 0 0 1 0];
toSst   = [0 0 0 0 1];

%% contraintes d'egalite

% vecteurs qui multiplient x_s et x_s-1 pour la contrainte 1
dSeg   = [1 1 -1 1 1];
dpSeg  = [0 0 1 -1 0];

Aeq = [kron([eye(T),zeros(T,1)],dpSeg) + kron([zeros(T,1),eye(T)],dSeg);
    kron([1,zeros(1,T)],eye(5));
    zeros(1,L*(T)), toStock; zeros(1,L*(T)),toRetard];
beq = [d.demande';zeros(2,1);d.stock_initial;zeros(2,1);
    d.stock_initial;0];

%% contraintes d'inegalite
c_ouvriers = 60*d.nb_ouvriers/d.duree_assemblage;

% vecteurs qui multiplient x_s et x_s-1 pour la contrainte 2
dSineg  = [-1 -1 1 0 -1]; 
dpSineg = [0  0 -1 1  0];

Anor = kron([zeros(T,1),eye(T)],toNor);
bnor = repmat(35*c_ouvriers,T,1);
Asup = kron([zeros(T,1),eye(T)],toSup);
bsup = repmat(d.nb_max_heure_sup*c_ouvriers,T,1);
Asst = kron([zeros(T,1),eye(T)],toSst);
bsst = repmat(d.nb_max_sous_traitant,T,1);

A = [kron([eye(T),zeros(T,1)],dpSineg) + kron([zeros(T,1),eye(T)],dSineg);...
    Anor; Asup; Asst];
b = [zeros(T,1);bnor;bsup;bsst];

%% bornes
lb = zeros(size(f));
ub = [];

%% solveur

% simplex pour une solution entiere s'il y en a une
options = optimoptions(@linprog, 'Algorithm', 'simplex');

[X,fval] = linprog(f,A,b,Aeq,beq,lb,ub,zeros(size(f)),options);

fval = fval;
%% affichage de la solution et du cout
X = reshape(X,L,T+1)';

if printInfos
    fprintf('\nSemaine\t x_n\t x_sup\t x_st\t x_ret\tx_sst');
    for i=1:T+1
        fprintf('\n%d',i-1);
        for j=1:L
            fprintf('\t %d',X(i,j));
        end
    end
    fprintf('\n\nLe cout total vaut %d.\n',fval);
end

end