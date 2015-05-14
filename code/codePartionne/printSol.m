function printSol(X)

[M,N] = size(X)

fprintf('\nSemaine\t x_n\t x_sup\t x_st\t x_ret\tx_sst');
for i=1:M
    fprintf('\n%d',i-1);
    for j=1:N
        fprintf('\t %d',X(i,j));
    end
end
   
end