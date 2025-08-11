function [] = grafico_norma_giunti(q_norm, t)

% Grafico delle norme
figure('Name', 'Grafico delle norme dei giunti', 'NumberTitle', 'off', 'Color', [1, 1, 1]);
plot(t, q_norm, 'r','LineWidth',1.5);
xlabel('Tempo (s)');
ylabel('Norma delle posizioni (rad)');
title('Norma dei Giunti');
legend('Norma dei giunti');
grid on;
hold off;

end
