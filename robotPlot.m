function robotPlot( X, ordered_x_coords, ordered_y_coords , varargin)
%ROBOTPLOT Summary of this function goes here
%   Detailed explanation goes here
    if(~isempty(varargin))
        config_points = varargin{1};
    end
    L = X(1:2);
    xc = X(3:4)';
    pp = cscvn([ordered_x_coords; ordered_y_coords]);
    fnplt(pp);
    hold on
    plot(ordered_x_coords, ordered_y_coords, 'r*');
    plot(xc(1), xc(2), 'bo');
    for k = config_points
        x = ordered_x_coords(k);
        y = ordered_y_coords(k);
        pos = [x;y];
        q = ik(pos-xc, L);
        pos1 = fk_single(q, L) + xc;
        plot([xc(1), pos1(1), pos(1)],[xc(2), pos1(2), pos(2)]);
    end
end

