% prende una matrice di punti nx3 e una matrice di orientazioni nx3
% restituisce un cell array di n matrici di rototraslazione

function T = rot_transl_multiple(orien, pos)
    T = cell(size(pos, 1), 1);
    for i = 1:size(pos, 1)
        R = eul2r(orien(i, 1), orien(i, 2), orien(i, 3));
        T0ee = rot_transl(R, pos(i,:));
        T(i) = {T0ee};
    end
end