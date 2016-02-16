%target_x = [0    6.3134    4.6518    7.6764    3.8855    9.7475    1.1057    5.5052    6.6732    3.0501    2.9731];
%target_y = [0    5.8447    9.9590    4.8446    1.7227    2.7709    6.2586    4.8653    7.2296    8.0537    4.6133];
target_x = [9.5847    7.1073    3.5648    2.8757    6.7138    6.1783    3.8241    6.2827    9.1789    2.5905    3.2378   1.1041];
target_y = [0.2149    1.1286    6.2626    8.1635    5.6550    8.1919    5.1899    1.4281    5.4483    0.3615    2.8431   1.5212];


% x_best = 1435901

% For n=12 case
% x_best = 475297863

% plot(target_x, target_y,'r*')
n_points = 12;

plotFunComplete = @(perm_num) plotFun(perm_num, n_points, target_x, target_y);
opts = gaoptimset(...
    'PopulationSize',10,...
    'Generations', 500,...
    'EliteCount',2,...
    'TolFun',1e-8,...
    'PlotFcns', @gaplotbestf);

objFunComplete = @(perm_num) objFun(perm_num, n_points, target_x, target_y); 

lb = 1;
ub = factorial(n_points);

[x_best, f_best, exitflag] = ga(objFunComplete, 1, [], [], [], [], lb, ub, [], 1, opts);

