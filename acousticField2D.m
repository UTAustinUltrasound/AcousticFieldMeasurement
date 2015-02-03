function [picoData] = acousticField2D(ESP, motors, vel, width, step)
% The purpose of this function is to implement a 2D raster scan using
% Newport motors
%
%   The scan should move to the right, down 1, to the left, down 1, to the
%   right, down 1, etc
%   PosMax is a vector of length 2. PosMax(1) corresponds to the maximum
%   distance to be traveled by Motor 1.
%   vel is a vector of length 2. vel(1) corresponds to the velocity of
%   motor 1 (should you choose to set different velocities for the two motors.
%
% Robin Hartman Jan 2015
% Last Edit: Andrew Fowler, Feb 2015

xDim = round(width(1)/step) + 1; 
yDim = round(width(2)/step) + 1;

% M1=[0:step:width(1)]; %Matrix with number of steps that Motor 2 will take
% M2=[0:step:width(2)]; %Matrix with number of steps that Motor 2 will take

% Find initial position (for debug)
initPos = [findposition(ESP,motors(1)),findposition(ESP,motors(2))];

% Move to starting position for field measurement.  if Even, posititive
% displacement, if odd, negative.
% if mod(xDim,2) == 0
%     startPos(1)= reldisplace(ESP,motors(1),((xDim-1)/2)*step);
% else
    startPos(1)= reldisplace(ESP,motors(1),-((xDim-1)/2)*step);
% end

% if mod(yDim,2) == 0
%     startPos(2)= reldisplace(ESP,motors(2),((yDim-1)/2)*step);
% else
    startPos(2)= reldisplace(ESP,motors(2),-((yDim-1)/2)*step);
% end
%% Reference matrices, to confirm correct orientation of field and motion
% In the end, the "Test(:,:,1)" should be a matrix of zeros

% RefMat1 = repmat([Start_Pos(1):step:Start_Pos(1)+PosMax(1)],[length(M1),1]);
% RefMat2 = repmat([Start_Pos(2):step:Start_Pos(2)+PosMax(2)]',[1,length(M2)]);

%% Pre allocate matrix for collection of results

global picoDevice
global enuminfo
global data
TRACENUM = 5;

testAcq = triggeredAcq(TRACENUM, picoDevice, data, enuminfo);

%% Set motor velocities
for ii=1:2
    v = setvelocity(ESP, motors(ii), vel(ii));
end

%% Scan Loop

for ii=1:yDim % Motor 2 Loop
    % pause(0.5);
    
    for jj=1:xDim % Motor 1 Loop
        % pause(0.5);
        
        if mod(ii,2)==0 % If i is even, moves motor to left
            
%             Test(ii,length(M1)-jj+1,1)=findposition(ESP,1)-RefMat1(ii,length(M1)-jj+1);
%             Test(ii,length(M1)-jj+1,2)=findposition(ESP,2)-RefMat2(ii,length(M1)-jj+1);
            waveform = triggeredAcq(TRACENUM, picoDevice, data, enuminfo);
            picoData.result{ii,xDim-jj+1} = waveform.buffer_a_mv;
            pause(0.5);
            
            if jj~=xDim % If not end of Motor 1 loop, move motor
                reldisplace(ESP,motors(1),-step); % Move Motor 1 to left
            end
            
        else % If i is odd, moves motor to right
%             Test(ii,jj,1)=findposition(ESP,1)-RefMat1(ii,jj);
%             Test(ii,jj,2)=findposition(ESP,2)-RefMat2(ii,jj);
            waveform = triggeredAcq(TRACENUM, picoDevice, data, enuminfo);
            picoData.result{ii,jj} = waveform.buffer_a_mv;
            pause(0.5);
            
            if jj~=xDim % If not end of Motor 1 loop, move motor
                reldisplace(ESP,motors(1),step);
                pause(0.1)% Move Motor 1 to right
            end
        end
        
    end
    
    if ii~=yDim % If not end of Motor 2 loop
        reldisplace(ESP,motors(2),step);
        pause(0.1)% Move Motor 2
    end
    
end

%% Send motors to 0 (not necessarily starting position)
for ii=1:2
    moveto(ESP,motors(ii),0)
end

picoData.t = waveform.t; % Time in ns
picoData.step = step;    % step in mm

%% Send motors to starting position (might be useful for 3D scan)
% for i=1:2
%     moveto(ESP,i,Start_Pos(i));
% end
