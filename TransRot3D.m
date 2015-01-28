% Written by Heechul Yoon
% 01-26-2015
% Motor axis translation and rotation in 3D space

function [ Xnew, Ynew, Znew ] = TransRot3D( p1, p2, xMLen, zMLen, xLen, yLen, zLen, mRes, FIG, dec)

Xnew = []; Ynew = []; Znew = [];
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
    [x, y, z] = meshgrid(-xMLen:mRes:xMLen, 0, -zMLen:mRes:zMLen);
    [xNum, yNum, zNum] = size(x);
    posLen = xNum * yNum * zNum;
    Mm = [reshape(x,1,posLen); reshape(y,1,posLen); reshape(z,1,posLen)];

    if FIG
        scatter3(Mm(1,1:dec:end), Mm(2,1:dec:end), Mm(3,1:dec:end), mRes*5); hold on;
        xlabel('x axis (lateral direction)');
        ylabel('y axis (elavational direction)');
        zlabel('z axis (axial direction)');
        title('Axis motor space');
        axis([-xLen, xLen, -yLen, yLen, -zLen, zLen]);

        grid on;

    end

    dc.x = p1.x-p2.x;
    dc.y = p1.y-p2.y;
    dc.z = p1.z-p2.z;

    udc.x = dc.x / sqrt(dc.x.^2+dc.y.^2+dc.z.^2);
    udc.y = dc.y / sqrt(dc.x.^2+dc.y.^2+dc.z.^2);
    udc.z = dc.z / sqrt(dc.x.^2+dc.y.^2+dc.z.^2);

    theta_y = -sign(udc.x)*acosd(udc.z/sqrt(udc.x^2+udc.z^2));
    theta_x = asind(udc.y/sqrt(udc.z^2+udc.y^2));
    Ry = [cosd(theta_y) 0 -sind(theta_y); 0 1 0; sind(theta_y) 0 cosd(theta_y)];
    Rx = [1 0 0; 0 cosd(theta_x) sind(theta_x); 0 -sind(theta_x) cosd(theta_x)];
    T = zeros(size(Mm));
    T(1,:) = (p1.x+p2.x)/2; T(2,:) = (p1.y+p2.y)/2; T(3,:) = (p1.z+p2.z)/2;
    RxRyMm = Rx * Ry * Mm + T;

    RxRyMm = round(RxRyMm/mRes+eps*4)*mRes;

    Xnew = RxRyMm(1,:);
    Ynew = RxRyMm(2,:);
    Znew = RxRyMm(3,:);

    Ynew(Xnew<-xLen) = []; Znew(Xnew<-xLen) = []; Xnew(Xnew<-xLen) = []; 
    Ynew(Xnew>xLen) = []; Znew(Xnew>xLen) = []; Xnew(Xnew>xLen) = []; 

    Xnew(Ynew<-yLen) = []; Znew(Ynew<-yLen) = []; Ynew(Ynew<-yLen) = []; 
    Xnew(Ynew>yLen) = []; Znew(Ynew>yLen) = []; Ynew(Ynew>yLen) = []; 

    Xnew(Znew<-zLen) = []; Ynew(Znew<-zLen) = [];  Znew(Znew<-zLen) = [];
    Xnew(Znew>zLen) = []; Ynew(Znew>zLen) = [];  Znew(Znew>zLen) = [];

    if FIG
        scatter3(Xnew(1:dec:end), Ynew(1:dec:end), Znew(1:dec:end), mRes*10, 'g');
        scatter3(p1.x,p1.y,p1.z,200,'MarkerEdgeColor','r','MarkerFaceColor','r');
        scatter3(p2.x,p2.y,p2.z,200,'MarkerEdgeColor','r','MarkerFaceColor','r');
    end
end

end

