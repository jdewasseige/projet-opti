function [A,b] = getIneqConstraints(d,L)

to = getToX(L);

d_ah = d.duree_assemblage/60;
c_ouvriers = d.nb_ouvriers/d_ah;

if L==5 % Personnel constant
    
    % Vecteurs qui multiplient x_s et x_s-1 pour la contrainte 2
    dSineg  = [-1 -1 1 0 -1]; 
    dpSineg = [0  0 -1 1  0];
    
    Anor = kron([zeros(d.T,1),eye(d.T)],to.Nor);
    bnor = repmat(35*c_ouvriers,d.T,1);
    Asup = kron([zeros(d.T,1),eye(d.T)],to.Sup);
    bsup = repmat(d.nb_max_heure_sup*c_ouvriers,d.T,1);

else % Personnel variable

    % Vecteurs qui multiplient x_s et x_s-1 pour la contrainte 2
    dSineg  = [-1 -1 1 0 -1 0 0 0]; 
    dpSineg = [0  0 -1 1  0 0 0 0];

    % Matrice supplementaire pour acceder a
    % [n_ouv n_emb -n_lic] pour chaque semaine
    A_personnel_v = kron([zeros(d.T,1),eye(d.T)], to.Ouv);

    Anor = [kron([zeros(d.T,1),eye(d.T)],to.Nor)-35/d_ah*A_personnel_v] ;
    bnor = zeros(d.T,1);

    Asup = [kron([zeros(d.T,1),eye(d.T)],to.Sup)-d.nb_max_heure_sup/d_ah*A_personnel_v];
    bsup = zeros(d.T,1);

    Aouv = kron([zeros(d.T,1),eye(d.T)],to.Ouv);
    bouv = repmat(d.nb_max_ouvriers,d.T,1);

end

Asst = kron([zeros(d.T,1),eye(d.T)],to.Sst);
bsst = repmat(d.nb_max_sous_traitant,d.T,1);

A = [kron([eye(d.T),zeros(d.T,1)],dpSineg) + kron([zeros(d.T,1),eye(d.T)],dSineg);...
    Anor; Asup; Asst];
b = [zeros(d.T,1);bnor;bsup;bsst];


if L==8
    A = [A; Aouv];
    b = [b; bouv];
end

end