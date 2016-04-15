% objective Plotter
target_x = [9.5847    7.1073    3.5648    2.8757    6.7138    6.1783    3.8241    6.2827    9.1789    2.5905    3.2378   1.1041];
target_y = [0.2149    1.1286    6.2626    8.1635    5.6550    8.1919    5.1899    1.4281    5.4483    0.3615    2.8431   1.5212];
n_points = 12;

% Assume optimal sequence
perm_num = 25034347;
order = nthperm(1:n_points, perm_num);
ordered_x_coords = target_x(order);
ordered_y_coords = target_y(order);
% X = [L1, L2, xc, yc
accelcon = @(X) accelConstraint(X, ordered_x_coords, ordered_y_coords); 

% For link length
xc = [8.3175;3.7931]; % assume center point as origin
time = 21.3593;
L1_vec = linspace(2.75,6,150);
L2_vec = linspace(2.8,6,150);
[L1_mat, L2_mat] = ndgrid(L1_vec, L2_vec); 
pp = cscvn([ordered_x_coords; ordered_y_coords]); % [      x ;       y]; 
der = fnder(pp);                                  % [  dx/ds ;   dy/ds];
dder = fnder(der);                                % [d2x/ds2 ; d2y/ds2];
dsdt = pp.breaks(end)/time;
xy = fnval(pp, pp.breaks);
dxyds = fnval(der, pp.breaks);
dxydt = dxyds.*dsdt;
d2xyds2 = fnval(dder, pp.breaks); % [d2x/ds2 ; d2y/ds2];
d2xydt2 = d2xyds2.*(dsdt^2);
x = xy(1,:);
y = xy(2,:);
dxdt = dxydt(1,:);
dydt = dxydt(2,:);    
d2xdt2 = d2xydt2(1,:);
d2ydt2 = d2xydt2(2,:);
L_objfun = @(L1,L2) avgTorque([L1; L2; xc(1); xc(2)], x, y, dxdt, dydt, d2xdt2, d2ydt2); 

z = arrayfun(L_objfun,L1_mat, L2_mat);
z(z>15) = 15;

contourf(L1_mat, L2_mat,z, 10)
axis 'equal'
ylim([2.8;6])
xlim([2.75,6])
xlabel('L_1 [m]');
ylabel('L_2 [m]');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% figure(2)
% L1 = 4.0816;
% L2 = 3.5379;
% %xc_vec = linspace(-1,12,300);
% %yc_vec = linspace(-2,10,300);
% 
% xc_vec = linspace(8,8.75,300);
% yc_vec = linspace(2.5,3.5,300);
% 
% 
% [xc_mat, yc_mat] = ndgrid(xc_vec, yc_vec); 
% xc_objfun = @(xc,yc) avgTorque([L1; L2; xc; yc], x, y, dxdt, dydt, d2xdt2, d2ydt2); 
% z = arrayfun( xc_objfun, xc_mat, yc_mat);
% z(z>15) = 15;
% contourf(xc_mat, yc_mat, z, 10)
% hold on
% plot(ordered_x_coords, ordered_y_coords, 'ro','MarkerSize',8,'LineWidth',2.5)
% %plot(8.3175, 3.7931, 'go','MarkerSize',8,'LineWidth',2.5)
% axis([0,11,-1,9])
% xlabel('X position [m]')
% ylabel('Y position [m]')

% 
% 
% x = 25034347-5000 : 25034347+5000;
% %x = 1:20000;
% objFunComplete2 = @(perm_num) objFun_Original(perm_num, n_points, target_x, target_y); 
% z = arrayfun(objFunComplete2, x);
% 
% hold on
% plot(x, z,'k.')
% plot(25034347,objFunComplete2(25034347),'go','MarkerSize',10,'LineWidth',2)




