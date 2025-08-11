% applica la traiettoria per più waypoint come interpolazione punto punto
% una volta impostato il robot, bisogna rendere compatibili i valori della 
% configurazione da rappresentare. Successivamente si costruisce la spline
% per poi animare i vari giunti

function quintic_MW(rbt, q, handle)
    rbt.DataFormat = 'row';
    
    % rate animazione
    rate = 10; % Hz
    r = rateControl(rate); % Assicura che l'animazione per ogni moto punto-punto sia a rate
    T = 1; % s, tempo per il moto punto-punto, viene modificato in seguito (tempo_moto)

    % assicura che la finestra per l'animazione esista
    figure(handle)
    q_i = q(1, :);
    show(rbt, q_i);

    % prealloca variabili di debug
    a1 = zeros(size(q,1), 6);
    a2 = zeros(size(q,1), 6);
    a3 = zeros(size(q,1), 6);
    a4 = zeros(size(q,1), 6);
    a5 = zeros(size(q,1), 6);
    a6 = zeros(size(q,1), 6);
    for i = 2:size(q, 1)
        q_f = q(i, :);
        
        % sistema i valori dei giunti (non sempre necessario)
        % l'angolo finale dovrebbe essere sempre distante al massimo pi da
        % quello iniziale (in modulo)
        for k = 1:6
            q_f(k) = atan2(sin(q_f(k)), cos(q_f(k))); % 0:2pi
            if q_f(k) - q_i(k) < -pi
                q_f(k) = q_f(k) + 2*pi;
            elseif q_f(k) - q_i(k) > pi
                q_f(k) = q_f(k) - 2*pi;
            end
        end
        
        % calcola il tempo di percorrenza minimo per non superare i limiti di velocità 
        T = tempo_moto(q_i, q_f);

        % il vettore tempo di percorrenza è t = 0:1/rate:T
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

        % salva i dati
        %%data_dump([t; pos_q1; pos_q2; pos_q3; pos_q4; pos_q5; pos_q6]);
        
        % Animazione
        show(rbt, q_i, PreservePlot=false);
        hold on
        pos = tform2trvec(getTransform(rbt, q_i, "MODULE.1_FLANGE-END"));
        pl = plot3(pos(1), pos(2), pos(3));

        % mostra l'animazione
        for k = 1:length(t)
            conf = [pos_q1(k) pos_q2(k) pos_q3(k) pos_q4(k) pos_q5(k) pos_q6(k)];
            show(rbt, conf, PreservePlot=false);
            pos = tform2trvec(getTransform(rbt, conf, "MODULE.1_FLANGE-END"));
            pl.XData(k) = pos(1);
            pl.YData(k) = pos(2);
            pl.ZData(k) = pos(3);
            waitfor(r);
        end

        q_i = q_f;
    end
    hold off

end