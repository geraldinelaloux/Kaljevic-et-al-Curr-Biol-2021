%% Copyright Géraldine Laloux, UCLouvain, March 2020.
%% This script plots the average fluorescence profile in a cell population, from one pole to another (cell lengths are normalized)...
... the fluorescence profile is normalized by steparea and relative values are obtained by dividing by the total normalized fluorescence in each cell
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
%% cellList renaming
cellL = cellListExtra.meshData;
%% count
n=0;
%% gets the total number of cells to determine the number of rows in the yi matrix
for frame = 1:length(cellL)
    for cell = 1:length(cellL{frame})
        if isempty(cellL{frame}{cell})
        continue
        end 
        if ~isfield(cellL{frame}{cell},'signal1') || ~isfield(cellL{frame}{cell},'signal2') 
        continue
        end 
        if isempty(cellL{frame}{cell}.signal1) || isempty(cellL{frame}{cell}.signal2)
        continue
        end
        if ~isfield(cellL{frame}{cell},'steparea') 
        continue
        end 
    n = n+1;
    end
end
%% gets fluorescence data vector 
    xi = 0:0.01:1; % the vector from 0 to 1 representing normalized cell lengths (pole 0 to pole 1)
    yi1 = zeros(n,length(xi));
    yi2 = zeros(n,length(xi));
    n = 0;
for frame = 1:length(cellL)
    for cell = 1:length(cellL{frame})
        if isempty(cellL{frame}{cell})
        continue
        end
        if ~isfield(cellL{frame}{cell},'signal1') || ~isfield(cellL{frame}{cell},'signal2') 
        continue
        end 
        if isempty(cellL{frame}{cell}.signal1) || isempty(cellL{frame}{cell}.signal2)
        continue
        end
        if ~isfield(cellL{frame}{cell},'steparea') 
        continue
        end 
    n = n+1;    
    fluo1 = cellL{frame}{cell}.signal1;
    fluo2 = cellL{frame}{cell}.signal2;
%% orients the vectors based on signal intensity (optional)
    half = ceil(0.5*length(fluo1));
    bottomfluo = sum(fluo1(1:half));
    topfluo = sum(fluo1(length(fluo1)-half:length(fluo1)));
        if bottomfluo < topfluo 
            fluo1=flipud(fluo1); % GL:  orienting the array of relint
            fluo2=flipud(fluo2);            
        end
%% normalization of fluorescence in each segment by area of the segment
    area = cellL{frame}{cell}.steparea;
    cellarea = sum(area);
    normfluo1 = fluo1./area;
    normfluo2 = fluo2./area;
    relnormfluo1 = normfluo1./sum(normfluo1);
    relnormfluo2 = normfluo2./sum(normfluo2);
%% normalization of cell length from 0 to 1
    normlength = (cellL{frame}{cell}.lengthvector)/(cellL{frame}{cell}.length);
%% removes first and last segments to avoid bias of high intensity at tips of the cell
    relnormfluo1 = relnormfluo1(2:length(relnormfluo1)-1);
    relnormfluo2 = relnormfluo2(2:length(relnormfluo2)-1);
    normlength = normlength(2:length(normlength)-1);
%% interpolation: estimates fluo values at each point of xi
    yi1(n,:) = interp1(normlength,relnormfluo1,xi,'linear','extrap');
    yi2(n,:) = interp1(normlength,relnormfluo2,xi,'linear','extrap');
    end
end
%% gets the average intensity profile
avgnormfluo1 = mean(yi1,1,'omitnan');
avgnormfluo2 = mean(yi2,1,'omitnan');
%% plots profile vs xi 
figure; 
plot(xi,avgnormfluo1,'LineWidth',2,'color','y'); % Note: units are relative fluorescence
hold on
plot(xi,avgnormfluo2,'LineWidth',2,'color','r'); % Note: units are relative fluorescence
%% end




