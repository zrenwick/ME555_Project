function [c, opt_L, avg_torque] = robot_optimizer(x, y, dxdt, dydt, d2xdt2, d2ydt2)
    % min mean(actuator torques)
    % s.t.
    %    meeting x, y, dx/dt, dy/dt, d2x/dt2, d2y/dt2 requirements.
    options = optimoptions('fmincon');
    options.Display = 'none';
    
    L_o = [10,10]; % initial guess at robot link lengths
    %torq_obj2 = @(L1,L2) avgTorque([L1,L2], x, y, dxdt, dydt, d2xdt2, d2ydt2);
    torq_obj = @(L) avgTorque(L, x, y, dxdt, dydt, d2xdt2, d2ydt2);
    arm_consts = @(L) armConstraints(L, x, y, dxdt, dydt, d2xdt2, d2ydt2, torq_obj);
    %[L1,L2] = meshgrid(0:0.005:7,0:0.005:7);
    %z = arrayfun(torq_obj2,L1,L2);
    %mesh(L1,L2,z);
    [opt_L, avg_torque, exit_flag, output] = fmincon(torq_obj, L_o,[],[],[],[],[0,0],[], arm_consts, options);
    c_raw = arm_consts(opt_L);
    c = c_raw(2:end);
    %c = output.constrviolation;
    %disp(['optimal L: ',num2str(opt_L),'  C: ',num2str(max(c))]);
end