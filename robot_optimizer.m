function [c, opt_L] = robot_optimizer(x, y, dxdt, dydt, d2xdt2, d2ydt2)
    % min mean(actuator torques)
    % s.t.
    %    meeting x, y, dx/dt, dy/dt, d2x/dt2, d2y/dt2 requirements.
    options = optimoptions('fmincon');
    options.Display = 'none';
    
    L_o = [1,1]; % initial guess at robot link lengths
    
    torq_obj = @(L) avgTorque(L, x, y, dxdt, dydt, d2xdt2, d2ydt2);
    arm_consts = @(L) armConstraints(L, x, y, dxdt, dydt, d2xdt2, d2ydt2);
    
    [opt_L, opt_fval, exit_flag, output] = fmincon(torq_obj, time_o,[],[],[],[],0,[], arm_consts, options);
    

end