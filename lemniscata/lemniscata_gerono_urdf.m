% L'equazione di Lemniscata di Gerono
% x = cos(t), y = sin(t)*cos(t)
% Per ogni punto verrà calcolata la cinematica inversa, ricavando i valori
% dei giunti del robot
function q_traj = lemniscata_gerono_urdf(a, h, d_x, d_y, theta_x, theta_y, myrobot)
% theta_x angolo attorno x, theta_y angolo attorno , offset è traslazione
% rispetto all'origine

t = linspace(0, 2*pi, 20);
x = a*cos(t);
y = a*sin(t).*cos(t);
z = zeros(size(t));

% Definire la matrice  di rotazione di EE rispetto alla terna base
R =  [1 0 0
      0 -1 0
      0  0 1];  % L'asse z è ruotato di 90°

% Trasformare i punti usando le matrici di trasformazione
R_x = rot_transl(rot_x(theta_x), [0; 0; 0]);
R_y = rot_transl(rot_y(theta_y), [0; 0; 0]);

% Ricavare T0ee per ogni punto
T0ee = cell(1,length(t));
for i = 1:length(t)
    T0ee{1,i} = rot_transl(R, [x(i); y(i); z(i)]);
    T0ee{1,i} = R_x * R_y * T0ee{1,i};
    T0ee{1,i}(1:3,4) = T0ee{1,i}(1:3,4) + [d_x; d_y; h]; 
end

% Inizializzare i valori dei giunti precedenti
q_prec = [0; 0; 0; 0; 0; 0];

% Inizializzare i valori dei giunti
q_traj = [];

%modifico i limiti di giunto
for i = 1:10
    if strcmp(myrobot.Bodies{1,i}.Joint.Type, 'revolute')
        myrobot.Bodies{1,i}.Joint.PositionLimits = [-2*pi 2*pi];
    end
end

myrobot.DataFormat = 'row';

% costruisco la gik

gik = generalizedInverseKinematics("RigidBodyTree", myrobot);
gik.ConstraintInputs = {'position','cartesian','joint','pose'};
gik.SolverParameters.MaxIterations = 5000;
gik.SolverParameters.GradientTolerance = 1e-8;
gik.SolverParameters.SolutionTolerance = 1e-8;
gik.SolverParameters.AllowRandomRestart = false;
        
jointLim = constraintJointBounds(myrobot);
% jointLim.Weights = 0.1 * ones(1,6);

jointLim.Bounds(:, 1) = -2*pi * ones(1,6);
jointLim.Bounds(:, 2) = 2*pi * ones(1,6);

% imposta vincoli per il terzo giunto
jointLim.Bounds(3, 1) = -0.83*pi;
jointLim.Bounds(3, 2) = 0.83*pi;
% jointLim.Weights(3) = 1;
%  jointLim.Weights(2) = 0.5;

posConstraint(1) = constraintCartesianBounds('MODULE.1_Giunto_3_Test'); 
posConstraint(2) = constraintCartesianBounds('MODULE.1_FLANGE-END'); 

posConstraint(1).Bounds = [-inf, inf; -inf, inf; 0.08, inf]; % Z deve essere >= 0
posConstraint(2).Bounds = [-inf, inf; -inf, inf; 0.08, inf]; % Z deve essere >= 0

poseConst = constraintPoseTarget("MODULE.1_FLANGE-END");

%pesi dei giunti
weights = [1; 1; 1; 1; 1; 1]; 

% Inizializza con la configurazione di default
q_prec = myrobot.homeConfiguration; 

for i = 1:length(t)
    % Cinematica inversa
    T0ee{1,i};
    
    %imposto che l'end effector deve andare come indicato nella quarta
    %colonna
    posTgt = constraintPositionTarget('MODULE.1_FLANGE-END');
    posTgt.TargetPosition = T0ee{1,i}(1:3,4);
    
    % Richiamo dell'inverseKinematics con configurazione iniziale in formato struct
    qSol = gik(q_prec, posTgt, posConstraint, jointLim,poseConst );
    
    % Aggiorno la traiettoria
    q_traj = [q_traj, qSol'];

    % Aggiorno la configurazione precedente nel formato corretto
    q_prec = qSol; % qSol è già nel formato struct
end

q_traj

%chiamo la funzione che genera la struct
quintic_MW_urdf(myrobot, q_traj, theta_x, theta_y);