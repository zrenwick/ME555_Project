function x = fk(q,l)
    x = zeros(2,1);
    x(1) = -l(1)*sin(q(1)) - l(2)*sin(q(1)+q(2));
    x(2) = l(1)*cos(q(1)) + l(2)*cos(q(1)+q(2));
end 