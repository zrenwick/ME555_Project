function tau_mu = avgTorque(L, x, y, dxdt, dydt, d2xdt2, d2ydt2)
    n_points = length(x);
    q = zeros(2,n_points);
    qd = zeros(2,n_points);
    qdd = zeros(2,n_points);
    T_used = zeros(2,n_points);
    for k = 1:n_points
        x_vec = [x(k);y(k)];
        xd_vec = [dxdt(k);dydt(k)];
        xdd_vec = [d2xdt2(k); d2ydt2(k)];
        %%%
        q(:,k) = ik(x_vec,L);
        if(~isreal(q(:,k)))
            tau_mu = inf;
            return
        end
        J = jac(q(:,k),L);
        qd(:,k) = inv(J)*xd_vec;
        T_used(:,k) = idynamics(x_vec,xd_vec,xdd_vec,L);
    end
    tau_mu = mean(mean(T_used));
end