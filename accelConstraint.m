function [c, ceq] = accelConstraint(time, ordered_x_coords, ordered_y_coords)
    pp = cscvn([ordered_x_coords; ordered_y_coords]); % [      x ;       y]; 
    der = fnder(pp);                                  % [  dx/ds ;   dy/ds];
    dder = fnder(der);                                % [d2x/ds2 ; d2y/ds2];
    
    %Calculation of maximum achievable trajectory velocity 
    % (ds/dt assumed constant throughout trajectory) [d2s/dt2 = 0]
    % dx/dt = (dx/ds)(ds/dt);
    % dy/dt = (dy/ds)(ds/dt);
    % d2x/dt2 = (dx/ds)(d2s/dt2) + (d2x/ds2)(ds/dt)^2
    % d2x/dt2 = (d2x/ds2)(ds/dt)^2;                     [with d2s/dt2 = 0]
    % d2y/dt2 = (dy/ds)(d2s/dt2) + (d2y/ds2)(ds/dt)^2
    % d2y/dt2 = (d2y/ds2)(ds/dt)^2;                     [with d2s/dt2 = 0]
    
    dsdt = pp.breaks(end)/time;
    xy = fnval(pp, pp.breaks);
    dxyds = fnval(der, pp.breaks);
    dxydt = dxyds.*dsdt;
    d2xyds2 = fnval(dder, pp.breaks); % [d2x/ds2 ; d2y/ds2];
    d2xydt2 = d2xyds2.*(dsdt^2);
    %
    x = xy(1,:);
    y = xy(2,:);
    dxdt = dxydt(1,:);
    dydt = dxydt(2,:);    
    d2xdt2 = d2xydt2(1,:);
    d2ydt2 = d2xydt2(2,:);
    [c, L] = robot_optimizer(x, y, dxdt, dydt, d2xdt2, d2ydt2);
    ceq = 0;
end
