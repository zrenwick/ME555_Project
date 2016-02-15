function plotFun(perm_num, n_points, x_coords, y_coords)
    order = nthperm([1:n_points],perm_num);
    x_red = x_coords(2:end);
    y_red = y_coords(2:end);
    pp = cscvn([x_coords(1),x_red(order); y_coords(1), y_red(order)]);
    fnplt(pp);
    hold on
    plot(x_coords, y_coords, 'r*');
end