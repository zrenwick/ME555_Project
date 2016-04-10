function [c, ceq] = armConstraints(X, x, y, dxdt, dydt, d2xdt2, d2ydt2)
    hold on
    %plot3(L(1),L(2),torq_obj(L),'r.','MarkerSize',20);
    %plot(L(1),L(2),'r.','MarkerSize',20);
    %keyboard
    [L, x, y] = cen_shift(X, x, y);
    ceq = 0;
    Tmax1 = 10;
    Tmax2 = 10;
    T_max = [Tmax1; Tmax2];
    n_points = length(x);
    tau_req = zeros(2,n_points);
    dists = sqrt(x.^2 + y.^2);
    min_reachable_dist = abs(L(1)-L(2));
    max_reachable_dist = L(1) + L(2);
    
    c1 = (max(dists) - max_reachable_dist);
    c2 = (min_reachable_dist - min(dists));
    
    if((c1>0)||(c2>0))
        c3 = ones(n_points*2,1);
        c = [c1;c2;c3];
        return
    else
        for k = 1:n_points
            x_vec = [x(k);y(k)];
            xd_vec = [dxdt(k);dydt(k)];
            xdd_vec = [d2xdt2(k);d2ydt2(k)];
            %%%
            tau_req(:,k) = idynamics(x_vec,xd_vec,xdd_vec,L);
        end
        tau_const = abs(tau_req) - T_max*ones(1,n_points);
        c3 = tau_const(:);
    end
    c = [c1;c2;c3];
end