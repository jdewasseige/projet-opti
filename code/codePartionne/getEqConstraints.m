function [Aeq,beq] = getEqConstraints(T,d)

to = getToX;

L = 5;

% vecteurs qui multiplient x_s et x_s-1 pour la contrainte 1
dSeg   = [1 1 -1 1 1];
dpSeg  = [0 0 1 -1 0];

Aeq = [kron([eye(T),zeros(T,1)],dpSeg) + kron([zeros(T,1),eye(T)],dSeg);
    kron([1,zeros(1,T)],eye(5));
    zeros(1,L*(T)), to.Stock; zeros(1,L*(T)),to.Retard];
beq = [d.demande';zeros(2,1);d.stock_initial;zeros(2,1);
    d.stock_initial;0];

end