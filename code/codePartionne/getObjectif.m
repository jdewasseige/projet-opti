function f = getObjectif(T,d)

c = [d.cout_materiaux ...
    d.cout_materiaux+d.duree_assemblage/60*d.cout_heure_sup ...
    d.cout_stockage d.cout_retard d.cout_sous_traitant]';
f = repmat(c,T+1,1);
end