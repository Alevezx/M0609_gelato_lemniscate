%costruizione manuale di una spline quintica per moto punto punto

function quintic_MW_urdf(rbt, q, theta_x, theta_y)

    % imposto un epsilon in funzione degli angoli che consente di avere una
    % soglia per correggere i valori risultanti dalla gik, senza usare
    % minimizzazioni in norma
    epsilon = 0.1 + 0.05*max(theta_x,theta_y);    

    rbt.DataFormat = 'row';
    
    % q = [q.JointPosition]';
    
    q = reshape(q, 6, 20);

    % rate animazione
    rate = 500; % Hz %400
    r = rateControl(rate); % Assicura che l'animazione per ogni moto punto-punto sia a rate
    T = 0.05; %0.4 % s, tempo per il moto punto-punto

    % crea l'animazione per ogni punto
    figure(Name="Animazione")

    q_i = -q(:, 1)';
    for i = 2:size(q, 2)
        q_f = -q(:,i)';

        i;
        q_i;
       
        %per tutti i valori dei giunti, controllo che non ci siano salti
        %che porterebbero il robot a girare: correggo i valori in modo da
        %minimizzare i giunti
        for k = 1:6
             
             if ( q_f(k) - q_i(k) < -2*pi+epsilon && q_f(k) - q_i(k) > -2*pi-epsilon) 
                 q_f(k) = q_f(k) + q_i(k) + 2*pi;
             elseif ( q_f(k) - q_i(k) > 2*pi - epsilon && q_f(k) - q_i(k) < 2*pi + epsilon)
                 q_f(k) = q_f(k) + q_i(k) - 2*pi;
             elseif (q_f(k) - q_i(k) < -pi+epsilon && q_f(k) - q_i(k) > -pi-epsilon) 
                 q_f(k) = q_f(k) + q_i(k) + pi;
             elseif ( q_f(k) - q_i(k) > pi - epsilon && q_f(k) - q_i(k) < pi + epsilon)
                 q_f(k) = q_f(k) + q_i(k) - pi;    
              elseif (q_f(k) - q_i(k) < -pi/2+epsilon/2 && q_f(k) - q_i(k) > -pi/2-epsilon/2) 
                 q_f(k) = q_f(k) + q_i(k) + pi/2;
             elseif ( q_f(k) - q_i(k) > pi/2 - epsilon/2 && q_f(k) - q_i(k) < pi/2 + epsilon/2 )
                 q_f(k) = q_f(k) + q_i(k) - pi/2;
             end
        end
        q_f;



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

        % salva i dati
        % data_dump("data_coeff_urdf.txt", [i t]);
        % data_dump("data_coeff_urdf.txt", [a1(i,:); a2(i,:); a3(i,:); a4(i,:); a5(i,:); a6(i,:)]);

        % Animazione
        show(rbt, q_i, PreservePlot=false, Visuals="on");
        hold on
        pos = tform2trvec(getTransform(rbt, q_i, "MODULE.1_FLANGE-END"));
        pl = plot3(pos(1), pos(2), pos(3));

        %aziono il robot
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
    % data_dump("data_q.txt", q);
    % diff_kinematics_urdf(q, rbt, t)

    hold off

end