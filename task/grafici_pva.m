
function grafici_pva(t, coeff)
    figure (Name="Posizioni nello spazio dei giunti");
    hold on
    legend
    for i = 1 : size(coeff,1) % 6 righe, una per giunto
        name = "Giunto " + i;
        pos = coeff(i,1) + coeff(i,2).*t + coeff(i,3).*t.^2 + coeff(i,4).*t.^3 + coeff(i,5).*t.^4 + coeff(i,6).*t.^5;
        plot (t, pos, DisplayName=name);
    end

    figure (Name="Velocità dei giunti")
    hold on
    legend
    for i = 1 : size(coeff,1) % 6 righe, una per giunto
        name = "Giunto " + i;
        vel = coeff(i,2) + 2*coeff(i,3).*t + 3*coeff(i,4).*t.^2 + 4*coeff(i,5).*t.^3 + 5*coeff(i,6).*t.^4;
        plot (t, vel, DisplayName=name);
    end

    figure (Name="Accelerazioni dei giunti")
    hold on
    legend
    for i = 1 : size(coeff,1) % 6 righe, una per giunto
        name = "Giunto " + i;
        acc = 2*coeff(i,3) + 6*coeff(i,4).*t + 12*coeff(i,5).*t.^2 + 20*coeff(i,6).*t.^3;
        plot (t, acc, DisplayName=name);
    end
end