function solveJohn
%SOLVEJOHN - Implementation et solution du modele lineaire continu de 
%            la ligne d'assemblage simple (personnel constant).

d = importdata('donnees.mat');

T = d.T;

% vecteur x = [x_n x_sup x_stock x_retard x_sst]'

L = 5; % taille de x
% acceder a x_lambda
toNor   = [1 0 0 0 0];
toSup   = [0 1 0 0 0];
toStock = [0 0 1 0 0];
toRetard= [0 0 0 1 0];
toSst   = [0 0 0 0 1];

% vecteurs qui multiplient x_s et x_s-1 pour la contrainte 1
dSeg     = [1 1 -1 1 1];
dpSeg  = [0 0 1 -1 0];

% Creation du vecteur objectif (f)
a = [d.cout_materiaux d.cout_materiaux+d.duree_assemblage/60*d.cout_heure_sup ...
    d.cout_stockage d.cout_retard d.cout_sous_traitant]';
f = repmat(a,T+1,1);

% contraintes d'egalite
Aeq = [kron([eye(T),zeros(T,1)],dpSeg) + kron([zeros(T,1),eye(T)],dSeg);
    kron([1,zeros(1,T)],eye(5));
    zeros(1,L*(T)), toStock; zeros(1,L*(T)),toRetard];
beq = [d.demande';zeros(2,1);d.stock_initial;zeros(2,1);
    d.stock_initial;0];

% contraintes d'inegalite
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

lb = zeros(size(f));
ub = repmat(inf,size(f),1);

options = optimoptions(@linprog, 'Algorithm', 'simplex');%Pour qu'il nous donne bien une sol entiere s'il y en a une
[X,fval] = linprog(f,A,b,Aeq,beq,lb,ub,zeros(size(f)),options);
X = reshape(X,L,T+1)';

fprintf('\nSemaine\t x_n\t x_sup\t x_st\t x_ret\tx_sst\n');
for i=1:T
    fprintf('%d',i);
    for j=1:L
        fprintf('\t %d',X(i,j));
    end
    fprintf('\n');
end

fprintf('\nLe cout total vaut %d.\n',fval);


end