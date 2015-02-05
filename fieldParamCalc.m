function fieldParameters = fieldParamCalc(freq)
% INPROGRESS This function calculates the parameters for an acoustic field
% measurement.  This makes sure that the resolution of the motors is close
% enough that no information is missing.  Note that freq is in Hz.
%
% Andrew Fowler UT Austin Feb 2015

c = 1497;       % Speed of sound in mm/s
wl = c/freq;    % wavelength in mm.

fieldParameters.step = wl/4; % Lambda / 4 step for wavelength