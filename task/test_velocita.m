% eseguire prima test_animazione per ottenere i dati
% dati necessari (ottenibili tramite data_dump):
% - configurazioni dei giunti per una traiettoria
% - coefficienti dei polinomi quintici per tutti i giunti
% - asse dei tempi per il grafico

%% inserire i dati richiesti

% coefficienti, matrice 6x6, ogni riga è un giunto, ogni colonna è un coeff
coeff = [   1.3050         0         0   -2.5133    3.2607   -1.1281
            0.5265         0         0    1.3054   -1.6936    0.5859
           -1.6033         0         0    5.8755   -7.6228    2.6373
           -1.7142         0         0    1.6531   -2.1448    0.7420
            1.3462         0         0   -2.7265    3.5373   -1.2238
            2.1460         0         0   -4.9179    6.3804   -2.2074 ];

% tempo
t = 0:.001:1.15;

%% robot
OURrobot = importrobot("Doosan_Scatola_Girata.urdf");
% sistema i vincoli
for i = 1:10
    if strcmp(OURrobot.Bodies{1,i}.Joint.Type, 'revolute')
        OURrobot.Bodies{1,i}.Joint.PositionLimits = [-2*pi 2*pi];
    end
end
OURrobot.Bodies{1,6}.Joint.PositionLimits = [-15/18*pi 15/18*pi];
OURrobot.Bodies{1,3}.Joint.PositionLimits = [-pi/2 pi/2];
OURrobot.DataFormat = 'row';
file_ee = "end_effector.stl";
ee = stlread(file_ee);

socket_ee = rigidBody("end_effector");
jntee = rigidBodyJoint('jntee', 'fixed');
% calcola la trasformata del cono rispetto alla base
p = [0 0 -0.05];
phi = pi/2; theta = pi/2; psi = pi/2;
R = eul2r(phi, theta, psi);
T = rot_transl(R, p);
setFixedTransform(jntee, T);
socket_ee.Joint = jntee;

addVisual(socket_ee, "Mesh", file_ee);

addBody(OURrobot, socket_ee, 'MODULE.1_FLANGE-END');

%% calcolo posizioni

pos = [];
for i = 1:6
    pos = [pos; coeff(i,1) + coeff(i,2).*t + coeff(i,3).*t.^2 + coeff(i,4).*t.^3 + coeff(i,5).*t.^4 + coeff(i,6).*t.^5];
end

figure(Name="Angoli giunti");
hold on
for i = 1:6
    plot(t, pos(i,:));
end
xlabel('t');
ylabel('angoli [rad]');

%% calcolo velocità

% giunti
vel = [];
for i = 1:6
    vel = [vel; coeff(i,2) + 2*coeff(i,3).*t + 3*coeff(i,4).*t.^2 + 4*coeff(i,5).*t.^3 + 5*coeff(i,6).*t.^4];
end

figure(Name="Velocità giunti")
hold on
for i = 1:6
    plot(t, vel(i,:));
end
xlabel('t');
ylabel('velocità [rad/s]');

% end effector
[J, vee, wee] = diff_kinematics2(pos', vel', OURrobot, "end_effector");

figure(Name="Velocità lineare end effector");
hold on
plot(t, vee);
xlabel('t');
ylabel('velocità [m/s]');

figure(Name="Velocità angolare end effector");
hold on
plot(t, wee);
xlabel('t');
ylabel('velocità [rad/s]');

%% accelerazioni 

% giunti
acc = [];
for i = 1:6
    acc = [acc; 2*coeff(i,3) + 6*coeff(i,4).*t + 12*coeff(i,5).*t.^2 + 20*coeff(i,6).*t.^3];
end

figure(Name="Accelerazioni giunti")
hold on
for i = 1:6
    plot(t, acc(i,:));
end
xlabel('t');
ylabel('accelerazione [rad/s^2]');

[aee, alphaee] = acc_kinematics(pos', vel', acc', t, J);

figure(Name="Accelerazione lineare end effector");
hold on
plot(t, aee);
xlabel('t');
ylabel('accelerazione [m/s^2]');

figure(Name="Accelerazione angolare end effector");
hold on
plot(t, alphaee);
xlabel('t');
ylabel('accelerazione [rad/s^2]');