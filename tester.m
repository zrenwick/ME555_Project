%tester script

% while(1)
%     in_x = -10+rand(2,1).*20;
%     out_x = fk(ik(in_x,[10;10]),[10;10]);
%     if(any(abs(out_x-in_x)>(10e-5)))
%         keyboard
%     end
%     plotIK([0;0],out_x,[10;10]);
%     drawnow;
% end
    
while(1)
    in_q = rand(2,1)*2*pi;
    in_qdot = rand(2,1)*2*pi*5;
    in_xdd = -10+rand(2,1).*20;
    qdd = ikddot(in_q, in_qdot, in_xdd,[8;8]);
    out_xdd = fkddot(in_q, in_qdot, qdd, [8;8]);
    
    if(any(abs(out_xdd-in_xdd)>(10e-5)))
        keyboard
    end
    %plotIK([0;0],out_x,[8;8]);
    %drawnow;
end