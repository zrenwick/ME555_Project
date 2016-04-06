function plotIK(xc,x,L)
    q = ik(x, L);
    x1 = fk_single(q, L);
    plot([xc(1), x1(1), x(1)],[xc(2), x1(2), x(2)]);
    axis 'equal'
    hold on
end

