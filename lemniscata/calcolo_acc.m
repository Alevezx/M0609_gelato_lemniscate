function acc = calcolo_acc(movimenti, tempi, coeff, pos, vel)

OURrobot = Doosan_M0609;

% giunti
acc = [];
T = tempi{1}(end) - tempi{1}(1);
t = [];
for i = 1:length(movimenti)
    acc_c = [];
    for j = 1:6
        acc_c = [acc_c; 2*coeff{i}(j,3) + 6*coeff{i}(j,4).*tempi{i} + 12*coeff{i}(j,5).*tempi{i}.^2 + 20*coeff{i}(j,6).*tempi{i}.^3];
    end
    acc = [acc, acc_c];
    t = [t, (movimenti(i) - 2)*T + tempi{i}];
end

k = 2*pi/t(end);

legenda = cell(1,6);
figure(Name="Accelerazioni giunti")
hold on
for i = 1:6
    plot(t*k, acc(i,:));
    legenda{i} = sprintf('giunto %d', i);
end
hold off;
legend(legenda);
xlabel('t');
ylabel('accelerazione [rad/s^2]');

[J, ~, ~] = diff_kinematics2(pos', vel', OURrobot, "endeff");
[aee, alphaee] = acc_kinematics(pos', vel', acc', t, J);

figure(Name="Accelerazione lineare end effector");
hold on
plot(t*k, aee);
hold off;
xlabel('t');
ylabel('accelerazione [m/s^2]');

figure(Name="Accelerazione angolare end effector");
hold on
plot(t*k, alphaee);
hold off;
xlabel('t');
ylabel('accelerazione [rad/s^2]');