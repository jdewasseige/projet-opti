function [A,b] = getIneqConstraints(T,d)

to = getToX;

d_ah = d.duree_assemblage/60;
c_ouvriers = d.nb_ouvriers/d_ah;

% vecteurs qui multiplient x_s et x_s-1 pour la contrainte 2
dSineg1  = [-1 -1 1 0 -1 0 0 0]; 
dpSineg1 = [0  0 -1 1  0 0 0 0];

% matrice supplementaire pour acceder a
% [n_ouv n_emb -n_lic] pour chaque semaine
A_personnel_v = kron([zeros(T,1),eye(T)], to.Ouv);

Anor = [kron([zeros(T,1),eye(T)],to.Nor)-35/d_ah*A_personnel_v] ;
bnor = zeros(T,1);

Asup = [kron([zeros(T,1),eye(T)],to.Sup)-d.nb_max_heure_sup/d_ah*A_personnel_v];
bsup = zeros(T,1);

Asst = kron([zeros(T,1),eye(T)],to.Sst);
bsst = repmat(d.nb_max_sous_traitant,T,1);

Aouv = kron([zeros(T,1),eye(T)],to.Ouv);
bouv = repmat(d.nb_max_ouvriers,T,1);


A = [kron([eye(T),zeros(T,1)],dpSineg1) + kron([zeros(T,1),eye(T)],dSineg1);...
    Anor; Asup; Asst; Aouv];
b = [zeros(T,1);bnor;bsup;bsst;bouv];

end