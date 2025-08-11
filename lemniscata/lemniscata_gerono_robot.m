% L'equazione di Lemniscata di Gerono
% x = cos(t), y = sin(t)*cos(t)
% In caso di inclinazioni rispetto all'asse x o y, bisogna fare rotazioni,
% quindi trasformazione dei punti
% Successivamente si passa a disegnare la traiettoria di lemniscata
% Scegliendo un intervallo da 0 a 2pi
% Per ogni punto verrà calcolata la cinematica inversa, ricavando i valori
% dei giunti del robot
function q_traj = lemniscata_gerono_robot (a, h, d_x, d_y, theta_x, theta_y)
% theta_x angolo attorno x, theta_y angolo attorno y

b2 = 0.411;
b4 = 0.368;
t = linspace(0, 2*pi, 20);
x = a*cos(t);
y = a*sin(t).*cos(t);
z = zeros(size(t));

% Definire la matrice  di rotazione di ee rispetto alla terna base
R =  [1 0 0
      0 -1 0
      0  0 -1];  % L'asse z è ruotato di 90°

% Trasformare i punti usando le matrici di trasformazione
R_x = rot_transl(rot_x(theta_x), [0; 0; 0]);
R_y = rot_transl(rot_y(theta_y), [0; 0; 0]);
x_rot = [];
y_rot = [];
z_rot = [];
% Ricavare T0ee per ogni punto e verificare che la norma della posizione 
% della lemniscata non supera il range del modulo della posizione del robot
T0ee = cell(1,length(t));
for i = 1:length(t)
    T0ee{1,i} = rot_transl(R, [x(i); y(i); z(i)]);
    T0ee{1,i} = R_x * R_y * T0ee{1,i};
    T0ee{1,i}(1:3,4) = T0ee{1,i}(1:3,4) + [d_x; d_y; h];
    Pe = T0ee{1,i}(1:3,4);
    x_rot = [x_rot, T0ee{1,i}(1,4)];
    y_rot = [y_rot, T0ee{1,i}(2,4)];
    z_rot = [z_rot, T0ee{1,i}(3,4)];
    if Pe(3) < 0 
        fprintf('La lemniscata si trova sotto il piano\n');
        return;
    end
end

figure('Name', 'Lemniscata di Gerono', 'NumberTitle', 'off', 'Color', [1, 1, 1]);
plot3(x_rot, y_rot, z_rot);
axis equal;
grid on;
xlabel('X');
ylabel('Y');
zlabel('Z');
title('Lemniscata di Gerono con Traslazioni e Rotazioni');
hold off;

% Inizializzare i valori dei giunti precedenti
q_prec = [0; 0; 0; 0; 0; 0];

% Inizializzare i valori dei giunti
OURrobot = Doosan_M0609;
% Scelgo la configurazione migliore di partenza che mi dà la traiettoria migliore
q_start = best_configuration(T0ee{1,1}, q_prec, 1);
q_prec = q_start(:,1);
q_traj = q_prec;
restart = true;
flag_start = 0; % Tiene traccia se scegliere un'altra configurazione di partenza
j = 2;  % La prossima configurazione di partenza in caso di traiettoria non ottimale

while restart
    restart = false;
    % Determinare se cambiare la configurazione di partenza
    if flag_start == 1
        if j <= size(q_start,2)
            q_prec = q_start(:,j);
            q_traj = q_prec;   
            j = j + 1; 
            flag_start = 0;
        else
            disp("Traiettoria ottima non trovata");
            return;
        end
    end
    
    % Un ciclo che ricava i valori dei giunti per ogni punto di lemniscata
    for i=2:length(t)
        % Funzione della cinematica inversa
        i
        T0ee{1,i};
        q_traj_c = best_configuration(T0ee{1,i}, q_prec, 0);
        if isempty(q_traj_c)
            fprintf('I valori della matrice non danno nessuna configurazione\n');
            break;
        end
        % Determinare se ci sono alti di angoli dei giunti
        % dobbiamo valutare tutta la traiettoria, se ci sono dei salti ricalcolo
        % una nuova configurazione di partenza
        if jump_det(q_prec, q_traj_c) == 1     %% NON SO SE é giusto
            restart = true;         % se la nuova q_traj_c è troppo diversa da quella prima, ricomincia
            flag_start = 1;         % flag per rifare il calcolo con una nuova T0ee_start
            q_traj = [];            % Cancello le configurazioni precedenti
            break;
        else
        q_traj = [q_traj, q_traj_c];
        q_prec = q_traj(:, i);    
        end
    end
end

% Proiezione del robot
q_traj = q_traj';
quintic_MW_robot(OURrobot, q_traj);

[movimenti, tempi, coeff] = read_data_dump("data_coeff.txt");

pos = calcolo_pos(movimenti, tempi, coeff);
vel = calcolo_vel(movimenti, tempi, coeff, pos);
calcolo_acc(movimenti, tempi, coeff, pos, vel);

end