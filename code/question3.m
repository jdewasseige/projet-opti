function fval = solveSimple
%SOLVESIMPLE - Implementation et solution du modele lineaire continu de 
%              la ligne d'assemblage simple (personnel constant).

% Importation des donnees
d = importdata('donnees.mat');
%d.demande(15) = d.demande(15) +1;
epsilon = 1;
d.demande = d.demande + epsilon.*d.delta_demande;
emplDepart = d.nb_ouvriers; 
% Remise des donnees sous la forme stock-initial;demande;stockfinal 
% pour faciliter la programmation. 
% On ajoute donc deux semaines qui correspondent
% a la semaine 0 qui ne contient que le stock initial, 
% et la semaine T+1 qui contient le stock final.
% Remarque : Cette derniere ligne n'a pas d'utilite mais sert seulement a
% ameliorer la lisibilite des reponses. Elle reprend exactement le stock
% precedent dans son stock et les productions sont nulles. 
% C'est une semaine fictive, tout comme la prmiere.
d.demande = [d.stock_initial d.demande d.stock_initial];
d.T = d.T+2;

% Creation du vecteur objectif (f)
a = [d.cout_materiaux d.cout_materiaux+d.duree_assemblage/60*d.cout_heure_sup ...
    d.cout_stockage d.cout_retard d.cout_sous_traitant];
f = repmat(a,1,d.T);
f(end-2) = 0;

% Matrice des contraintes d'egalite
Aeq = sparse(d.T, d.T*length(a));
beq = zeros(1,d.T);
beq(1) = d.demande(1);
beq(d.T) = 0; % Pour que le stock revienne a stock_initial
for i = 2:d.T-1
    Aeq(i,(1+length(a)*(i-1)):(length(a)*(i-1)+5)) = [1 1 -1 1 1];
    Aeq(i,length(a)*(i-2)+3) = 1;
    Aeq(i,length(a)*(i-2)+4) = -1;
    beq(i) = d.demande(i);
end
Aeq(1,3) = 1;
% Indique que le stock de la derniere ligne est simplement celui d'avant
Aeq(d.T,(length(a)*d.T-2)) = 1; 
Aeq(d.T,(length(a)*d.T-7)) = -1;
%full(Aeq)

% Matrice des contraintes d'inegalite
A = sparse(3*d.T, d.T*length(a));
b = zeros(1,3*d.T);
% Contrainte sur le nombre max d'employes et donc d'heures 'normales'
for i = 1:d.T
    A(i, (length(a)*(i-1)+1)) = 1;
    b(1,i) = (emplDepart*35)/(d.duree_assemblage/60);
end
% Contrainte sur le nombre max d'heures sup
for i = d.T+1:2*d.T
    A(i, (length(a)*(i-d.T-1)+2)) = 1;
    b(1,i) = (emplDepart*d.nb_max_heure_sup)/(d.duree_assemblage/60);
end
% Ajoute l'inegalite x(i-1,r) <= x(i,n) + x(i,sup) + x(i,sst)
% qui dit que l'on doit quand meme produire les sp que l'on rend en retard
for i = 2*d.T+1:3*d.T-1
    if i ~= 2*d.T+1 %La premiere semaine, pas encore de sp en retard
    A(i, (length(a)*(i-2*d.T-1)-1)) = 1;
    end
    A(i, ((length(a)*(i-2*d.T-1)+1)):((length(a)*(i-2*d.T-1)+5))) = [-1 -1 0 0 -1];
    b(1,i) = 0;
end
    


%intlinprog(f,1:length(f),A,b,Aeq,beq,zeros(length(f)),[])
ub = zeros(size(f)); % Upper bound sur les variables
lb = zeros(size(f)); % Lower bound sur les variables
for i = 1:length(f)
    if mod(i,5) == 0
        ub(i) = d.nb_max_sous_traitant;
    else
        ub(i) = inf;
    end
    if i == ((length(f))/5-2)*5+3 % Oblige le stock a revenir au stock initial a la fin de la planification
        ub(i) = d.stock_initial;
        lb(i) = d.stock_initial;
    end
    if i == ((length(f))/5-2)*5+4 % On peut pas rendre en retard la derniere semaine !
        ub(i) = 0;
    end
end
options = optimoptions(@linprog, 'Algorithm', 'simplex');%Pour qu'il nous donne bien une sol entiere s'il y en a une

dat = reshape(linprog(f,A,b,Aeq,beq,lb,ub,zeros(size(f)),options),5,17)';
[x, fval] = linprog(f,A,b,Aeq,beq,lb,ub,zeros(size(f)),options);
fval;
% x0 ignore pour l'algorithm du simplexe

f = figure('Position',[200 200 400 150]);
cnames = {'X-Data','Y-Data','Z-Data', 'xsst', 'xret'};
rnames = {'First','Second','Third', '4', '5', '6', '7', '8', '9', '10', '11', '12', '13', '14', '15', '16', '18', '19', '20'};
t = uitable('Parent',f,'Data',dat,'ColumnName',cnames,... 
            'RowName',rnames,'Position',[200 200 360 100]);

end