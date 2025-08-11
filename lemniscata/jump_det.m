% questa funzione identifica i salti tra una configurazione q_precedente e
% quella corrente
% Ritorna 1 se ha identificato un salto

function flag = jump_det(q_curr, q_prec)
limit = deg2rad(100);  % limite sulla differenza tra angoli di configurazioni differenti

flag = 0;
for i = 1 : length(q_curr)
    if abs(q_curr(i) - q_prec(i)) > limit
        flag = 1;
    end
end