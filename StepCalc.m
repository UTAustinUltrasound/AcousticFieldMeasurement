function [ ux, uy, uz ] = StepCalc( p1, p2, xMLen, zMLen, xLen, yLen, zLen, dec)
% Function to calculate steps in rotated field. Outputs are three 1 mm unit vectors
% that can be multiplied by the desired step size. A rotation vector and
% angle are calculated using the MATLAB function vrrotvec which produces a
% 4 element vector. The first three elements are the unit vector of
% rotation and the last element is the angle of rotation in radians. This
% is then used to rotate the x, y, and z axes into the new rotated space.
% The resulting z axis is the unit vector pointing from the origin (p2) to the
% calculated max (p1). 

%%  Error checking code from Heechul
fError = false;

if (xMLen > xLen) || (zMLen > zLen)
    errordlg('Measurement field out of range!!');
    fError = true;
end
if (p1.x<-xLen || p1.x>xLen) || (p1.y<-yLen || p1.y>yLen) || (p1.z<-zLen || p1.z>zLen)
    errordlg('Measured p1 is out of range!!');
    fError = true;
end
if (p2.x<-xLen || p2.x>xLen) || (p2.y<-yLen || p2.y>yLen) || (p2.z<-zLen || p2.z>zLen)
    errordlg('Measured p2 is out of range!!');
    fError = true;
end
if (p1.z < p2.z)
    errordlg('First point should be higher!!');
    fError = true;
end
if (rem(dec,1) ~= 0) || dec < 0
    errordlg('dec should be natural number!!');
    fError = true;
end


if ~fError
    %% Define the initial axes as unit vectors
    xax=[1; 0; 0;];
    yax=[0; 1; 0;];
    zax=[0; 0; 1;];

    %% Calculate rotated z axis
    dc.x = p1.x-p2.x;
    dc.y = p1.y-p2.y;
    dc.z = p1.z-p2.z;

    udc.x = dc.x / sqrt(dc.x.^2+dc.y.^2+dc.z.^2);
    udc.y = dc.y / sqrt(dc.x.^2+dc.y.^2+dc.z.^2);
    udc.z = dc.z / sqrt(dc.x.^2+dc.y.^2+dc.z.^2);

    uvect=[udc.x; udc.y; udc.z];

    %% Calculate axis and angle of rotation
    rotvec=vrrotvec(zax,uvect);

    ur.x=rotvec(1);
    ur.y=rotvec(2);
    ur.z=rotvec(3);
    theta=rotvec(4)*180/pi;

    %% Calculate rotation matrix
    Rot=[cosd(theta)+ur.x^2*(1-cosd(theta)), ur.x*ur.y*(1-cosd(theta))-ur.z*sind(theta), ur.x*ur.z*(1-cosd(theta))+ur.y*sind(theta);...
         ur.y*ur.x*(1-cosd(theta))+ur.z*sind(theta), cosd(theta)+ur.y^2*(1-cosd(theta)), ur.y*ur.z*(1-cosd(theta))-ur.y*sind(theta);...
         ur.z*ur.x*(1-cosd(theta))-ur.y*sind(theta), ur.z*ur.y*(1-cosd(theta))+ur.x*sind(theta), cosd(theta)+ur.z^2*(1-cosd(theta));];

    %% Apply rotation matrix to x and y axes (already have z)
    xnew=Rot*xax;
    ynew=Rot*yax;

    %% Calculate step unit vectors
    % One step in x direction
    ux.x=xnew(1);
    ux.y=xnew(2);
    ux.z=xnew(3);
    
    % One step in y direction
    uy.x=ynew(1);
    uy.y=ynew(2);
    uy.z=ynew(3);
    
    % One step in z direction is the initial unit vector
    uz=udc;
end
end
