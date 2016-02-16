function J = jac(q,l)
    J(1,1) = -l(1)*cos(q(1))-l(2)*cos(q(1)+q(2));
    J(2,1) = -l(1)*sin(q(1))-l(2)*sin(q(1)+q(2));
    J(1,2) = -l(2)*cos(q(1)+q(2));
    J(2,2) = -l(2)*sin(q(1)+q(2));
end