function plotGraphes(data,var)

data= importdata(data);

if var=='3'
    [~,X] = question3(data);
    T = repmat((0:1:data.T)',1,5);

elseif var=='5'
    question5;
    
elseif var=='8'
    [~,X] = question8(data);
    T = repmat((0:1:data.T)',1,8);

else
    [~,X] = question9(data);
    T = repmat((0:1:data.T)',1,8);

end

T = T
X = X 

figure;
plot(T,X);
xlabel('semaine');

if var=='3'
    legend('x_n','x_sup','x_st','x_ret','x_sst');
    title('Solution a personnel constant'); hold off;
elseif var=='8'
    legend('x_n','x_sup','x_st','x_ret','x_sst','n_ouv','n_emb','n_lic');
    title('Solution a personnel variable'); hold off;

else
    legend('x_n','x_sup','x_st','x_ret','x_sst','n_ouv','n_emb','n_lic');
    title('Solution a personnel variable'); hold off;

end


end
