function compareDuality

d = importdata('donnees.mat');

compareDualitySpeed
compareDualityValues


%% compare couts
    function compareDualityValues
    n = 11;
    epsilon = linspace(0,1,n);
    cout_primal = multiplePrimal(n,d);
    cout_dual = multipleDual(n,d);
    for i=1:n
        fprintf('%d \t %d \n', cout_primal(i), cout_dual(i));
    end
    end

%% compare efficiency
    function compareDualitySpeed

    nValues = [5 10 30 60];
    j=0;
    for n = nValues
        j = j+1;
        tic; multiplePrimal(nValues(j),d) ; nP(j) = toc; toc
        tic; multipleDual(nValues(j),d); nD(j) = toc; toc
    end

    figure
    plot(nValues,nP,'.-r',nValues,nD,'.-b');
    xlabel('taille de epsilon');
    ylabel('CPU time');
    legend('primal','dual');
    title('Computational efficiency');

    end

%% multiplePrimal
    function couts = multiplePrimal(n)
    couts = zeros(n,1);
    epsilon = linspace(0,1,n);
    dPrimal = d;

    for i=1:n
        dPrimal.demande = d.demande + epsilon(i)*d.delta_demande;
        couts(i) = solveJohn(dPrimal,0);
        fprintf('cout primal = %d \n',couts(i));
    end
    
    end

%% multipleDual
    function couts = multipleDual(n)
    couts = zeros(n,1);
    epsilon = linspace(0,1,n);

    [valOptimum,x_dual,f_dual] = solveDualJohn(d,0);
    newObj = f_dual;
    for i=1:n
        newObj(1:d.T) = f_dual(1:d.T) + epsilon(i)*d.delta_demande' ;
        couts(i) = newObj'*x_dual;
        fprintf('cout dual = %d \n',couts(i));
    end
    
    end 

end
