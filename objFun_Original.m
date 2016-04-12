function reward = objFun_Original(perm_num, n_points, x_coords, y_coords)
    order = nthperm([1:n_points],perm_num);
    ordered_x_coords = x_coords(order);
    ordered_y_coords = y_coords(order);
    a_max = 10;

    pp = cscvn([ordered_x_coords; ordered_y_coords]);
    der = fnder(pp);
    dder = fnder(der);
    
    %Calculation of maximum achievable trajectory velocity 
    % (ds/dt assumed constant throughout trajectory) [d2s/dt2 = 0]
    % dx/dt = (dx/ds)(ds/dt);
    % dy/dt = (dy/ds)(ds/dt);
    % d2x/dt2 = (dx/ds)(d2s/dt2) + (d2x/ds2)(ds/dt)^2
    % d2x/dt2 = (d2x/ds2)(ds/dt)^2;                     [with d2s/dt2 = 0]
    % d2y/dt2 = (dy/ds)(d2s/dt2) + (d2y/ds2)(ds/dt)^2
    % d2y/dt2 = (d2y/ds2)(ds/dt)^2;                     [with d2s/dt2 = 0]
    
    poses = fnval(pp, pp.breaks);
    vels = fnval(der, pp.breaks);
    accels = fnval(dder, pp.breaks);
    t_vals = linspace(pp.breaks(1),pp.breaks(end),101);
    len = sum(sqrt(sum(diff(fnval(pp,t_vals),1,2).^2,1)));
    [max_curv_mag,pnt_indx] = max(sqrt(accels(1,:).^2 + accels(2,:).^2));
    
    t_path = sqrt((len.^2/a_max).*max_curv_mag);
    
    reward = t_path;
end