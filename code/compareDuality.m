function compareDuality

d = importdata('donnees.mat');
dPrimal = d;

n = 3;
epsilon = linspace(0,1,n);

fprintf('\nPrimal\n');
tic
for i=1:n
    dPrimal.demande = dPrimal.demande + epsilon(i)*d.delta_demande;
    solveJohn(dPrimal,0)
end
toc

fprintf('\nDual\n');
tic
[valOptimum,x_dual,f_dual] = solveDualJohn(d,0);

for i=1:n
    f_dual(1:d.T) = f_dual(1:d.T) + epsilon(i)*d.delta_demande' ;
    cout_dual = f_dual'*x_dual
end
    
toc




end
