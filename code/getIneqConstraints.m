function [A,b] = getIneqConstraints(T,d,L)

to = getToX(L);

d_ah = d.duree_assemblage/60;
c_ouvriers = d.nb_ouvriers/d_ah;

if L==5 % personnel constant
    
    % vecteurs qui multiplient x_s et x_s-1 pour la contrainte 2
    dSineg  = [-1 -1 1 0 -1]; 
    dpSineg = [0  0 -1 1  0];
    
    Anor = kron([zeros(T,1),eye(T)],to.Nor);
    bnor = repmat(35*c_ouvriers,T,1);
    Asup = kron([zeros(T,1),eye(T)],to.Sup);
    bsup = repmat(d.nb_max_heure_sup*c_ouvriers,T,1);

else % personnel variable

    % vecteurs qui multiplient x_s et x_s-1 pour la contrainte 2
    dSineg  = [-1 -1 1 0 -1 0 0 0]; 
    dpSineg = [0  0 -1 1  0 0 0 0];

    % matrice supplementaire pour acceder a
    % [n_ouv n_emb -n_lic] pour chaque semaine
    A_personnel_v = kron([zeros(T,1),eye(T)], to.Ouv);

    Anor = [kron([zeros(T,1),eye(T)],to.Nor)-35/d_ah*A_personnel_v] ;
    bnor = zeros(T,1);

    Asup = [kron([zeros(T,1),eye(T)],to.Sup)-d.nb_max_heure_sup/d_ah*A_personnel_v];
    bsup = zeros(T,1);

    Aouv = kron([zeros(T,1),eye(T)],to.Ouv);
    bouv = repmat(d.nb_max_ouvriers,T,1);

end

Asst = kron([zeros(T,1),eye(T)],to.Sst);
bsst = repmat(d.nb_max_sous_traitant,T,1);

A = [kron([eye(T),zeros(T,1)],dpSineg) + kron([zeros(T,1),eye(T)],dSineg);...
    Anor; Asup; Asst];
b = [zeros(T,1);bnor;bsup;bsst];


if L==8
    A = [A; Aouv];
    b = [b; bouv];
end

end