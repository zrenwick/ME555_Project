function xdd = fkddot(q,qd,qdd,l)
    J = jac(q,l);
    
    Jd(1,1) = l(1)*sin(q(1))*qd(1) + l(2)*sin(q(1)+q(2))*(qd(1)*qd(2));
    Jd(2,1) = -l(1)*cos(q(1))*qd(1) - l(2)*cos(q(1)+q(2))*(qd(1)*qd(2));
    Jd(1,2) = l(2)*sin(q(1)+q(2))*(qd(1)+qd(2));
    Jd(2,2) = -l(2)*cos(q(1)+q(2))*(qd(1)+qd(2));
    
    xdd = J * qdd + Jd * qd;
end