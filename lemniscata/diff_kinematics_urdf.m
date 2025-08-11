% Calcolo dello Jacobiano e stima della velocità dell' ee.
% q_traj deve essere una matrice in cui il numero di righe è il numero di
% punti della traiettoria, mentre il numero di colonne equivale ai giunti.
% Considera 6 giunti rotoidali

function [J,vee, wee] = diff_kinematics_urdf(q_traj, robot,t)

tmax = 5;
dt = tmax/(size(q_traj,2) - 1);
t = 0 : dt : tmax;

% stima velocità dei giunti
v_q = gradient(q_traj) ./ gradient(t);

% calcolo J per ogni configurazione della traiettoria data
J = num2cell(zeros(1,size(q_traj, 1)));
for i = 1 : size(q_traj, 2)
   J{1, i} = geometricJacobian(robot, q_traj(:,i)', robot.BodyNames{1, 6});
end

% velocità ee

v_ee = zeros(3, size(q_traj, 2)); % vettore velocità lineare dell' ee (3xn)
w_ee = zeros(3, size(q_traj, 2)); % vettore velocità angolare dell' ee (3xn)
vee = zeros(1, size(q_traj, 2));
wee = zeros(1, size(q_traj, 2));

size(J{1,2})
size(v_q)

for i = 1 : size(v_q, 2)
   v_ee(:, i) = J{1, i}(1:3, :) * v_q(:, i);
   w_ee(:, i) = J{1, i}(4:6, :) * v_q(:, i);
   vee(i) = norm(v_ee(:, i));
   wee(i) = norm(w_ee(:, i));
end

size(vee)
size(t)

figure('Name','Velocità lineare vee');
plot(t,vee);
figure('Name','Velocità angolare wee');
plot(t,wee);



end