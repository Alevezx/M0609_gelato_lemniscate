function vel = calcolo_vel(movimenti, tempi, coeff, pos)

OURrobot = Doosan_M0609;

% giunti
vel = [];
T = tempi{1}(end) - tempi{1}(1);
t = [];
for i = 1:length(movimenti)
    vel_c = [];
    for j = 1:6
        vel_c = [vel_c; coeff{i}(j,2) + 2*coeff{i}(j,3).*tempi{i} + 3*coeff{i}(j,4).*tempi{i}.^2 + 4*coeff{i}(j,5).*tempi{i}.^3 + 5*coeff{i}(j,6).*tempi{i}.^4];
    end
    vel = [vel, vel_c];
    t = [t, (movimenti(i) - 2)*T + tempi{i}];
end

% Costante per avere 2pi come tempo di traiettoria
k = 2*pi/t(end);

% end effector
[~, vee, wee] = diff_kinematics2(pos', vel', OURrobot, "endeff");

legenda = cell(1,6);
figure(Name="Velocità giunti")
hold on
for i = 1:6
    plot(t*k, vel(i,:));
    legenda{i} = sprintf('giunto %d', i);
end
hold off;
legend(legenda);
xlabel('t');
ylabel('velocità [rad/s]');

figure(Name="Velocità lineare end effector");
hold on
plot(t*k, vee);
hold off;
xlabel('t');
ylabel('velocità [m/s]');

figure(Name="Velocità angolare end effector");
hold on
plot(t*k, wee);
hold off;
xlabel('t');
ylabel('velocità [rad/s]');