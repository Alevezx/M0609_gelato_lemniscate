function [theta] = check_boundaries(theta, flag)

if(flag == 2)
    
    for i = 1:size(theta,2)
        if(theta(i) < -pi)
        theta(i) = double(theta(i) + 2*pi);
        end

        if(theta(i) > pi)
            theta(i) = double(theta(i) - 2*pi);
        end
    
    
    

     theta = theta(theta~=0);
end
end


if(flag == 3)
    
    for i = 1:size(theta,1)
        if(theta(i) < -pi)
        theta(i) = theta(i) + 2*pi;
        end

        if(theta(i) > pi)
            theta(i) = theta(i) - pi;
        end
   
    
    if(theta(i) > 5*pi/6 || theta(i) < -5*pi/6)
        theta(i) = 0;
    end
    
    theta = theta(theta~=0);
 end
end


end