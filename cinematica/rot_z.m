% function that returns an elementary rotation matrix Rz(psi)
function Rz = rot_z(psi)

Rz = [cos(psi) -sin(psi) 0; sin(psi) cos(psi) 0; 0 0 1];

end