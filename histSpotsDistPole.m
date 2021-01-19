%% Copyright Géraldine Laloux, UCLouvain, February 2020.
%% This script plots the histogram of spots position between the cell pole (0)
% and midcell position (0.5) for cells with 1 spot.
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
%% Script
n = 0; 
cellL = cellListExtra.meshData; 
spotNumber_array = []; 
spotsDistPole_array = [];
maxPosition_array = [];
relSpotsDist_array = [];
for frame=1:length(cellL) 
    for cell=1:length(cellL{frame})
        if isfield(cellL{frame}{cell},'spots') 
            if length(cellL{frame}{cell}.spots.l) == 1 
            n = n + 1;
            spotsDistPole = cellL{frame}{cell}.spots.l; 
            maxPosition = cellL{frame}{cell}.length; 
            relSpotsDist = spotsDistPole/maxPosition; 
                if relSpotsDist > 0.5 
                relSpotsDist = 1-relSpotsDist;
                end
            maxPosition_array = [maxPosition_array maxPosition]; 
            spotsDistPole_array = [spotsDistPole_array spotsDistPole];
            relSpotsDist_array = [relSpotsDist_array relSpotsDist];
            end
        end
    end
end
%% Output
%histogram
c = 0:0.025:0.5; 
h = hist(relSpotsDist_array,c); 
hPERC = 100*h/(sum(h)); 
%plot
figure1 = figure; 
plot(c,hPERC,'y') 
