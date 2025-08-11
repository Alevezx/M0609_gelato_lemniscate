function res = analytical_ik(A, T0ee)

syms q [6 1];

b2 = 0.411;
b4 = 0.368;
b3 = 0.0062;
d6_ee = 0.06;

T0ee_fixed = T0ee;   % quella originale di ingresso
% Riportare l'ee al polso sferico
T0ee(1:3,4) = double(double(T0ee(1:3,4) - d6_ee*T0ee(1:3,3)));
Pw = double(T0ee(1:3,4));    % vettore posizione del polso sferico

%Risoluzione q2 analitica                       
Pw_mod = double(norm(Pw));
if abs((Pw_mod^2 + b2^2 - b4^2)/(2*Pw_mod*b2)) <= 1 && abs(Pw(3)/Pw_mod) <= 1
    alpha1 = double(acos((Pw_mod^2 + b2^2 - b4^2) / (2*Pw_mod*b2)));
    alphas = double(asin(Pw(3) / Pw_mod));
else
    fprintf('I valori della posizione di ee non soddisfano i vincoli di theta_2\n');
    res = [];
    return;
end
theta_2_c = - double([alphas + alpha1, alphas - alpha1, pi - alphas + alpha1, pi - alphas - alpha1]);
theta_2_c = double(check_boundaries(theta_2_c,2));
theta_2 = [];
for i = 1:length(theta_2_c)
    if theta_2_c(i) <= 0 && theta_2_c(i) >= -pi
        theta_2 = [theta_2, theta_2_c(i)];     % theta2 compreso tra 0 e -pi
    end
end
theta_2;

% Risoluzione q3 analitica
theta_3 = cell(1,length(theta_2));

for i = 1:length(theta_2)
    c23 = double((Pw(3)+b2*sin(theta_2(i)))/b4);

    % Aggiungi controllo su c23
    if double(abs(c23)) <= 1
        u = double(acos(c23) - theta_2(i));
        k_values = find_integer((-pi-u)/(2*pi), (pi-u)/(2*pi));

        if double(u+2*pi*k_values) <= 5*pi/6 && double(u+2*pi*k_values) >= -5*pi/6
            theta_3{1,i} = [theta_3{1,i}, double(u+2*pi*k_values)];
        end

        u = double(-acos(c23) - theta_2(i));
        k_values = find_integer((-pi-u)/(2*pi), (pi-u)/(2*pi));

        if (u+2*pi*k_values) <= 5*pi/6 && (u+2*pi*k_values) >= -5*pi/6
            theta_3{1,i} = [theta_3{1,i}, double(u+2*pi*k_values)];
        end
    end 
end 
% Controllo della singolarità
theta_3 = check_singularity(theta_3,3);

% Risoluzione q1 analitica
theta_1 = cell(1,2,length(theta_2));

for i=1:length(theta_2)
    for j = 1:length(theta_3{1,i})
        % Sistema di due equzioni, T06(1,4) = Pwx e T06(2,4) = Pwy, con
        % incognite cos(theta_1) e sin(theta_1)
        K = b2*cos(theta_2(i)) + b4*(cos(theta_2(i))*sin(theta_3{1,i}(j))...
            + sin(theta_2(i))*cos(theta_3{1,i}(j)));
        c1 = (K*Pw(1) + b3*Pw(2))/(K^2 + b3^2);
        s1 = (K*Pw(2) - b3*Pw(1))/(K^2 + b3^2);
        theta_1{1,j,i} = atan2(s1,c1);
    end
end
theta_1;

% Risoluzione cinematica analitica inversa del polso sferico
% Calcola di R36
R0ee = T0ee(1:3, 1:3);
A03 = A{1,1}*A{1,2}*A{1,3};
R03 = A03(1:3,1:3);
% R36 = cell(1,4,2,4);
% 
% for i=1:length(theta_2)
%     for j=1:length(theta_3{1,i})
%         for k=1:length(theta_1{1,j,i})
%             R36{1,k,j,i} = double(inv(eval(subs(R03, [q1, q2, q3], [theta_1{1,j,i}(k) theta_2(i) theta_3{1,i}(j)])))*R0ee);
%         end
%     end
% end

% Caso limite giunti tra pi e -pi
% q4 q5 q6
theta_4 = cell(1,1,2,length(theta_2));
theta_5 = cell(1,1,2,length(theta_2));
theta_6 = cell(1,1,2,length(theta_2));

for i = 1:length(theta_2)
    for j = 1:length(theta_3{1,i})
        for k = 1:length(theta_1{1,j,i})
            R30 = double(inv(eval(subs(R03, [q1, q2, q3], [theta_1{1,j,i}(k) theta_2(i) theta_3{1,i}(j)]))));
            R36 = double(R30*R0ee);
            % Prima colonna è soluzione per theta5 compreso tra (0,pi)
            % Seconda colonna è la soluzione per theta5 compreso tra
            % (-pi,0)
            theta_5{1,k,j,i} = [atan2(sqrt(R36(1,3)^2 + R36(2,3)^2), R36(3,3)), -atan2(sqrt(R36(1,3)^2 + R36(2,3)^2), R36(3,3))];
            theta_4{1,k,j,i} = [atan2(R36(2,3), R36(1,3)), atan2(-R36(2,3), -R36(1,3))];
            theta_6{1,k,j,i} = [atan2(R36(3,2), -R36(3,1)), atan2(-R36(3,2), R36(3,1))];
        end
    end
end
% Controllo della singolarità
theta_5 = check_singularity(theta_5,5);


% Rappresentazione di tutte le soluzioni
res = [];   % Per ogni colonna inserico la combinazione dei giunti

for i = 1:length(theta_2)
    for j = 1:length(theta_3{1,i})
        for k = 1:length(theta_1{1,j,i})
            for n = 1:length(theta_5{1,k,j,i})
                q_c = [theta_1{1,j,i}(k); theta_2(i); theta_3{1,i}(j); ...
                               theta_4{1,k,j,i}(n); theta_5{1,k,j,i}(n); theta_6{1,k,j,i}(n)];
                res = [res, q_c];
            end
        end
    end
end

res = unique(res', 'rows', 'stable')'; % elimina le ripetizioni

% Confrontare i valori della posizione dell'ee con tutte le configurazioni
% Confrontare i valori della matrice di rotazione con tutte le
% configurazioni

%T0ee_c = A{1,1}*A{1,2}*A{1,3}*A{1,4}*A{1,5}*A{1,6};
%P_0ee = T0ee_c(1:3,4);
%R0ee_c = T0ee_c(1:3,1:3);
%config = [];

%for i = 1:size(res,2)
%    P_c = double(eval(subs(P_0ee, [q1, q2, q3, q4, q5, q6], (res(:,i))')));
%    Pc_mod = double(norm(P_c));
%    d_conf = double(abs(P_c/Pc_mod - Pe/Pe_mod));
%    R_conf = double(abs(eval(subs(R0ee_c, [q1, q2, q3, q4, q5, q6], (res(:,i))')) - R0ee));
%    if norm(R_conf, 'fro') <= 0.05 && norm(d_conf) <= 0.05 %% PROBLEMA
%        config = [config, res(:,i)];
%    end
%end

%% NUOVO
% calcolare T0ee in forma parametrica
[~, T0ee_par] = analytical_dk_robot();
P0ee_par = T0ee_par(1:3,4);
R0ee_par = T0ee_par(1:3,1:3);

Pe = T0ee_fixed(1:3,4);
config = [];

for i = 1:size(res,2)
    P_c = double(eval(subs(P0ee_par, [q1, q2, q3, q4, q5, q6], (res(:,i))')));
    d_conf = double(abs(P_c - Pe));
    R_conf = double(abs(eval(subs(R0ee_par, [q1, q2, q3, q4, q5, q6], (res(:,i))')) - R0ee));
    if norm(R_conf, 'fro') <= 0.05 && norm(d_conf) <= 0.01
        config = [config, res(:,i)];
    end
end

%%

% Esplicitare la/e configurazione/i correta/e
% config = [];
% for i = 1:size(d_conf,2)
%     if norm(R_conf{1,i}, 'fro') <= 0.1 && norm(d_conf(:,i)) <= 0.1
%         config = [config, res(:,i)];
%     end
% end
res = unique(config', 'rows', 'stable')';
end