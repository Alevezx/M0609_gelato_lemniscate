% eseguire prima test_animazione per ottenere i dati
% dati necessari (ottenibili tramite data_dump):
% - coefficienti dei polinomi quintici per tutti i giunti
% - asse dei tempi per calcolare posizioni e velocità dei giunti

%% inserire i dati richiesti

% coefficienti, matrice 6x6, ogni riga è un giunto, ogni colonna è un coeff
coeff = [    1.239731 0.000000 0.000000  11251.874061 -337556.221834   2700449.774674 
            -0.500079 0.000000 0.000000  17282.939357 -518488.180711   4147905.445690 
             2.578767 0.000000 0.000000 -17049.917387  511497.521600  -4091980.172796 
             2.219390 0.000000 0.000000  73776.219538 -2213286.586142  17706292.689137 
             0.032146 0.000000 0.000000  36780.904983 -1103427.149487  8827417.195894 
             2.160604 0.000000 0.000000 -62417.970717  1872539.121521 -14980312.972168  ];

% tempo
t = [0.000000 0.002000 0.004000 0.006000 0.008000 0.010000 0.012000 0.014000 0.016000 0.018000 0.020000 0.022000 0.024000 0.026000 0.028000 0.030000 0.032000 0.034000 0.036000 0.038000 0.040000 0.042000 0.044000 0.046000 0.048000 0.050000 ];

%% robot
OURrobot = importrobot('Doosan_Box_Def.urdf');
% sistema i vincoli
for i = 1:10
    if strcmp(OURrobot.Bodies{1,i}.Joint.Type, 'revolute')
        OURrobot.Bodies{1,i}.Joint.PositionLimits = [-2*pi 2*pi];
    end
end
OURrobot.Bodies{1,6}.Joint.PositionLimits = [-15/18*pi 15/18*pi];
OURrobot.Bodies{1,3}.Joint.PositionLimits = [-pi/2 pi/2];
OURrobot.DataFormat = 'row';

% file_ee = "end_effector.stl";
% ee = stlread(file_ee);
% socket_ee = rigidBody("end_effector");
% jntee = rigidBodyJoint('jntee', 'fixed');
% % calcola la trasformata del cono rispetto alla base
% p = [0 0 -0.05];
% phi = pi/2; theta = pi/2; psi = pi/2;
% R = eul2r(phi, theta, psi);
% T = rot_transl(R, p);
% setFixedTransform(jntee, T);
% socket_ee.Joint = jntee;
% 
% addVisual(socket_ee, "Mesh", file_ee);
% 
% addBody(OURrobot, socket_ee, 'MODULE.1_FLANGE-END');
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

% end effector
[J, vee, wee] = diff_kinematics2(pos', vel', OURrobot, "MODULE.1_FLANGE-END");

figure(Name="Velocità lineare end effector");
hold on
plot(t, vee);

figure(Name="Velocità angolare end effector");
hold on
plot(t, wee);

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

[aee, alphaee] = acc_kinematics(pos', vel', acc', t, J);

figure(Name="Accelerazione lineare end effector");
hold on
plot(t, aee);

figure(Name="Accelerazione angolare end effector");
hold on
plot(t, alphaee);