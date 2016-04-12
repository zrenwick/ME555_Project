function accelPlot(X, ordered_x_coords, ordered_y_coords, pnt_num)
    L = X(1:2);
    xc = X(3:4)';
    time = X(5);
    pp = cscvn([ordered_x_coords; ordered_y_coords]); % [      x ;       y]; 
    der = fnder(pp);                                  % [  dx/ds ;   dy/ds];
    dder = fnder(der);                                % [d2x/ds2 ; d2y/ds2];
    fnplt(pp);
    hold on
    plot(ordered_x_coords, ordered_y_coords, 'r*');
    plot(xc(1), xc(2), 'bo');
    for k = pnt_num
        x = ordered_x_coords(k);
        y = ordered_y_coords(k);
        pos = [x;y];
        q = ik(pos-xc, L);
        pos1 = fk_single(q, L) + xc;
        plot([xc(1), pos1(1), pos(1)],[xc(2), pos1(2), pos(2)]);
    end
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
    for k = pnt_num
        xp = [x(k); y(k)];
        xd = [dxdt(k);dydt(k)];
        %q = ik(xp, L);
        %J = jac(q,L);
        %qd = inv(J)*xd;
        for ang = linspace(0,2*pi,100)
            mag = 25;
            tau = [25;25];
            while(any(abs(tau)>10))
                mag = mag - 0.01;
                disp(mag);
                xdd = mag.*[cos(ang); sin(ang)];
                tau = idynamics(xp-xc, xd, xdd, L);
                if(mag < 0)
                    mag = 0;
                    break;
                end
            end
            plot([xp(1),xp(1) + xdd(1)],[xp(2),xp(2) + xdd(2)]);

        end
    end
end

