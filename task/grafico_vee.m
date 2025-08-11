function [] = grafico_vee(vee, t)

% Grafico della velocità lineare di ee
figure('Name', 'Grafico della velocità lineare di ee', 'NumberTitle', 'off', 'Color', [1, 1, 1]);
plot(t, vee, 'b', 'LineWidth',1.5);
xlabel('Tempo (s)');
ylabel('Velocità lineare di ee (m/s)');
title('Velocità lineare di ee');
legend('Velocità lineare di ee');
grid on;
hold off;

end