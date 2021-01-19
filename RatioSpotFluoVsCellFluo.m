%% Copyright Géraldine Laloux, UCLouvain, Sep 2020
%% This script computes the ratio of relative fluo in the spot /
% relative fluo in the cell body. 
%% REQUIREMENTS
% Oufti cellList with spots field obtained after running the
% spotDetection tool.
%% INPUT 
scalefactor = 0.07; % conversion pixel to microns  
%% This section gets extradata from the meshData provided by Oufti (to obtain calculated length, width, ... among other cell features)
% and creates a new cellList named cellListExtra
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
%% cellList renaming
cellL = cellListExtra.meshData;
%% script
ratioArray = [];
n = 0;
for frame = 1:length(cellL)
    for cell = 1:length(cellL{frame})
        if isempty(cellL{frame}{cell})
        continue
        end 
        if ~isfield(cellL{frame}{cell},'signal2') 
        continue
        end 
        if ~isfield(cellL{frame}{cell},'spots2') 
        continue
        end   
        if length(cellL{frame}{cell}.spots2.l) >1
            continue
        end
        if ~isfield(cellL{frame}{cell},'lengthvector') 
        continue
        end   
    segmNumb = length(cellL{frame}{cell}.lengthvector); 
    spotPos = cellL{frame}{cell}.spots.positions; 
    pass = single(spotPos);
    if isnan(pass)
        continue
    end
    n = n+1; % total cell counter    
    spotLim1 = spotPos-2; 
    spotLim2 = spotPos+2;
        if spotLim1 <= 0 % adjust spot bounderies if those are too close to the cell bounderies
            spotLim1 = 1;
        end
        if spotLim2 <= 0
            spotLim1 = 1;
        end
        if spotLim1 >= segmNumb
            spotLim1 = segmNumb;
        end
        if spotLim2 >= segmNumb
            spotLim2 = segmNumb;
        end    
    spotInt = sum(cellL{frame}{cell}.signal1(spotLim1:spotLim2)); 
    spotArea = sum(cellL{frame}{cell}.steparea(spotLim1:spotLim2)); 
    relSpotInt = spotInt/spotArea; 
    cellInt = sum(cellL{frame}{cell}.signal1); 
    cellBodyInt = cellInt - spotInt; 
    cellArea = sum(cellL{frame}{cell}.steparea);
    cellBodyArea = cellArea - spotArea;
    relBodyInt = cellBodyInt/cellBodyArea; 
    ratioSpotBody = relSpotInt/relBodyInt;
    ratioArray = [ratioArray ratioSpotBody];
    end
end
%% histogram 
ratioArray = ratioArray(~isnan(ratioArray)); 
n = length(ratioArray); 
maxRatio = max(ratioArray);
c = 0:0.5:maxRatio; 
h = hist(ratioArray,c);
hperc = 100*h/sum(h);
disp(['cell number:' num2str(n)])
figure;
plot(c,hperc,'r','LineWidth',2)
ylabel('Fraction of cells (%)')
xlabel('Ratio spot/cell body intensities')
