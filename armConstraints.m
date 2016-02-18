function [c, ceq] = armConstraints(L, x, y, dxdt, dydt, d2xdt2, d2ydt2, torq_obj)
    hold on
    plot3(L(1),L(2),torq_obj(L),'ro','MarkerSize',10);
    keyboard
    ceq = 0;
    Tmax1 = 1000000;
    Tmax2 = 1000000;
    T_max = [Tmax1; Tmax2];
    n_points = length(x);
    q = zeros(2,n_points);
    qd = zeros(2,n_points);
    qdd = zeros(2,n_points);
    xdd_max = zeros(2,n_points);
    for k = 1:n_points
        x_vec = [x(k);y(k)];
        xd_vec = [dxdt(k);dydt(k)];
        %%%
        q(:,k) = ik(x_vec,L);
        if(~isreal(q(:,k)))
            c = inf;
            return
        end        
        J = jac(q(:,k),L);
        qd(:,k) = J\xd_vec;
        qdd(:,k) = fdynamics(x_vec,xd_vec,T_max,L);
        xdd_max(:,k) = fkddot(q(:,k), qd(:,k), qdd(:,k),L);
    end
    xdd_needed = [d2xdt2; d2ydt2];
    c = max(max(xdd_needed - xdd_max));
    disp(L)
end