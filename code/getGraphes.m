function getGraphes
%GETGRAPHES - Interface graphique pour obtenir les graphes utilises
%             dans le rapport.


% creation du cadre
handles(1)=figure('units','pixels',...
    'position',[900 300 400 500],...
    'color',[0.935 0.95 0.657],...
    'numbertitle','off',...
    'name','Graphes',...
    'menubar','none');

%%%%%%%%%% DONNEES %%%%%%%%%%

% fichier de donnees
uicontrol ( 'style' , ' text' , 'units',...
    'normalized', 'position', [0.1,0.8,0.38,0.05] ,...
    'backgroundcolor','g','fontsize',15,'fontname','roman',...
    'string' , 'Donnees' );
donnees= uicontrol ( 'style' , 'edit' ,...
    'fontname','arial','fontsize',15,...
    'units','normalized', 'position', [0.5,0.8,0.3,0.06] ,...
    'string' , 'donnees.mat' );

% questions
uicontrol ( 'style' , ' text' , 'units',...
    'normalized', 'position', [0.,0.7,0.3,0.05] ,...
    'backgroundcolor','m','fontsize',15,'fontname','roman',...
    'string' , 'Questions' );

%%%%%%%%%% BOUTONS %%%%%%%%%%

% questions
uicontrol('style','pushbutton',... 
    'units','normalized',...
    'position',[0.3 0.55 0.4 0.06],...
    'string','question 3',...    
    'fontsize',13',...
    'callback',{@plotGraph,'3'});
uicontrol('style','pushbutton',... 
    'units','normalized',...
    'position',[0.3 0.40 0.4 0.06],...
    'string','question 5',...    
    'fontsize',13',...
    'callback',{@plotGraph,'5'});
uicontrol('style','pushbutton',... 
    'units','normalized',...
    'position',[0.3 0.25 0.4 0.06],...
    'string','question 8',...    
    'fontsize',13',...
    'callback',{@plotGraph,'8'});
uicontrol('style','pushbutton',... 
    'units','normalized',...
    'position',[0.3 0.10 0.4 0.06],...
    'string','question 9',...    
    'fontsize',13',...
    'callback',{@plotGraph,'9'});

% informations
action=uicontrol ( 'style' , ' text' , 'units',...
    'normalized', 'position', [0.05,0.9,0.92,0.05] ,...
    'backgroundcolor','k','foregroundcolor','w','fontsize',15,'fontname','roman',...
    'string' , 'Hello !' );

% stop
uicontrol('style','pushbutton',...
    'units','normalized',...
    'position',[0.1 0.01 0.8 0.06],...
    'string','STOP',...  
    'fontsize',13',...
    'callback',@stopAll);

%%%%%%%%%% FONCTIONS %%%%%%%%%%

function plotGraph(~,~,var)
    dataFile = get(donnees,'string');
    
    plotGraphes(dataFile,var);
    
    if var=='3'
        set(action,'String','Graphe question 3 : done');
    elseif var=='5'
        set(action,'String','Graphe question 5 : done');
    elseif var=='8'
        set(action,'String','Graphe question 8 : done');
    else
        set(action,'String','Graphe question 9 : done');
    end
end

function stopAll(~,~)
    close 'Graphes'
    close all
end


end

