function plotFun(perm_num, n_points, x_coords, y_coords)
    order = nthperm([1:n_points],perm_num);
    pp = cscvn([x_coords(order); y_coords(order)]);
    fnplt(pp);
    hold on
    plot(x_coords, y_coords, 'r*');
end