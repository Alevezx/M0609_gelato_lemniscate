function [] = grafico_aee(aee, t)

% Grafico della velocità lineare di ee
figure('Name', 'Grafico di accelerazione lineare di ee', 'NumberTitle', 'off', 'Color', [1, 1, 1]);
plot(t, aee, 'g', 'LineWidth',1.5);
xlabel('Tempo (s)');
ylabel('Accelerazione lineare di ee (m/s^2)');
title('Accelerazione lineare di ee');
legend('Accelerazione lineare di ee');
grid on;
hold off;

end