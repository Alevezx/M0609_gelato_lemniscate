% function that returns an elementary rotation matrix Ry(phi)
function Ry = rot_y(phi)

Ry = [cos(phi) 0 sin(phi); 0 1 0; -sin(phi) 0 cos(phi)];

end