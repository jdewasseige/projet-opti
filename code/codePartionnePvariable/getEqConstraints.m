function [Aeq,beq] = getEqConstraints(T,d)

to = getToX;

L = 8; %   5 : nombre de smartphones de types differents 
       % + 3 : variables suppl�mentaires

% vecteurs qui multiplient x_s et x_s-1 pour la contrainte 1
dSeg1   = [1 1 -1 1 1 0 0 0];
dpSeg1  = [0 0 1 -1 0 0 0 0];

% vecteurs qui multiplient x_s et x_s-1 pour la contrainte 2
dSeg2   = [0 0 0 0 0 1 -1 1];
dpSeg2  = [0 0 0 0 0 -1 0 0];

Aeq = [kron([eye(T),zeros(T,1)],dpSeg1) + kron([zeros(T,1),eye(T)],dSeg1);...
    kron([eye(T),zeros(T,1)],dpSeg2) + kron([zeros(T,1),eye(T)],dSeg2);...
    kron([1,zeros(1,T)],eye(L));...
    zeros(1,L*T), to.Stock; zeros(1,L*T),to.Retard];

beq = [d.demande';zeros(T,1);zeros(2,1);d.stock_initial;zeros(2,1);
    d.nb_ouvriers; zeros(2,1); d.stock_initial;0];

end