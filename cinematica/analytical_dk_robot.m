function [A, T0ee] = analytical_dk_robot()

% Robot parameters

% lunghezze dei lati per origine i a i+1, lungo la direzione relativa all'origine i
l12_z = 0.1777;
l12_y = 0.411;
l23_z = -0.1715;
l34_z = 0.368;
d6_ee = 0.06;   % end effector

% Definizione delle variabili simboliche
%syms theta1 theta2 theta3 theta4 theta5
syms q [6 1]

% Tabella di Denavit-Hartenberg
% a alpha d theta
DH_table = [0     -pi/2   0      q(1)
            l12_y   0    l12_z   q(2)
            0      pi/2  l23_z   q(3)
            0     -pi/2  l34_z   q(4)
            0      pi/2   0      q(5)
            0      0      d6_ee  q(6)];     

% Calcolo della posa dell'End-Effector - forma simbolica
T0ee = eye(4);
A = {};
for i=1:size(DH_table,1)
    a_i=DH_table(i,1);
    d_i=DH_table(i,3);
    al_i=DH_table(i,2);
    th_i=DH_table(i,4);
    %DH2A
    A_im1_i=[cos(th_i)      -sin(th_i)*cos(al_i)    sin(th_i)*sin(al_i)     a_i*cos(th_i)
             sin(th_i)      cos(th_i)*cos(al_i)     -cos(th_i)*sin(al_i)    a_i*sin(th_i)
                0                sin(al_i)               cos(al_i)               d_i
                0                    0                       0                    1];
    A_im1_i = simplify(A_im1_i);
    A{end+1} = A_im1_i;
    T0ee = simplify(T0ee*A_im1_i);
end

end