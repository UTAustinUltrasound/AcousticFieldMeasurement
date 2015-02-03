function [ Test] = scan2D( ESP, vel, PosMax, steps )
%The purpose of this function is to implement a 2D raster scan using
%Newport motors
%   The scan should move to the right, down 1, to the left, down 1, to the
%   right, down 1, etc
%   PosMax is a vector of length 2. PosMax(1) corresponds to the maximum
%   distance to be traveled by Motor 1. 
%   vel is a vector of length 2. vel(1) corresponds to the velocity of
%   motor 1 (should you choose to set different velocities for the two motors.
% Robin Hartman Jan 2015
% Last Edit: Andrew Fowler, Feb 2015

M1=[0:steps:PosMax(1)]; %Matrix with number of steps that Motor 2 will take
M2=[0:steps:PosMax(2)]; %Matrix with number of steps that Motor 2 will take

Start_Pos=[findposition(ESP,1),findposition(ESP,2)];
%% Reference matrices, to confirm correct orientation of field and motion
% In the end, the "Test(:,:,1)" should be a matrix of zeros
RefMat1=repmat([Start_Pos(1):steps:Start_Pos(1)+PosMax(1)],[length(M1),1]);
RefMat2=repmat([Start_Pos(2):steps:Start_Pos(2)+PosMax(2)]',[1,length(M2)]);


%% Set motor velocities
for motor=1:2
v=setvelocity(ESP,motor,vel(motor));
end

%% Scan Loop
for i=1:length(M2) % Motor 2 Loop
    pause(0.5);
    for j=1:length(M1) % Motor 1 Loop
        pause(0.5);
        if mod(i,2)==0 % If i is even, moves motor to left
            Test(i,length(M1)-j+1,1)=findposition(ESP,1)-RefMat1(i,length(M1)-j+1);
            Test(i,length(M1)-j+1,2)=findposition(ESP,2)-RefMat2(i,length(M1)-j+1);
            if j~=length(M1) % If not end of Motor 1 loop, move motor
            reldisplace(ESP,1,-steps); % Move Motor 1 to left
            end
        else % If i is odd, moves motor to right
            Test(i,j,1)=findposition(ESP,1)-RefMat1(i,j);
            Test(i,j,2)=findposition(ESP,2)-RefMat2(i,j);
            if j~=length(M1) % If not end of Motor 1 loop, move motor
            reldisplace(ESP,1,steps); % Move Motor 1 to right
            end
        end
        j=j+1;
    end
if i~=length(M2) % If not end of Motor 2 loop
reldisplace(ESP,2,steps); % Move Motor 2
end
i=i+1;
end

%% Send motors to 0 (not necessarily starting position)
for i=1:2
    moveto(ESP,i,0)
end

%% Send motors to starting position (might be useful for 3D scan)
% for i=1:2
%     moveto(ESP,i,Start_Pos(i));
% end
