function k_values = find_integer(kmin, kmax)

% Calcolo dei limiti per k
k_min = ceil(kmin);
k_max = floor(kmax);

% Generazione dei valori interi di k
k_values = k_min:k_max;