function [cout,X] = question3(donnees)
%QUESTION3 - Implementation et solution du modele lineaire continu de 
%            la ligne d'assemblage personnel constant.

% input    - donnees : si aucun vecteur de donnees n'est utilise en
%                      argument, alors on utilise le fichier 'donnees.mat'
%
% output   - cout    : valeur du cout optimal
%
%          - X       : matrice de taille Tx5 ou l'element x_(i,j)
%                      correspond au nombre de smartphones de type j
%                      produits pendant la semaine i
%                      j correspond a un des types suivants
%                      [x_normal x_supplementaire x_stock x_retard x_sst]

if nargin==0
    d = importdata('donnees.mat');
else
    d = donnees;
end

L = 5;

[cout,X] = solve(d,L);

cout = cout - d.stock_initial*d.cout_stockage ...
    + d.T*35*d.nb_ouvriers*d.cout_horaire ;

%printSol(cout,X,L);


end
