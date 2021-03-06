function [Aeq,beq] = getEqConstraints(d,L)

to = getToX(L);

if L==5  % Personnel constant

    % Vecteurs qui multiplient x_s et x_s-1 pour la contrainte 1
    dSeg   = [1 1 -1 1 1];
    dpSeg  = [0 0 1 -1 0];

    Aeq = [kron([eye(d.T),zeros(d.T,1)],dpSeg) + kron([zeros(d.T,1),eye(d.T)],dSeg);
        kron([1,zeros(1,d.T)],eye(L));
        zeros(1,L*d.T), to.Stock; zeros(1,L*d.T),to.Retard];
    beq = [d.demande';zeros(2,1);d.stock_initial;zeros(2,1);
        d.stock_initial;0];
    
else  % Personnel variable

    % Vecteurs qui multiplient x_s et x_s-1 pour la contrainte 1
    dSeg1   = [1 1 -1 1 1 0 0 0];
    dpSeg1  = [0 0 1 -1 0 0 0 0];

    % Vecteurs qui multiplient x_s et x_s-1 pour la contrainte 2
    dSeg2   = [0 0 0 0 0 1 -1 1];
    dpSeg2  = [0 0 0 0 0 -1 0 0];

    Aeq = [kron([eye(d.T),zeros(d.T,1)],dpSeg1) + kron([zeros(d.T,1),eye(d.T)],dSeg1);...
        kron([eye(d.T),zeros(d.T,1)],dpSeg2) + kron([zeros(d.T,1),eye(d.T)],dSeg2);...
        kron([1,zeros(1,d.T)],eye(L));...
        zeros(1,L*d.T), to.Stock; zeros(1,L*d.T),to.Retard];

    beq = [d.demande';zeros(d.T,1);zeros(2,1);d.stock_initial;zeros(2,1);
        d.nb_ouvriers; zeros(2,1); d.stock_initial;0];
end

end