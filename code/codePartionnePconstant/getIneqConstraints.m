function [A,b] = getIneqConstraints(T,d)

to = getToX;

c_ouvriers = 60*d.nb_ouvriers/d.duree_assemblage;

% vecteurs qui multiplient x_s et x_s-1 pour la contrainte 2
dSineg  = [-1 -1 1 0 -1]; 
dpSineg = [0  0 -1 1  0];

Anor = kron([zeros(T,1),eye(T)],to.Nor);
bnor = repmat(35*c_ouvriers,T,1);
Asup = kron([zeros(T,1),eye(T)],to.Sup);
bsup = repmat(d.nb_max_heure_sup*c_ouvriers,T,1);
Asst = kron([zeros(T,1),eye(T)],to.Sst);
bsst = repmat(d.nb_max_sous_traitant,T,1);

A = [kron([eye(T),zeros(T,1)],dpSineg) + kron([zeros(T,1),eye(T)],dSineg);...
    Anor; Asup; Asst];
b = [zeros(T,1);bnor;bsup;bsst];

end