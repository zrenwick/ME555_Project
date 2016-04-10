function reward = objFun(perm_num, n_points, x_coords, y_coords)
    order = nthperm([1:n_points],perm_num);
    ordered_x_coords = x_coords(order);
    ordered_y_coords = y_coords(order);
    
    time_o = 50;
    L_o = [10,10]; % initial guess at robot link lengths
    xc_o = [0,0];  % initial guess for robot base location
    X_o = [L_o';xc_o';time_o];

    
    %constraint equation for time optimizer (physical robotic constraints)
    accelcon = @(X) accelConstraint(X, ordered_x_coords, ordered_y_coords); 
    selectorfunc = @(X) X(5);
    
    options = optimoptions('fmincon','Display','iter','Algorithm','sqp','DiffMinChange',0.1,'TolFun',0.01,'UseParallel',false,'MaxFunEvals',1000);
    
    pop_size = 100;
    pop_matrix = [rand(pop_size,1).*5 + 5, rand(pop_size,1).*5 + 5, zeros(pop_size,1), zeros(pop_size,1), rand(pop_size,1).*50 + 75];
    
    %[opt_X, opt_fval, exit_flag, output] = fmincon(selectorfunc, X_o,[],[],[],[],[0;0;0;0;0],[Inf;Inf;0;0;Inf], accelcon, options);
    opts = gaoptimset(...
    'PopulationSize',pop_size,...
    'Generations', 200,...
    'EliteCount',10,...
    'TolFun',1e-17,...
    'InitialPopulation', pop_matrix,...
    'PlotFcns', @gaplotbestf,...
    'StallGenLimit', 500,...
    'Display','iter');

    
    
    [opt_X, opt_fval, exit_flag] = ga(selectorfunc, 5, [],[],[],[], [0;0;0;0;0], [Inf;Inf;0;0;Inf], accelcon, [], opts);
    keyboard
    
%     pp = cscvn([x_coords(1),x_red(order); y_coords(1), y_red(order);[0,times]]);
%     der = fnder(pp);
%     dder = fnder(der);
%     poses = fnval(pp, pp.coefs);
%     vels = fnval(der, pp.coefs);
%     accels = fnval(dder, pp.coefs);
%     t_vals = linspace(pp.breaks(1),pp.breaks(end),101);
%     len = sum(sqrt(sum(diff(fnval(pp,t_vals),1,2).^2,1)));
%     reward = len;
    reward = opt_X(5); % to minimize time
end