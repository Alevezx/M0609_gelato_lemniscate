function theta_out = check_singularity(theta_in, flag)

% Condizione di singolarità:
% q3 = pi/2 || -pi/2  
% q5 = 0 || pi || -pi
% intorno ai punti di singolarità
tol = 0.05;

% theta 3
if flag == 3
    % funzione anonima che riceve un vettore theta e restituisce solo
    % i valori non prossimi a ±pi/2
    filterFn = @(theta) theta( abs(theta - pi/2) > tol & ...
                               abs(theta + pi/2) > tol );

    % applica a tutte le celle
    theta_out = cellfun(filterFn, theta_in, 'UniformOutput', false);
end

% theta 5
if flag == 5
    % funzione anonima che riceve un vettore theta e restituisce solo
    % i valori non prossimi a 0 e ±pi
    filterFn = @(theta) theta( abs(theta - pi) > tol & ...
                               abs(theta + pi) > tol & abs(theta) > tol);

    % applica a tutte le celle
    theta_out = cellfun(filterFn, theta_in, 'UniformOutput', false);
end

end