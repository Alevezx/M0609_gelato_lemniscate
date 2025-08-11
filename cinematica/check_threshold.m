function [res] = check_threshold(outcomes,i,k,threshold)
res = 0;
if(outcomes(i,k) >= (pi-threshold) && outcomes(i,k) <= (pi+threshold))
    res = 1;
end


if(outcomes(i,k) >= 2*(pi-threshold) && outcomes(i,k) <= 2*(pi+threshold))
    res = 1;
end


if(outcomes(i,k) >= (-pi-threshold) && outcomes(i,k) <= (-pi+threshold))
    res = 1;
end


if(outcomes(i,k) >= (-2*pi-threshold) && outcomes(i,k) <= (-2*pi+threshold))
  res = 1;
end

end