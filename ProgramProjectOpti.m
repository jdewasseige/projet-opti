%Importation des donn�es
d = importdata('donnees.mat');
emplDepart = d.nb_ouvriers; 
%Remise des donn�es sous la forme stock-initial;demande;stockfinal pour
%faciliter la programmation. On ajoute donc deux semaines qui correspondent
%� la semaine 0 qui ne contient que le stock initial, et la semaine T+1 qui contient le stock final.
d.demande = [d.stock_initial d.demande d.stock_initial];
d.T = d.T+2;

%Cr�ation du vecteur objectif (f)
a = [d.cout_materiaux d.cout_materiaux+d.duree_assemblage/60*d.cout_heure_sup d.cout_stockage d.cout_retard d.cout_sous_traitant];
f = a;
for i = 1:d.T-1
f = [f a];
end

%Matrice des contraintes d'�galit�
Aeq = sparse(d.T, d.T*length(a));
beq = zeros(1,d.T);
beq(1) = d.demande(1);
beq(d.T) = d.demande(d.T);
for i = 2:d.T-1
    Aeq(i,(1+length(a)*(i-1)):(length(a)*(i-1)+5)) = [1 1 -1 1 1];
    Aeq(i,length(a)*(i-2)+3) = 1;
    Aeq(i,length(a)*(i-2)+4) = -1;
    beq(i) = d.demande(i);
end
Aeq(1,3) = 1;
Aeq(d.T,(length(a)*d.T-2)) = 1;
%full(Aeq)

%Matrice des contraintes d'in�galit�
A = sparse(3*d.T, d.T*length(a));
b = zeros(1,3*d.T);
%Contrainte sur le nombre max d'employ�s et donc d'heures 'normales'
for i = 1:d.T
    A(i, (length(a)*(i-1)+1)) = 1;
    b(1,i) = (emplDepart*35)/(d.duree_assemblage/60);
end
%Contrainte sur le nombre max d'heures sup
for i = d.T+1:2*d.T
    A(i, (length(a)*(i-d.T-1)+2)) = 1;
    b(1,i) = (emplDepart*d.nb_max_heure_sup)/(d.duree_assemblage/60);
end
%Ajoute l'inegalite x(i-1,r) <= x(i,n) + x(i,sup) + x(i,sst)
%qui dit que l'on doit quand meme produire les sp que l'on rend en retard
for i = 2*d.T+1:3*d.T
    if i ~= 2*d.T+1 %La premi�re semaine, pas encore de sp en retard
    A(i, (length(a)*(i-2*d.T-1)-1)) = 1;
    end
    A(i, ((length(a)*(i-2*d.T-1)+1)):((length(a)*(i-2*d.T-1)+5))) = [-1 -1 0 0 -1];
    b(1,i) = 0;
end
    


%intlinprog(f,1:length(f),A,b,Aeq,beq,zeros(length(f)),[])
maxsst = zeros(size(f));
for i = 1:length(f)
    if mod(i,5) == 0
        maxsst(i) = d.nb_max_sous_traitant;
    else
        maxsst(i) = inf;
    end
end
options = optimoptions('linprog', 'Algorithm', 'simplex');

reshape(linprog(f,A,b,Aeq,beq,zeros(size(f)),maxsst,zeros(size(f)),options),5,17)'
%reshape(linprog(f,A,b,Aeq,beq,zeros(size(f)),[]),5,17)'