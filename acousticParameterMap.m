function apm = acousticParameterMap(picoData)
% This function interprets the data that is outputted by the
% acousticField2D function.  This reads the cell, extracts a mean value for
% max and min, and plots them in space.

%% Extract data dimensions and pre-allocate
[xDim, yDim] = size(picoData.result);

% For debug...
% len = length(picoData.t);
% sampleData = picoData.result{1,1};
% numTraces = length(sampleData(1,:));

% pre-allocation
apm.max = zeros(xDim,yDim);
apm.min = zeros(xDim,yDim);

apm.step = picoData.step;

%% extract mean max and min
for ii = 1:xDim
    for jj = 1:yDim
        currMax = mean(max(picoData.result{ii,jj}));
        currMin = mean(min(picoData.result{ii,jj}));
        apm.max(ii,jj) = currMax;
        apm.min(ii,jj) = currMin;
    end
end
