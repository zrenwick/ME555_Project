clf
plotFunComplete(475297863);
[c, L, avg_torque] = robot_optimizer(x, y, dxdt, dydt, d2xdt2, d2ydt2);
for k = [1,9]
    x_vec = [x(k);y(k)];
    q = ik(x_vec, L);
    x1 = fk_single(q,L);
    x2 = fk(q,L);
    base = [0;0];
    points = [base,x1,x2];
    plot(points(1,:),points(2,:),'k','LineWidth',5)
    plot(points(1,2:3),points(2,2:3),'r.','MarkerSize',40)
end
