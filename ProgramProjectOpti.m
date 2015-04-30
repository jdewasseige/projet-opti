%Importation des données
d = importdata('donnees.mat');
emplDepart = 30;

%Création du vecteur objectif (f)
%Probléme = Il faut dire que les smartphones livrés en retard doivent quand
%même être produits
a = [d.cout_materiaux d.cout_materiaux+d.duree_assemblage/60*d.cout_heure_sup d.cout_stockage d.cout_retard d.cout_sous_traitant];
f = a;
for i = 1:d.T-1
f = [f a];
end

%Matrice des contraintes d'égalité
Aeq = sparse(d.T, d.T*length(a));
beq = zeros(1,d.T);
for i = 2:d.T-1
    Aeq(i,(1+length(a)*(i-1)):(length(a)*(i-1)+5)) = [1 1 -1 1 1];
    Aeq(i,length(a)*(i-2)+3) = 1;
    Aeq(i,length(a)*(i-2)+4) = -1;
    beq(i) = d.demande(i);
end
Aeq(1,3) = 1;
Aeq(d.T,(length(a)*d.T-2)) = 1;
beq(1) = 0;
beq(d.T) = 0;
%full(Aeq)

%Matrice des contraintes d'inégalité
A = sparse(2*d.T, d.T*length(a));
b = zeros(1,2*d.T);
for i = 1:d.T
    A(i, (length(a)*(i-1)+1)) = 1;
    b(1,i) = ((d.duree_assemblage/60)*35)/emplDepart;
end
for i = d.T+1:2*d.T
    A(i, (length(a)*(i-d.T-1)+2)) = 1;
    b(1,i) = (d.duree_assemblage/60*d.nb_max_heure_sup)/emplDepart;
end

%intlinprog(f,1:length(f),A,b,Aeq,beq,zeros(length(f)),[])
linprog(f,A,b,Aeq,beq,zeros(size(f)),[])