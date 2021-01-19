%% Copyright Géraldine Laloux, UCLouvain, April 2020
%% This script gets the distance between each signal 1 spot and the closest signal 2 spot, ...
...plots a histogram of these shortest distances and ...
...displays the fraction of signal 1 spots that are located within a user-defined distance of the closest spots from signal 2.
%% REQUIREMENTS
% your spots fields should be named spots for signal 1 and spots2 for
% signal 2. 
%% INPUTS
scalefactor = 0.07; % conversion factor from pix to um
T = 0.2; % threshold distance (in um) under which two spots are considered as colocalized
%% gets extradata from the meshData provided by Oufti 
for frame=1:length(cellList.meshData)
    for cell=1:length(cellList.meshData{frame})
        if isfield (cellList.meshData{frame}{cell},'length')
            cellListExtra.meshData{frame}{cell} = cellList.meshData{frame}{cell};
        end
        if ~isfield (cellList.meshData{frame}{cell},'length')
        cellListExtra.meshData{frame}{cell} = getextradata(cellList.meshData{frame}{cell});
        end
    end
end
% rename cellList
cellL = cellListExtra.meshData; 
%% script
shortest = [];
totspots = [];
n = 0; % cell counter
for frame = 1:length(cellL)
for cell = 1:length(cellL{frame})
     if ~isempty (cellL{frame}{cell}) && isfield(cellL{frame}{cell},'signal1') && isfield(cellL{frame}{cell},'signal2')...
             && isfield(cellL{frame}{cell},'spots') && isfield(cellL{frame}{cell},'spots2')...
             && ~isempty(cellL{frame}{cell}.spots.positions) && ~isempty(cellL{frame}{cell}.spots2.positions)
        
        nspots = length(cellL{frame}{cell}.spots.positions); 
        nspots2 = length(cellL{frame}{cell}.spots2.positions); 
        totspots = [totspots nspots]; 
        n = n+1;
        X = [];
        Y = [];
        X2 = [];
        Y2 = [];
        d = [];
        %% euclidian coordinates of each spot of signal 1
        for i = 1:nspots
            X(i) = cellL{frame}{cell}.spots.x(i);
            Y(i) = cellL{frame}{cell}.spots.y(i);    
        end
        %% euclidian coordinates of each spot of signal 2
        for j = 1:nspots2
            X2(j) = cellL{frame}{cell}.spots2.x(j);
            Y2(j) = cellL{frame}{cell}.spots2.y(j);
        end
        %% for each spot of signal 1, gets the distance from each of the spots of signal 2. Then keeps the shortest of those distances.
        for i = 1:nspots
            for j = 1:nspots2
            d(j) = sqrt(((X(i)-X2(j))^2)+((Y(i)-Y2(j))^2)); 
            end
            shortest = [shortest scalefactor*min(d)];
        end
     end
end
end
%% OUPUTS
%% plots histogram of distances (in um) between each spot of signal 1 and its closest spot of signal 2
c = 0:0.05:2;
h = hist(shortest,c);
hperc = 100*h/sum(h);
figure;
bar(c,hperc);
xlabel('Shortest distance between spots (µm)','FontSize',20);
ylabel('Fraction of cells (%)','FontSize',20);
%% gives percentage P of spots of signal 1 for which the closest spot of signal 2 was located within the threshold distance T
coloc = length(shortest(shortest<=T));
P = 100*coloc/length(shortest);
disp(['% of spots of signal 1 with colocalizing spot of signal 2 = ' num2str(P)])
%% total number of cells used for calculation and total number of spots of signal 1 taken into account.
disp(['number of cells =' num2str(n)])
disp(['number of spots =' num2str(sum(totspots))])
