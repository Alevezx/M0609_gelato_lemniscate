function pos = calcolo_pos(movimenti, tempi, coeff)

% calcolo posizioni
T = tempi{1}(end) - tempi{1}(1);
pos = [];
t = [];
for i =1:length(movimenti)
    
    pos_c = [];
    for j = 1:6
        pos_c = [pos_c; coeff{i}(j,1) + coeff{i}(j,2).*tempi{i} + coeff{i}(j,3).*tempi{i}.^2 + coeff{i}(j,4).*tempi{i}.^3 + coeff{i}(j,5).*tempi{i}.^4 + coeff{i}(j,6).*tempi{i}.^5];
    end
    pos = [pos, pos_c];
    t = [t, (movimenti(i) - 2)*T + tempi{i}];
end

k = 2*pi/t(end);

legenda = cell(1,6);
figure(Name="Angoli giunti");
hold on
for i = 1:6
    plot(t*k, pos(i,:));
    legenda{i} = sprintf('giunto %d', i);
end
hold off;
legend(legenda);
xlabel('t');
ylabel('Angoli [rad]');

end