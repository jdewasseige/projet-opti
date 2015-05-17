function toVec = getToX

% acceder a x_lambda
% avec x_s = [x_n x_sup x_stock x_retard x_sst]'
toVec.Nor   = [1 0 0 0 0 0 0 0];
toVec.Sup   = [0 1 0 0 0 0 0 0];
toVec.Stock = [0 0 1 0 0 0 0 0];
toVec.Retard= [0 0 0 1 0 0 0 0];
toVec.Sst   = [0 0 0 0 1 0 0 0];
toVec.Ouv   = [0 0 0 0 0 1 0 0];
toVec.Emb   = [0 0 0 0 0 0 1 0];
toVec.Lic   = [0 0 0 0 0 0 0 1];


end