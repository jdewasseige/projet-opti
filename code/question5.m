function question5(donnees)
%QUESTION5 - Affiche les graphes de comparaison d'erreur et d'efficacite
%            primal-dual.

% input    - donnees : si aucun vecteur de donnees n'est utilise en
%                      argument, alors on utilise le fichier 'donnees.mat'

if nargin==0
    d = importdata('donnees.mat');
else
    d = donnees;
end

%close all;

compareDualitySpeed;
compareDualityValues;

%% compare couts
    function compareDualityValues
    
        n = 10;
        epsilon = linspace(0,1,n);
    
        cout_primal = multiplePrimal(n,epsilon);
        cout_dual = multipleDual(n,epsilon);
    
        for i=1:n
            fprintf('%d \t %d \n', cout_primal(i), cout_dual(i));
        end
    
        figure
        plot(epsilon,cout_primal,'.-r',epsilon,cout_dual,'.-b');
        xlabel('epsilon');
        ylabel('cout');
        legend('primal','dual');
        title('Effets des perturbations sur le cout'); hold off;

    end

%% compare efficiency
    function compareDualitySpeed

        nValues = [5 10 30 60];
        j=0;
        for alpha = nValues
            j = j+1;
            tic; multiplePrimal(alpha,linspace(0,1,alpha)); nP(j) = toc; toc
            tic; multipleDual(alpha,linspace(0,1,alpha)); nD(j) = toc; toc
        end

        figure
        plot(nValues,nP,'.-r',nValues,nD,'.-b');
        xlabel('Nombre de perturbations differentes etudiees');
        ylabel('CPU time');
        legend('primal','dual');
        title('Computational efficiency'); hold off;

    end

%% multiplePrimal
    function couts = multiplePrimal(n,epsilon)
        couts = zeros(n,1);
        dPrimal = d;

        for i=1:n
            dPrimal.demande = d.demande + epsilon(i)*d.delta_demande;
            [couts(i),~] = question3(dPrimal);
            fprintf('cout primal = %d \n',couts(i));
        end
    end

%% multipleDual
    function couts = multipleDual(n,epsilon)
        couts = zeros(n,1);

        [~,x_dual,f_dual] = getDualInfos(d);
        newObj = f_dual;
    
        for i=1:n
            newObj(1:d.T) = f_dual(1:d.T) + epsilon(i)*d.delta_demande' ;
            couts(i) = newObj'*x_dual - d.stock_initial*d.cout_stockage ...
                + d.T*35*d.nb_ouvriers*d.cout_horaire;
            fprintf('cout dual = %d \n',couts(i));
        end
    end 

end
