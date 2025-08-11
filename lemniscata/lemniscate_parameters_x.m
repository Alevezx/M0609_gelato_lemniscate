function [a, h, d_x, d_y] = lemniscate_parameters_x(theta_x)

b2 = 0.411;
b4 = 0.368;

% Il vettore di posizione del robot è compreso tra b2-b4 e b2+b4
r = b2 - b4;
R = b2 + b4;

% Chiedere all'utente di inserie un valore di theta_y di lemniscata
while theta_x >= pi || theta_x <= -pi
    theta_x = input(['Inserire il valore di theta_x tra ' num2str(-pi) ' e ' num2str(pi) ' : ']);
end

% Chiedere all'utente di inserie un valore di scala di lemniscata
a = [];
while isempty(a)
    a_c = input(['Inserire il valore di scala, a, tra ' num2str(r) ' e ' num2str(R) ' : ']);
    if a_c <= r || a_c >= R
        fprintf('Inserire un valore di scala valido\n');
    else
        a = a_c;
    end
end

% Chiedere all'utente di inserie un valore di altezza di lemniscata
h = [];
max_z = (-a*abs(sin(theta_x)) + sqrt(4*(R^2 - (3/2)*a^2) + (a*sin(theta_x))^2))/2 - 0.1;
min_z = (a/2)*abs(sin(theta_x));
if min_z > max_z
    fprintf('Inserire un altro valore di theta_y oppure di scala\n');
    return;
end

while isempty(h)
    h_c = input(['Inserire il valore di altezza, h, tra ' num2str(min_z) ' e ' num2str(max_z) ' : ']);
    if h_c < min_z || h_c > sqrt(R^2 - a^2)
        fprintf('Inserire un valore di altezza valido\n');
    else
        h = h_c;
    end
end

% Chiedere all'utente di inserie un valore di traslazione lungo x di lemniscata
d_x = [];
delta = R^2 - h^2;
if delta >= 0
    max_x = max([-a+sqrt(delta), 0]) - 0.1;
    min_x = min(0, [a-sqrt(delta)]) + 0.1;
else
    max_x = 0 - 0.1;
    min_x = 0 + 0.1;
end

while isempty(d_x)    
    d_xc = input(['Inserire il valore di traslazione lungo x, d_x, tra ' num2str(min_x) ' e ' num2str(max_x) ' : ']);
    if d_xc < min_x || d_xc > max_x
        fprintf('Inserire un valore di traslazione lungo x valido\n');
    else
        d_x = d_xc;
    end
end

% Chiedere all'utente di inserie un valore di traslazione lungo y di lemniscata
d_y = [];
delta_max = (a*cos(theta_x))^2 - 4*((3/4)*a^2 - R^2 + d_x^2 + a*sqrt(2)*d_x + h^2 - a*h*sin(theta_x));
delta_min = (a*cos(theta_x))^2 - 4*((3/4)*a^2 - R^2 + d_x^2 + a*sqrt(2)*d_x + h^2 + a*h*sin(theta_x));
if delta_max >= 0
    max_y = max([(-a*cos(theta_x)+sqrt(delta_max))/2, 0]) - 0.1;
else
    max_y = 0 - 0.1;
end
if delta_min >= 0
    min_y = min([0, (a*cos(theta_x)-sqrt(delta_min))/2]) + 0.1;
else
    min_y = 0 + 0.1;
end
while isempty(d_y)
    d_yc = input(['Inserire il valore di traslazione lungo y, d_y, tra ' num2str(min_y) ' e ' num2str(max_y) ' : ']);
    if d_yc < min_y || d_yc > max_y
        fprintf('Inserire un valore di traslazione lungo y valido\n');
    else
        d_y = d_yc;
    end
end
