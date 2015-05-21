function printSol(cout,X,L)

[M,N] = size(X);

RLAB = num2str(1:M);
if L==5
    CLAB = 'x_n x_sup x_st x_ret x_sst';
else 
    CLAB = 'x_n x_sup x_st x_ret x_sst n_ouv n_emb n_lic';
end

printmat(X, 'Solution', RLAB, CLAB );

fprintf('\nLe cout total vaut : %.2f \n',cout);


   
end