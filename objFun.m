function reward = objFun(perm_num, n_points, x_coords, y_coords)
    order = nthperm([1:n_points],perm_num);
    x_red = x_coords(2:end);
    y_red = y_coords(2:end);
    ordered_x_coords = [x_coords(1), x_red(order)];
    ordered_y_coords = [y_coords(1), y_red(order)];
    
    time_o = 1;
    
    %constraint equation for time optimizer (physical robotic constraints)
    accelcon = @(time) accelConstraint(time, ordered_x_coords, ordered_y_coords); 
    
    options = optimoptions('fmincon');
    options.Display = 'none';
    [opt_time, opt_fval] = fmincon(@sum, time_o,[],[],[],[],0,[], accelcon, options);
%     pp = cscvn([x_coords(1),x_red(order); y_coords(1), y_red(order);[0,times]]);
%     der = fnder(pp);
%     dder = fnder(der);
%     poses = fnval(pp, pp.coefs);
%     vels = fnval(der, pp.coefs);
%     accels = fnval(dder, pp.coefs);
%     t_vals = linspace(pp.breaks(1),pp.breaks(end),101);
%     len = sum(sqrt(sum(diff(fnval(pp,t_vals),1,2).^2,1)));
%     reward = len;
    reward = opt_time; % to minimize time
end