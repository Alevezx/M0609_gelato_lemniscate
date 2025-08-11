function [] = grafico_wee(wee, t)

% Grafico della velocità angolare di ee
figure('Name', 'Grafico della velocità angolare di ee', 'NumberTitle', 'off', 'Color', [1, 1, 1]);
plot(t, wee, 'b', 'LineWidth',1.5);
xlabel('Tempo (s)');
ylabel('Velocità angolare di ee (rad/s)');
title('Velocità angolare di ee');
legend('Velocità angolare di ee');
grid on;
hold off;

end