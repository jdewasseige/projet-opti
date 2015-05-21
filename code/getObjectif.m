function f = getObjectif(T,d,L)

c = [d.cout_materiaux ;...
    d.cout_materiaux+d.duree_assemblage/60*d.cout_heure_sup ; ...
    d.cout_stockage; d.cout_retard; d.cout_sous_traitant;];


if L==8
    c = [c; 35*d.cout_horaire; d.cout_embauche; ...
        d.cout_licenciement];
end

f = repmat(c,T+1,1);

end