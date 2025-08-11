function [movimenti, tempi, coeff] = read_data_dump(filename)
% READ_DATA_DUMP   Legge un file strutturato in blocchi:
%   riga: num_movimento + vettore dei tempi
%   ---END OF DUMP---
%   sei righe, ciascuna con i coefficienti di un giunto
%   ---END OF DUMP---
%
% OUTPUT:
%   movimenti : vettore col num_movimento per ogni blocco
%   tempi     : cell array, tempi{i} è il vettore dei tempi del blocco i
%   coeffs    : cell array, coeffs{i} è matrice 6×Ncoeff con i coefficienti

    fid = fopen(filename, 'r');
    if fid<0
        error('Impossibile aprire %s', filename);
    end

    movimenti = [];
    tempi     = {};
    coeff    = {};

    blk = 0;
    while ~feof(fid)    % verifica se ha raggiunto la fine
        % legge riga movimento+tempi
        line = strtrim(fgetl(fid));
        data = str2num(line);
        blk = blk + 1;

        movimenti(blk,1) = data(1);
        tempi{blk}       = data(2:end);

        % riga marker
        marker = strtrim(fgetl(fid));
        assert(strcmp(marker, '---END OF DUMP---'), ...
               'Formato non corretto: mancato primo marker al blocco %d', blk);

        % coefficienti dei 6 giunti
        C = zeros(6, 0);
        for j = 1:6
            coeff_line = str2num(fgetl(fid));
            C(j,1:numel(coeff_line)) = coeff_line;
        end

        coeff{blk} = C;

        % secondo marker
        marker2 = strtrim(fgetl(fid));
        assert(strcmp(marker2, '---END OF DUMP---'), ...
               'Formato non corretto: mancato secondo marker al blocco %d', blk);
    end

    fclose(fid);
end
