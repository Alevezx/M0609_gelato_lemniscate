function [] = grafico_posizione_giunti(q1, q2, q3, q4, q5, q6, t)

% Grafico delle posizioni
figure('Name', 'Grafico delle posizioni', 'NumberTitle', 'off', 'Color', [1, 1, 1]);
plot(t, q1, 'r', t, q2, 'b', t, q3, 'g', t, q4, 'c', t, q5, 'm', t, q6, 'y','LineWidth',1.5);
xlabel('Tempo (s)');
ylabel('Posizione (rad)');
title('Posizioni dei Giunti');
legend('q1','q2','q3','q4','q5','q6');
grid on;
hold off;

end