function x = fk_single(q,l)
    x = zeros(2,1);
    x(1) = -l(1)*sin(q(1));
    x(2) = l(1)*cos(q(1));
end 