% Acoustic Measurement prototype script
% 
% Due to an idiosyncracy of the picoscope, the path is declared before
% clearing the workspace to make sure that the path to the disconnect
% function of the scope is available.  This is to avoid the brain meltingly
% frustrating situation in which the picoDevice has been cleared from the
% workspace, but not properly disconnected, freezing the picoscope and
% forcing a system restart.
%
% Andrew Fowler, Robin Hartman, UT Austin Feb 2015

%% Set path
% Note that this script must be launched while the current working
% directory is  '..\AcousticFieldMeasurement'

restoredefaultpath

% This is the path to the Picoscope drivers that Kristina installed.  It is
% the only version of the drivers that I (Andrew) got to work.  Change at
% your own peril.
addpath \Users\HIFU\Documents\MATLAB\PS3000asdk_r10_5_0_32\
addpath \Users\HIFU\Documents\MATLAB\PS3000asdk_r10_5_0_32\MATLAB\
addpath \Users\HIFU\Documents\MATLAB\PS3000asdk_r10_5_0_32\MATLAB\Functions\
addpath \Users\HIFU\Documents\MATLAB\PS3000asdk_r10_5_0_32\MATLAB\ps3000a\

% These are the paths to the functions for the various pieces of equipment
repoDir = {'\AcousticFieldMeasurement',...
    '\esp301',...
    '\AgilentGen',...
    '\Picoscope'};

% This is where the files are located for Andrew's profile, change this if
% you need to.
try
    cd('C:\Users\raf2599\Documents\GitHub\AcousticFieldMeasurement');
end

cd ..
baseDir = pwd;

for ii = 1:length(repoDir)
    addpath([baseDir repoDir{ii}]);
end

%% Prepare workspace

try
    stop_status = picoDisconnect(picoDevice);
catch
    msgbox('Either no device is connected or you are in a world of pain...')
end

clear all
close all
clc

%% Connect Motors
comPort = 'COM3';
esp301 = espConnect(comPort);

msgbox('Make sure that you power on your motors on the ESP controller!')
pause

%% Find maximum

msgbox('Use ESP controls to find the acoustic maximum.')

pause

motors = 1:3;
setzero(esp301, motors)

%% Connect Picoscope
PicoStatus

global picoDevice
global enuminfo
global data

[picoDevice, data] = picoConnect;

% number of traces to be taken at each point of acquisition.  This can be 
% changed as needed as long as you don't surpass the buffer limit.
TRACENUM = 5;

% This pulls all the constants from the PS3406B into the matlab workspace.
% Not all variables are used in all functions, but start here if certain
% values cannot be found.
deviceInfo = struct('methodinfo',[], 'structs',[], 'enuminfo',[], 'ThunkLibName',[]);
[deviceInfo.methodinfo, ...
    deviceInfo.structs, ...
    deviceInfo.enuminfo,...
    deviceInfo.ThunkLibName] = PS3000aMFile;

enuminfo = deviceInfo.enuminfo;



%% Acquire Field - prototype

% params for test scan
vel = [10 10];
width = [2.0 2.0];
step = 0.5;
motors = [1,2];

% The picoData variable is a 2D cell which contains 2D matrices with the
% dimensions LENGTH(TRACE) * NUMTRACES
picoData = acousticField2D(esp301, motors, vel, width, step);

% [Test] = scan2D(esp301, vel, PosMax, step);
