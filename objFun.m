function reward = objFun(perm_num, n_points, x_coords, y_coords)
    order = nthperm([1:n_points],perm_num);
    ordered_x_coords = x_coords(order);
    ordered_y_coords = y_coords(order);
    
    %constraint equation for time optimizer (physical robotic constraints)
    accelcon = @(X) accelConstraint(X, ordered_x_coords, ordered_y_coords); 
    selectorfunc = @(X) X(5);
    
    pop_size = 100;
    
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
                
        candidate = [L1, L2, xc(1), xc(2), rand.*60 + 20];
        if(all(accelcon(candidate)<=0))
            pop_matrix(end+1,:) = candidate;
        end
    end
    
    opts = gaoptimset(...
    'PopulationSize',pop_size,...
    'Generations', 100,...
    'EliteCount',10,...
    'TolFun',1e-5,...
    'TolCon', 1e-8,...
    'InitialPopulation', pop_matrix,...
    'StallGenLimit', 50);
    
    
    [opt_X, opt_fval, exit_flag, output, population, scores] = ga(selectorfunc, 5, [],[],[],[], [0;0;-Inf;-Inf;0], [Inf;Inf;Inf;Inf;Inf], accelcon, [], opts);
    
    reward = opt_X(5); % to minimize time
end