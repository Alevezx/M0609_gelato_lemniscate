% sulla base dei vincoli di velocità del datasheet (o di vincoli arbitrari), calcola il tempo
% minimo per muovere i giunti dalla configurazione iniziale a quella finale

function T = tempo_moto(inizio, fine)
    limiti_DS = [pi*150/180 pi*150/180 pi*180/180 pi*225/180 pi*225/180 pi*225/180]; % rad/s
    
    % diminuisce la velocità massima per migliorare l'animazione
    limiti_DS = limiti_DS ./ 4;
    moto = abs(fine - inizio);
    t = moto./limiti_DS;
    T = max(t);
end