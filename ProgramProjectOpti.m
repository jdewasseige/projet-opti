%Importation des données
d = importdata('data.mat');

%Création du vecteur objectif (f)
a = [d.pc d.pc+d.nhb*(d.shs-d.shn) d.ps d.plr d.css];
f = a;
for i = 1:d.nbrSemaine-1
f = [f a];
end

%Matrice des contraintes d'égalité
Aeq = sparse(d.nbrSemaine, d.nbrSemaine*length(a));
for i = 2:d.nbrSemaine-1
    Aeq(i,(1+length(a)*(i-1)):(length(a)*(i-1)+5)) = [1 1 -1 1 1];
    Aeq(i,length(a)*(i-2)+3) = 1;
end
Aeq(1,3) = 1;
Aeq(d.nbrSemaine,(length(a)*d.nbrSemaine-2)) = 1;
beq = d.Demande; 

%Matrice des contraintes d'inégalité
A = sparse(2*d.nbrSemaine, d.nbrSemaine*length(a));
b = zeros(1,2*d.nbrSemaine);
for i = 1:d.nbrSemaine
    A(i, (length(a)*(i-1)+1)) = 1;
    b(1,i) = ((d.nhb)*35)/d.emplDepart;
end
for i = d.nbrSemaine+1:2*d.nbrSemaine
    A(i, (length(a)*(i-d.nbrSemaine-1)+2)) = 1;
    b(1,i) = ((d.nhb)*d.nbrhsupp)/d.emplDepart;
end

linprog(f,A,b,Aeq,beq,zeros(length(f)),[])