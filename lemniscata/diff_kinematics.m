% Calcolo dello Jacobiano e stima della velocità dell' ee.
% q_traj deve essere una matrice in cui il numero di righe è il numero di
% punti della traiettoria, mentre il numero di colonne equivale ai giunti.
% Considera 6 giunti rotoidali

function [J,vee, wee] = diff_kinematics(q_traj, t, robot)

N = size(q_traj,1);

% stima velocità dei giunti
v_q = gradient(q_traj) ./ gradient(t');

% calcolo J per ogni configurazione della traiettoria data
J = cell(1,N);
for i = 1 : N
   J{1,i} = geometricJacobian(robot, q_traj(i,:), robot.BodyNames{1,6});
end

% velocità ee
vee = zeros(1,N);   % norma velocità lineare dell' ee (1xn)
wee = zeros(1,N);   % norma velocità angolare dell' ee (1xn)
for i = 1 : size(q_traj,1)
   vee(1,i) = norm(J{1,i}(1:3,:) * v_q(i,:)');
   wee(1,i) = norm(J{1,i}(4:6,:) * v_q(i,:)');
end

end