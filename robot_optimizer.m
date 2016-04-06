function [c, opt_X, avg_torque] = robot_optimizer(x, y, dxdt, dydt, d2xdt2, d2ydt2)
    % min mean(actuator torques)
    % s.t.
    %    meeting x, y, dx/dt, dy/dt, d2x/dt2, d2y/dt2 requirements.
    options = optimoptions('fmincon');
    options.Display = 'none';
    
    L_o = [10,10]; % initial guess at robot link lengths
    xc_o = [5,5];  % initial guess for robot base location
    X_o = [L_o';xc_o'];
    
    torq_obj = @(X) avgTorque(X, x, y, dxdt, dydt, d2xdt2, d2ydt2);
    arm_consts = @(X) armConstraints(X, x, y, dxdt, dydt, d2xdt2, d2ydt2);
    %[L1,L2] = meshgrid(0:0.05:15,0:0.05:15);
    %z = arrayfun(torq_obj2,L1,L2);
    %contourf(L1,L2,z,500);
    %keyboard
    %mesh(L1,L2,z);
    
    [opt_X, avg_torque, exit_flag, output] = fmincon(torq_obj, X_o,[],[],[],[],[0,0,-Inf,-Inf],[], arm_consts, options);
    %plot3(opt_L(1),opt_L(2),torq_obj(opt_L),'r.','MarkerSize',20);
    %plot(opt_L(1),opt_L(2),'r.','MarkerSize',20);
    %keyboard
    c_raw = arm_consts(opt_X);
    c = c_raw(2:end);
    %c = output.constrviolation;
    %disp(['optimal L: ',num2str(opt_L),'  C: ',num2str(max(c))]);
end