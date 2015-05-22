function [cout,X] = question8(donnees)
%QUESTION8 - Implementation et solution du modele lineaire continu de 
%            la ligne d'assemblage personnel constant. En plus de renvoyer
%            les resultats, cette fonction les affiche.
%
% input    - donnees : si aucun vecteur de donnees n'est utilise en
%                      argument, alors on utilise le fichier 'donnees.mat'
%
% output   - cout    : valeur du cout optimal
%
%          - X       : matrice de taille Tx8 ou l'element x_(i,j)
%                      correspond au nombre de smartphones de type j
%                      produits pendant la semaine i
%                      j correspond a un des types suivants
%                      [x_normal x_suplementaire x_stock x_retard x_sst 
%                       n_ouv n_emb n_lic]

if nargin==0
    d = importdata('donnees.mat');
else
    d = donnees;
end

L = 8;

[cout,X] = solve(d,L);

cout = cout - 35*d.nb_ouvriers*d.cout_horaire ...
    - d.stock_initial*d.cout_stockage ;

printSol(cout,X,L);

end
