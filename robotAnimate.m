function robotAnimate(perm_num, robot_X)
    L = reshape(robot_X(1:2),2,1);
    xc = reshape(robot_X(3:4),2,1);
    target_x = [9.5847    7.1073    3.5648    2.8757    6.7138    6.1783    3.8241    6.2827    9.1789    2.5905    3.2378   1.1041];
    target_y = [0.2149    1.1286    6.2626    8.1635    5.6550    8.1919    5.1899    1.4281    5.4483    0.3615    2.8431   1.5212];
    order = nthperm(1:12 , perm_num);
    ordered_x_coords = target_x(order);
    ordered_y_coords = target_y(order); 
    pp = cscvn([ordered_x_coords; ordered_y_coords]);
    fig = figure(1);
    s_vec = linspace(0,pp.breaks(end),1000);
    pos_vec = fnval(pp,s_vec);    
    movie_frames = [];
    tmax = 21.3593;
    time = linspace(0,tmax, 1000);
    for k = 1:size(pos_vec,2)
        clf
        fnplt(pp);
        hold on
        plot(ordered_x_coords, ordered_y_coords,'ro','MarkerSize',10)
        plot(xc(1), xc(2), 'bo','MarkerSize',8);        
        x = pos_vec(1,k);
        y = pos_vec(2,k);
        pos = [x;y];
        q = ik(pos-xc(:), L);
        pos1 = fk_single(q, L) + xc;
        plot([xc(1), pos1(1), pos(1)],[xc(2), pos1(2), pos(2)],'r','LineWidth',2);
        plot([pos1(1), pos(1)], [pos1(2), pos(2)],'k.','MarkerSize',20);
        xlabel('X position [m]')
        ylabel('Y position [m]')
        title(['Time: ',sprintf('%0.2f',time(k)),' [s]'])
        
        axis 'equal'
        axis([0,13,-1,9])
        movie_frames = [movie_frames,getframe(fig)];
    end
    %movie2avi(movie_frames, 'robot_movie.avi');
end


