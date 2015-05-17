function printSol(X)

[M,N] = size(X);

RLAB = num2str(1:M);
CLAB = 'x_n x_sup x_st x_ret x_sst n_ouv n_emb n_lic';
printmat(X, 'Solution', RLAB, CLAB )

%fprintf('\nSemaine\t x_n\t x_sup\t x_st\t x_ret\tx_sst\t n_ouv\t n_emb\t n_lic');
%for i=1:M
%    fprintf('\n%d',i-1);
%    for j=1:N
%        fprintf('\t %.1d',X(i,j));
%    end
%end
   
end