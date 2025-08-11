% applica la traiettoria per più waypoint come punto punto

function quintic_MW_robot(rbt, q)

    epsilon = 0.1 + 0.01*5;  
    rbt.DataFormat = 'row';
    flag_dati = 1;
    
    % rate animazione
    rate = 500; % Hz
    r = rateControl(rate); % Assicura che l'animazione per ogni moto punto-punto sia a rate
    T = 0.1; % s, tempo per il moto punto-punto
    T_tot = T * size(q,1); % s tempo totale per il moto completo

    % crea l'animazione per ogni punto
    f = figure('Name', 'Animazione', 'NumberTitle', 'off', 'Color', [1, 1, 1]);
    ax = axes('Parent', f);
    q_i = q(1, :);
    for i = 2:size(q, 1)
        q_f = q(i, :);

        % il tempo di percorrenza è t = 0:1/rate:T
        t = 0:1/rate:T;
        % coefficienti primo giunto
        a1(i,:) = quintic_spline([q_i(1) q_f(1)], [0 0], [0 0], T);
        a = a1(i,:);
        pos_q1 = a(6)*t.^5 + a(5)*t.^4 + a(4)*t.^3 + a(3)*t.^2 + a(2)*t + a(1);
        % secondo giunto
        a2(i,:) = quintic_spline([q_i(2) q_f(2)], [0 0], [0 0], T);
        a = a2(i,:);
        pos_q2 = a(6)*t.^5 + a(5)*t.^4 + a(4)*t.^3 + a(3)*t.^2 + a(2)*t + a(1);
        % terzo giunto
        a3(i,:) = quintic_spline([q_i(3) q_f(3)], [0 0], [0 0], T);
        a = a3(i,:);
        pos_q3 = a(6)*t.^5 + a(5)*t.^4 + a(4)*t.^3 + a(3)*t.^2 + a(2)*t + a(1);
        % quarto giunto
        a4(i,:) = quintic_spline([q_i(4) q_f(4)], [0 0], [0 0], T);
        a = a4(i,:);
        pos_q4 = a(6)*t.^5 + a(5)*t.^4 + a(4)*t.^3 + a(3)*t.^2 + a(2)*t + a(1);
        % quinto giunto
        a5(i,:) = quintic_spline([q_i(5) q_f(5)], [0 0], [0 0], T);
        a = a5(i,:);
        pos_q5 = a(6)*t.^5 + a(5)*t.^4 + a(4)*t.^3 + a(3)*t.^2 + a(2)*t + a(1);
        % sesto giunto
        a6(i,:) = quintic_spline([q_i(6) q_f(6)], [0 0], [0 0], T);
        a = a6(i,:);
        pos_q6 = a(6)*t.^5 + a(5)*t.^4 + a(4)*t.^3 + a(3)*t.^2 + a(2)*t + a(1);

        coeff = [a1(i,:); a2(i,:); a3(i,:); a4(i,:); a5(i,:); a6(i,:)];
        % Cancella i dati precedentemente salvati
        if flag_dati == 1
            fid = fopen("data_coeff.txt","w");  % apre e trunca
            fclose(fid);
            flag_dati = 0;
        end
        % salva i dati
        data_dump("data_coeff.txt", [i t]);
        data_dump("data_coeff.txt", coeff);
        
        % Animazione
        show(rbt, q_i, 'PreservePlot', false, 'Parent', ax);
        hold on
        pos = tform2trvec(getTransform(rbt, q_i, "endeff"));
        pl = plot3(pos(1), pos(2), pos(3));
        for k = 1:length(t)
            conf = [pos_q1(k) pos_q2(k) pos_q3(k) pos_q4(k) pos_q5(k) pos_q6(k)];
            show(rbt, conf, 'PreservePlot', false, 'Parent', ax);
            pos = tform2trvec(getTransform(rbt, conf, "endeff"));
            pl.XData(k) = pos(1);
            pl.YData(k) = pos(2);
            pl.ZData(k) = pos(3);
            waitfor(r);
        end

        q_i = q_f;

        % Calcolo velocità ed accelerazioni

        % calcolo posizioni
      
        % position = [pos_q1; pos_q2; pos_q3; pos_q4; pos_q5; pos_q6];
        % 
        % % calcolo velocità
        % 
        % vel = [];
        % for k = 1:6
        %     vel = [vel; coeff(k,2) + 2*coeff(k,3).*t + 3*coeff(k,4).*t.^2 + 4*coeff(k,5).*t.^3 + 5*coeff(k,6).*t.^4];
        % end
        % 
        % % end effector
        % [~, vee, wee] = diff_kinematics2(position', vel', rbt, 'endeff');
        % 
        % figure(Name="Velocità lineare end effector");
        % hold on
        % plot(t, vee);
        % 
        % figure(Name="Velocità angolare end effector");
        % hold on
        % plot(t, wee);

    end
    
    hold off

end