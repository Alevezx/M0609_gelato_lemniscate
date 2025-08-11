% function that returns an elementary rotation matrix Rx(theta)
function Rx = rot_x(theta_x)

Rx = [1 0 0; 0 cos(theta_x) -sin(theta_x); 0 sin(theta_x) cos(theta_x)];

end