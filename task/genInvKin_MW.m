% calcola la cinematica inversa con gik per più punti
% waypoints è un cell array delle matrici di rototraslazione
% start_config può essere homeConfiguration, permette più generalità

function q = genInvKin_MW(waypoints, gik, start_config, jointLim, poseConst)
   
    % pongo l'obiettivo della gik in uno dei waypoints
    for i = 1:length(waypoints)
        poseConst.TargetTransform = waypoints{i};
        
        if i == 1
            guess = start_config;
        elseif i > 1
            guess = q(i-1, :);
        end
        
        % calcolo la gik
        q(i, :) = gik(guess, jointLim, poseConst);
    end
end