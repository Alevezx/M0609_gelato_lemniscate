function q_traj = best_configuration(T0ee_c, q_prec, flag_start)

% Chiamata della funzione che calcola le matrici A
[A, ~] = analytical_dk_robot();

% Calcolo di tutte le configurazioni possibili
q_conf = analytical_ik(A, T0ee_c);
if isempty(q_conf)
    fprintf('Non esiste nessuna configurazione per le coordinate inserite\n');
    q_traj = [];
    return;
end

% Se è la prima configurazione restituisco tutte le soluzioni, lasciato
% all'utente su come gestirli
if flag_start == 1
    q_traj = q_conf;
    return
end

tol = 1e-6; % tolleranza per confrontare le norme
min_norm = inf;
selected_indices = [];

% Calcolo della norma della differenza per ciascuna configurazione
for i = 1:size(q_conf,2)
    diff = q_conf(:,i) - q_prec(:);
    norm_diff = norm(diff);
    if norm_diff < min_norm - tol
         min_norm = norm_diff;
         selected_indices = i; % nuovo candidato
    elseif abs(norm_diff - min_norm) <= tol
         selected_indices = [selected_indices, i]; % aggiungo al tie-breaker
    end
end

% Se c'è un solo candidato, lo scelgo
if numel(selected_indices) == 1
    q_traj = q_conf(:, selected_indices(1));
else
    % Se ci sono più candidati con norma uguale, uso il tie-breaker gerarchico
    % confrontando i giunti uno per uno (dalla prima colonna alla sesta)
    selected_index = selected_indices(1);
    best_diff = abs(q_conf(:,selected_index) - q_prec(:));
    
    for idx = selected_indices(2:end)
        current_diff = abs(q_conf(:,idx) - q_prec(:));
        % Confronta giunto per giunto
        for joint = 1:6
            if abs(current_diff(joint) - best_diff(joint)) > tol
                if current_diff(joint) < best_diff(joint)
                    selected_index = idx;
                    best_diff = current_diff;
                end
                break; % interrompi il ciclo non appena trovi una differenza
            end
        end
    end
    q_traj = q_conf(:, selected_index);
end

end
