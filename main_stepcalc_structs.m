% Written by Heechul Yoon
% 01-26-2015
% Motor axis translation and rotation in 3D space
% Updated by Robin Hartman
% 02-09-2015

clc; clear all; close all;
%% Motor range [mm]
% -xLen to xLen, -yLen to yLen, -zLen to zLen
xLen = 40; % mm
yLen = 20; % mm
zLen = 60; % mm

%% Measured two sub-peak points [mm]
% should be in the motor range
p1.x = 5;
p1.y = -5;
p1.z = 10;

p2.x = 0;
p2.y = 0;
p2.z = 0;

%% Measurement range [mm]
% -xMLen to xMLen, -zMLen to zMLen
% should be less than motor range!
xMLen = 20; % mm
zMLen = 30; % mm

%% Options
dec = 1; % Decimation rate (should be posive integer, the larger the faster)

%% Set axial direction to motor
axdir.ax=3;
axdir.lat=1;
axdir.elev=2;

%% Run
[ latstep, elevstep, axstep ] = StepCalc_structs( p1, p2, axdir, xLen, yLen, zLen);
