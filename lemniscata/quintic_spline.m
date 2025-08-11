
function a = quintic_spline(q, dq, ddq, T)
    % a5*t^5 + a4*t^4 + a3*t^3 + a2*t^2 + a1*t + a0
    % 5*a5*t^4 + 4*a4*t^3 + 3*a3*t^2 + 2*a2*t + a1
    % 20*a5*t^3 + 12*a4*t^2 + 6*a3*t + 2*a2
    
    % parametri
    a = zeros(1, 6);
    
    % soluzione
    a(1) = q(1);
    a(2) = dq(1);
    a(3) = ddq(1) / 2;
    
    % Ax=b all'istante finale
    A = [T^5    T^4     T^3
         5*T^4  4*T^3   3*T^2
         20*T^3 12*T^2  6*T ];
    
    b = [q(2) - a(1) - a(2)*T - a(3)*T^2
         dq(2) - a(2) - 2*a(3)*T
         ddq(2) - 2*a(3)];
    
    coeff = A\b;
    a(6) = coeff(1);
    a(5) = coeff(2);
    a(4) = coeff(3);
end