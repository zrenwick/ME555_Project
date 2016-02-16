function q = ik(x,l)
 q = [ -pi/2 + acos((l(1)^2+x(1)^2+x(2)^2-l(2)^2)/(2*l(1)*sqrt(x(1)^2+x(2)^2)))+acos(x(1)/(sqrt(x(1)^2+x(2)^2)));
       - pi + acos((l(1)^2+l(2)^2-x(1)^2-x(2)^2)/(2*l(1)*l(2)))];
end 
    
