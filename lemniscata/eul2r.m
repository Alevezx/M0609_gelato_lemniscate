% Function that keeps as input 3 angular values and gives as output the
% rotation matrix - EULER angles ZYZ
function R = eul2r(phi, theta, psi)

R = rot_z(phi)*rot_y(theta)*rot_z(psi);

end