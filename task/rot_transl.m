% Transformation matrix that represents a roto-translation.
% Inputs are: matrix R and vector p
% Output: T homogeneous transformation matrix
function T = rot_transl(R, p)
    
    T = [R      p(:)
         0 0 0  1   ];
end
