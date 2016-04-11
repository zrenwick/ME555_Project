%target_x = [0    6.3134    4.6518    7.6764    3.8855    9.7475    1.1057    5.5052    6.6732    3.0501    2.9731];
%target_y = [0    5.8447    9.9590    4.8446    1.7227    2.7709    6.2586    4.8653    7.2296    8.0537    4.6133];
target_x = [9.5847    7.1073    3.5648    2.8757    6.7138    6.1783    3.8241    6.2827    9.1789    2.5905    3.2378   1.1041];
target_y = [0.2149    1.1286    6.2626    8.1635    5.6550    8.1919    5.1899    1.4281    5.4483    0.3615    2.8431   1.5212];


% x_best = 1435901

% For n=12 case
% x_best = 475297863 % test_case.mat

% plot(target_x, target_y,'r*')
n_points = 12;

objFunComplete = @(perm_num) objFun(perm_num, n_points, target_x, target_y); 
objFunComplete2 = @(perm_num) objFun_Original(perm_num, n_points, target_x, target_y); 
plotFunComplete = @(perm_num) plotFun(perm_num, n_points, target_x, target_y);

opts = gaoptimset(...
    'PopulationSize',10000,...
    'Generations', 100,...
    'EliteCount',500,...
    'TolFun',1e-8,...
    'UseParallel',true,...
    'Display','iter',...
    'PlotFcns', @gaplotbestf);


lb = 1;
ub = factorial(n_points);

[opt_X, opt_fval, exit_flag, output, population, scores] = ga(objFunComplete2, 1, [], [], [], [], lb, ub, [], 1, opts);

save('First_GA_Results.mat');
disp('Moving on to second GA');

ga_2_popsize = 100;
[score, indx] = sort(scores,'ascend');
top_pop_indx = indx(1:ga_2_popsize);
elites = population(top_pop_indx);

opts2 = gaoptimset(...
    'PopulationSize',ga_2_popsize,...
    'Generations', 100,...
    'EliteCount',10,...
    'TolFun',1e-8,...
    'InitialPopulation',elites,...
    'UseParallel',true,...
    'Display','iter',...
    'PlotFcns', @gaplotbestf);


%% step 2
[opt_X2, opt_fval2, exit_flag2, output2, population2, scores2] = ga(objFunComplete, 1, [], [], [], [], lb, ub, [], 1, opts2);

save('Second_GA_Results.mat');
