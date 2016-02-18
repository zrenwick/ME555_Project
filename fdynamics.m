function qdd = fdynamics(x,xd,tau,l)
    m1 = 1;
    m2 = 1;
    gval = 0;
    
    q = ik(x,l);
    dqdt = inv(jac(q,l))*xd;
    l1 =l(1);
    l2 = l(2);

    M = zeros(2,2);
    M(1,1) = m1*l1^2 + m2*(l1^2 + 2*l1*l2*cos(q(2)) + l2^2);
    M(2,1) = m2*l2*(l2 + l1*cos(q(2)));
    M(1,2) = M(2,1);
    M(2,2) = m2*l2^2;

    f = zeros(2,1);
    f(1,1) = dqdt(2)*(2*dqdt(1) + dqdt(2));
    f(2,1) = -dqdt(1)^2;
    f = m2*l1*l2*sin(q(2)).*f;
    
    g = -gval.*[(m1+m2)*l1*sin(q(1)) + m2*l2*sin(q(1)+q(2));...
                                           m2*l2*sin(q(1)+q(2))];
                                       

    qdd = inv(M)*(f + g +tau);
end