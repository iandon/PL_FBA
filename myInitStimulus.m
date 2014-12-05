function stimulus = myInitStimulus(stimulus,myscreen,task)
global MGL;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% function to init the stimulus
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% let's get the linearized gamma table
stimulus.linearizedGammaTable = mglGetGammaTable;
stimulus.linearizedGammaTable.redTable(1:3) = 0; % this is just to provisionally deal with what appears to be some bug: the first value in each of these gamma tables is a NaN
stimulus.linearizedGammaTable.greenTable(1:3) = 0;
stimulus.linearizedGammaTable.blueTable(1:3) = 0;


stimulus.xpxpcm = myscreen.screenWidth/myscreen.displaySize(1);
stimulus.ypxpcm = myscreen.screenHeight/myscreen.displaySize(2);

stimulus.xpxpdeg = ceil(tan(2*pi/360)*myscreen.displayDistance*stimulus.xpxpcm);
stimulus.ypxpdeg = ceil(tan(2*pi/360)*myscreen.displayDistance*stimulus.ypxpcm);

% centerpix = [myscreen.screenWidth/2,myscreen.screenHeight/2];

% stimulus.contrasts =contrast;

stimulus.frameThick = .08;
stimulus.reservedColors = [0 0 0; 1 1 1; 0 .6 0];


stimulus.nReservedColors=size(stimulus.reservedColors,1);
stimulus.nGratingColors = 256-(2*floor(stimulus.nReservedColors/2)+1);
stimulus.minGratingColors = 2*floor(stimulus.nReservedColors/2)+1;
stimulus.midGratingColors = stimulus.minGratingColors+floor(stimulus.nGratingColors/2);
stimulus.maxGratingColors = 255;
stimulus.deltaGratingColors = floor(stimulus.nGratingColors/2);

stimulus.nDisplayContrasts = stimulus.deltaGratingColors;

% to set up color values

stimulus.black = [0 0 0];
stimulus.white = [1/255 1/255 1/255];
stimulus.green = [0 160 0];
stimulus.blue = [0 0 160];
stimulus.greencorrect = [0 200 20];
stimulus.redincorrect = [255 0 0];
stimulus.orangenoanswer = [255 215 0];
stimulus.grey = [.025 .025 .025];
stimulus.background = [stimulus.midGratingColors/255 stimulus.midGratingColors/255 stimulus.midGratingColors/255];
stimulus.fixation.color = [0; .6; 0]'; % green
stimulus.grayColor = stimulus.background;

% audio
stimulus.noanswer = find(strcmp(MGL.soundNames,'Ping'));
stimulus.CorrectSound = find(strcmp(MGL.soundNames,'Submarine'));
stimulus.IncorrectSound = find(strcmp(MGL.soundNames,'Basso'));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% set up grid:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

stimulus.gaborSize = .75; %degress
stimulus.numGridLocs = 24; %going to exclude 13th, which is around fixation

stimulus.numGridRows = 5;
stimulus.numGridColumns = stimulus.numGridRows;

stimulus.jitterOffsetEDGES = .2; %what is the distance between
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

% %% plot grid locations
% 
% anglesPlaceHolders = 0:.05:(2*pi);
% placeholderLocs = [(stimulus.gaborSize/2)*cos(anglesPlaceHolders'),(stimulus.gaborSize/2)*sin(anglesPlaceHolders')];
% 
% 
% axisbound = 6;
% figure, hold on
% for gridLoc = 1:24
%     for i = 1:length(anglesPlaceHolders)
%         plot(stimulus.gridLoc{gridLoc}(:,1)+placeholderLocs(i,1),stimulus.gridLoc{gridLoc}(:,2)+placeholderLocs(i,2),'b.')
%     end
% %     plot(stimulus.gridLocCenter{gridLoc}(:,1),stimulus.gridLocCenter{gridLoc}(:,2),'b*')
% end
% plot(0,0,'r+')
% axis([-axisbound,axisbound,-axisbound,axisbound])
% hold off




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% stimulus parameters:
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% gabors
stimulus.width = stimulus.gaborSize; % in deg
stimulus.height = stimulus.gaborSize;% in deg
stimulus.gaussSdx = stimulus.width/7;                % in deg
stimulus.gaussSdy = stimulus.height/7;               % in deg
stimulus.sizedg = stimulus.gaborSize; 

stimulus.rotation = [1,-1]; % this is the tilt orientation of the gabor stimulus from vertical in Degrees
stimulus.init = 1;

stimulus.sf = 4;                % in cpd
stimulus.orientation = 0;       % in deg
stimulus.phase = 180.*rand(stimulus.numGridLocs,task{1}.numTrials,2); % in deg

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% make grid locs
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for i = 1:task{1}.numTrials
    for interval = 1:2
        stimulus.randVars.gridLocs(i,interval,:) = randperm(stimulus.numGridLocs);
        stimulus.randVars.targetGridLocs(i,interval,:) = stimulus.randVars.gridLocs(i,interval,1:stimulus.numGridLocs/2);
        stimulus.randVars.distractorGridLocs(i,interval,:) = stimulus.randVars.gridLocs(i,interval,((stimulus.numGridLocs/2)+1):end);
    end
    
    for gridLoc = 1:stimulus.numGridLocs
        stimulus.randVars.jitterLoc(i,gridLoc,:) = randperm(size(stimulus.jitterLoc,1));
    end
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% make stim texture
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
numGratings = 0;
gratingMatrix = cell(task{1}.numTrials,stimulus.numGridLocs,2);
disppercent(-inf,'Calculating grating matrices');
for trial = 1:stimulus.numTrials
        for gridLoc = 1:stimulus.numGridLocs
            for interval = 1:2
                numGratings = numGratings+1;
                gratingMatrix{trial,gridLoc,interval} = mglMakeGrating(stimulus.width,...
                                                                          stimulus.height,...
                                                                          stimulus.sf,...
                                                                          90,... %orienation set to 90 => rotated in drawGabor
                                                                          stimulus.phase(numGratings));
               disppercent(numGratings/(stimulus.numTrials*stimulus.numGridLocs*2));
            end
        end
end

res = mkR([size(gratingMatrix{1},1) size(gratingMatrix{1},2)]);

grating(:,:,4) = 255*mglMakeGaussian(stimulus.width,stimulus.height,stimulus.gaussSdx,stimulus.gaussSdy);

countGrating = 0;
disppercent(-inf,'Calculating gabors');
for trial = 1:stimulus.numTrials
    for gridLoc = 1:stimulus.numGridLocs
        for interval = 1:2
                % stimulus.texture
                grating(:,:,1) = stimulus.midGratingColors+gratingMatrix{trial,gridLoc,interval}*(127*stimulus.contrast);
                grating(:,:,2) = grating(:,:,1);
                
                grating(:,:,3) = grating(:,:,1);
                stimulus.tex{trial,gridLoc,interval} = mglCreateTexture(grating);
                %         disppercent(thisContrast/stimulus.deltaGratingColors);
                countGrating = countGrating+1;
                disppercent(countGrating/(stimulus.numTrials*stimulus.numGridLocs*2));
        end
    end
end

    

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% fixation
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
stimulus.FCwidth = .6;
stimulus.FClinewidth = 3;
stimulus.TrialStartFixDist=2; %2 degree radius in which to fixate before trial starts
stimulus.TrialStartFixDur=.25; %presents stimuli after this duration when fixation detected
stimulus.cornerDist=1;
stimulus.edgeDist=0;



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% RESPONSE CUE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%set parameters -> in degrees
respCue.length = 1;
respCue.startEcc = 0;

stimulus.respCue.width =3;
stimulus.respcueLocation = cell(2,1);

targetAngleVect = [45,-45,0,90];

for targetAngle = 1:length(targetAngleVect)
        stimulus.respcueLocation{targetAngle} = [ cosd(targetAngleVect(targetAngle))*respCue.length,...
                                                  sind(targetAngleVect(targetAngle))*respCue.length;...
                         
                                                 -cosd(targetAngleVect(targetAngle))*respCue.length,...
                                                 -sind(targetAngleVect(targetAngle))*respCue.length];
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% PRE CUE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% set parameters -> in degrees
% stimulus.preCue.type = 1; %should be always neutral for staircase
respCue.width = 3;

preCue.length = .8;
preCue.height = .2;
preCue.distToStim = .2 + (stimulus.height/2); %distance from center

neutCue.distToFixation = .1 + stimulus.FCwidth; %distance from center

stimulus.preCue.width =3;

% make matrices in stimulus structure
stimulus.preCueValidLocation = cell(4,1);
for targetAngle = 1:length(targetAngleVect)
        stimulus.preCueValidLocation{targetAngle} = [ cosd(targetAngleVect(targetAngle))*respCue.length,...
                                                      sind(targetAngleVect(targetAngle))*respCue.length;...
                         
                                                     -cosd(targetAngleVect(targetAngle))*respCue.length,...
                                                     -sind(targetAngleVect(targetAngle))*respCue.length];
end

for targetAngle = 1:4
stimulus.preCueNeutLocation{1} = [ cosd(targetAngleVect(targetAngle))*respCue.length,...
                                   sind(targetAngleVect(targetAngle))*respCue.length;...
                         
                                   -cosd(targetAngleVect(targetAngle))*respCue.length,...
                                   -sind(targetAngleVect(targetAngle))*respCue.length];

stimulus.preCueNeutLocation{2} = [-preCue.length/4, -neutCue.distToFixation;...
                                  preCue.length/4, -neutCue.distToFixation];                           
end