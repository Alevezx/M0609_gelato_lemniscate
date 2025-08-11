% scrivi tutti i dati in un file
% v è un vettore di float
% il file viene aperto in append (a) per poter salvare più dati nello
% stesso codice con dei cicli for

function data_dump(filename, v) 
    fid = fopen(filename, "a");
    for i = 1:size(v,1)
        for j = 1:size(v,2)
            fprintf(fid, "%4f ", v(i,j));
        end
        fprintf(fid, "\n");
    end
    fprintf(fid, "---END OF DUMP---\n");
    fclose(fid);
end