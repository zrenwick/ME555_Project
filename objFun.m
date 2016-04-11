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
    
    %options = optimoptions('fmincon','Display','iter','Algorithm','sqp','DiffMinChange',0.1,'TolFun',0.01,'UseParallel',false,'MaxFunEvals',1000);
    
    pop_size = 100;
    %pop_matrix = [rand(pop_size,1).*5 + 5, rand(pop_size,1).*5 + 5, zeros(pop_size,1), zeros(pop_size,1), rand(pop_size,1).*50 + 75];
    pop_matrix = [];
    while(size(pop_matrix,1)<pop_size)
        xc = rand(2,1).*10;
        vecs = [ordered_x_coords;ordered_y_coords] - xc*ones(1,n_points);
        lengths = sqrt(vecs(1,:).^2 + vecs(2,:).^2);
        L_min = min(lengths);
        L_max = max(lengths);
        L_1_plus_L_2 = rand.*10 + L_max;
        L_1_minus_L_2 = sign(rand-0.5)*(rand.*L_min);
        L1 = (L_1_plus_L_2 + L_1_minus_L_2)/2;
        L2 = (L_1_plus_L_2 - L_1_minus_L_2)/2;
                
%         candidate = [rand.*8 + 2, rand.*8 + 2, rand.*10, rand.*10, rand.*60 + 20];
        candidate = [L1, L2, xc(1), xc(2), rand.*60 + 20];
        if(all(accelcon(candidate)<=0))
            pop_matrix(end+1,:) = candidate;
        end
        disp(size(pop_matrix,1))
    end
    
    %[opt_X, opt_fval, exit_flag, output] = fmincon(selectorfunc, X_o,[],[],[],[],[0;0;0;0;0],[Inf;Inf;0;0;Inf], accelcon, options);
    opts = gaoptimset(...
    'PopulationSize',pop_size,...
    'Generations', 100,...
    'EliteCount',10,...
    'TolFun',1e-5,...
    'TolCon', 1e-8,...
    'InitialPopulation', pop_matrix,...
    'StallGenLimit', 50,...
    'Display','iter');

    
    
    [opt_X, opt_fval, exit_flag, output, population, scores] = ga(selectorfunc, 5, [],[],[],[], [0;0;-Inf;-Inf;0], [Inf;Inf;Inf;Inf;Inf], accelcon, [], opts);
    
    reward = opt_X(5); % to minimize time
end