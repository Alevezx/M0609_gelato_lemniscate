function [] = grafico_alphaee(alphaee, t)

% Grafico della velocità lineare di ee
figure('Name', 'Grafico di accelerazione angolare di ee', 'NumberTitle', 'off', 'Color', [1, 1, 1]);
plot(t, alphaee, 'g', 'LineWidth',1.5);
xlabel('Tempo (s)');
ylabel('Accelerazione angolare di ee (rad/s^2)');
title('Accelerazione angolare di ee');
legend('Accelerazione angolare di ee');
grid on;
hold off;

end