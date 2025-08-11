function [aee, alphaee] = acc_kinematics(q_traj, v_q, a_q, t, J)
% Calcola dell'accelerazione lineare e angolare dell'end-effector

N = size(q_traj,1);
dt = t(2) - t(1);

aee = zeros(1,N);   % accelerazione lineare
alphaee = zeros(1,N);   % accelerazione angolare

for i = 1:N   
    % Calcolo accelerazione usando la formula:
    % a = J*q_ddot + dJ/dt*q_dot
    % Stima numerica di dJ/dt (usando differenze finite centrale)
    if i > 1 && i < N
        % Stima della derivata: (J_next - J_prev) / (2*dt)
        J_dot = (J{1,i+1} - J{1,i-1})/(2*dt);
    elseif i == 1
        % differenza in avanti
        J_dot = (J{1,i+1} - J{1,i})/dt;
    elseif i == N
        % differenza indietro
        J_dot = (J{1,i} - J{1,i-1})/dt;
    end
    
    % Accelerazione lineare e angolare dell'end-effector
    aee(1,i)     = norm(J{1,i}(1:3,:)*a_q(i,:)' + J_dot(1:3,:)*v_q(i,:)');
    alphaee(1,i) = norm(J{1,i}(4:6,:)*a_q(i,:)' + J_dot(4:6,:)*v_q(i,:)');
end