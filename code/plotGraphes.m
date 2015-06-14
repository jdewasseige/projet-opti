function plotGraphes(data,var)

data= importdata(data);

if var=='5'
    question5;
else

    if var=='3'
        [~,X] = question3(data);
    elseif var=='8'
        [~,X] = question8(data);
    else
        [~,X] = question9(data);
    end
    
    [~,n] = size(X);
    T = repmat((0:1:data.T)',1,n);


    figure;
    plot(T,X);
    xlabel('semaine');

    if var=='3'
        legend('x_n','x_sup','x_st','x_ret','x_sst');
        title('Solution a personnel constant'); hold off;
    else
        legend('x_n','x_sup','x_st','x_ret','x_sst','n_ouv','n_emb','n_lic');
        title('Solution a personnel variable'); hold off;
    end

end


end
