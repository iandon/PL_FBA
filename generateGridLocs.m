
stimulus.gaborSize = .75; %degress
stimulus.numGridLocs = 24; %going to exclude 13th, which is around fixation

stimulus.numGridRows = 5;
stimulus.numGridColumns = stimulus.numGridRows;

stimulus.jitterOffsetEDGES = .25; %what is the distance between
stimulus.jitterOffset = stimulus.jitterOffsetEDGES/2 + stimulus.gaborSize/2; %degrees, center to center distance

stimulus.jitterLoc = [ 0,                     stimulus.jitterOffset;...
                      -stimulus.jitterOffset, 0;...
                       stimulus.jitterOffset, 0;...
                       0,                    -stimulus.jitterOffset];

stimulus.distBtwnGridLoc = .5; %what is the spacing between each grid location, including the nearest 2 gabor locations
stimulus.spaceBtwnGridLocCENTERS = stimulus.gaborSize*2+stimulus.jitterOffset+stimulus.distBtwnGridLoc;

firstInRow = [1,6,11,15,20];


%1st row, left-most stimulus
stimulus.gridLocCenter{1} = [-(2*stimulus.spaceBtwnGridLocCENTERS),...
                             (2*stimulus.spaceBtwnGridLocCENTERS)]; %upper left corner
                         
rowNum = 1;                    
for gridLoc = 2:24
    if sum(gridLoc == firstInRow) %if it is the first in the row, put it below the 1st in the row above
        rowNum = rowNum+1;
        stimulus.gridLocCenter{gridLoc} = [stimulus.gridLocCenter{firstInRow(rowNum-1)}(1),...
                                          stimulus.gridLocCenter{firstInRow(rowNum-1)}(2)-stimulus.spaceBtwnGridLocCENTERS];
    elseif (gridLoc == 13) %if it is the 13th, instead of putting it ontop of fixation, move it to the right of fixation
        stimulus.gridLocCenter{gridLoc} = [stimulus.gridLocCenter{gridLoc-1}(1)+(2*stimulus.spaceBtwnGridLocCENTERS),...
                                           stimulus.gridLocCenter{gridLoc-1}(2)];
    else %%if it is not the first in the row and not the 13th item, put it right next to the previous location in the row
        stimulus.gridLocCenter{gridLoc} = [stimulus.gridLocCenter{gridLoc-1}(1)+stimulus.spaceBtwnGridLocCENTERS,...
                                           stimulus.gridLocCenter{gridLoc-1}(2)];
    end
end

stimulus.gridLoc = cell(stimulus.numGridLocs,1);

% for each grid location, place all of the jitter locations around the
% center
for gridLoc = 1:24
    for row = 1:size(stimulus.jitterLoc,1)
        stimulus.gridLoc{gridLoc}(row,:) = stimulus.jitterLoc(row,:) + stimulus.gridLocCenter{gridLoc};
    end
end

%% plot grid locations

anglesPlaceHolders = 0:.05:(2*pi);
placeholderLocs = [(stimulus.gaborSize/2)*cos(anglesPlaceHolders'),(stimulus.gaborSize/2)*sin(anglesPlaceHolders')];


axisbound = 6;
figure, hold on
for gridLoc = 1:24
    for i = 1:length(anglesPlaceHolders)
        plot(stimulus.gridLoc{gridLoc}(:,1)+placeholderLocs(i,1),stimulus.gridLoc{gridLoc}(:,2)+placeholderLocs(i,2),'b.')
    end
%     plot(stimulus.gridLocCenter{gridLoc}(:,1),stimulus.gridLocCenter{gridLoc}(:,2),'b*')
end
plot(0,0,'r+')
axis([-axisbound,axisbound,-axisbound,axisbound])
hold off


