function qdd = fdynamics(x,xd,tau,l)

%% Definitions
% Generalized coordinates...
syms xx yy q1 q2
q  = [xx yy q1 q2];
% ... and generalized speeds
syms dx dy dq1 dq2 
dqdt = [dx dy dq1 dq2];
% Define the necessary PARAMETER subset:
% Gravity
syms g
% Segment dimensions:
syms l1 l2 lc1 lc2
% Masses/Inertia;
syms m1 m2 m3
syms j1 j2 j3
param = [l1 l2 g m1 m2 m3 j1 j2 j3];
%% DYNAMICS (obtained via the Euler-Lagrange equation)
% CoG-orientations (from kinematics):
%CoG_MB_ang    = phi;
CoG_MB_ang = q1+q2;
%CoG_Thigh_ang = phi+alpha;
CoG_Thigh_ang = q1+q2;
%CoG_Foot_ang  = phi+alpha;
CoG_Foot_ang  = q1;

% CoG-positions (from kinematics):
CoG_MB    = [xx;
             yy];
% CoG_Thigh = [x + l2 * sin(CoG_Thigh_ang);
%              y - l2 * cos(CoG_Thigh_ang)];
CoG_Thigh = [xx + (l2-lc2) * sin(CoG_Thigh_ang);
             yy - (l2-lc2) * cos(CoG_Thigh_ang)];
         
% CoG_Foot  = [x + (l-l3) * sin(CoG_Foot_ang);
%              y - (l-l3) * cos(CoG_Foot_ang)];

CoG_Foot  = [xx + l2 * sin(CoG_Thigh_ang) + (l1-lc1) * sin(CoG_Foot_ang);
             yy - l2 * cos(CoG_Thigh_ang) - (l1-lc1) * cos(CoG_Foot_ang)];
         
% CoG-velocities (computed via jacobians):
d_CoG_MB    = jacobian(CoG_MB,q)*dqdt.';
d_CoG_Thigh = jacobian(CoG_Thigh,q)*dqdt.';
d_CoG_Foot  = jacobian(CoG_Foot,q)*dqdt.';
d_CoG_MB_ang    = jacobian(CoG_MB_ang,q)*dqdt.';
d_CoG_Thigh_ang = jacobian(CoG_Thigh_ang,q)*dqdt.';
d_CoG_Foot_ang  = jacobian(CoG_Foot_ang,q)*dqdt.';
% Potential Energy (due to gravity):
V = CoG_MB(2)*m1*g + CoG_Thigh(2)*m2*g + CoG_Foot(2)*m3*g;
%V = simplify(factor(V));
% Kinetic Energy:         =
T = 0.5 * (m1 * sum(d_CoG_MB.^2) + ...
           m2 * sum(d_CoG_Thigh.^2) + ...
           m3 * sum(d_CoG_Foot.^2) + ...
           j1 * d_CoG_MB_ang^2 + ...
           j2 * d_CoG_Thigh_ang^2 + ...
           j3 * d_CoG_Foot_ang^2);
%T = simplify(factor(T));
% Lagrangian:
L = T-V;
% Partial derivatives:
dLdq   = jacobian(L,q).';
dLdqdt = jacobian(L,dqdt).';   
      
% Compute Mass Matrix:
M = jacobian(dLdqdt,dqdt);
%M = simplify(M);
% Compute the coriolis and gravitational forces:
dL_dqdt_dt = jacobian(dLdqdt,q)*dqdt.';
f_cg = dLdq - dL_dqdt_dt;

qdd = M \ (f_cg + tau);

%%
qval = [x',ik(x,l)'];
dq_val = (inv(jac(ik(x,l),l))*xd);
dqdtval = [xd',dq_val'];

l1val = l(1);
l2val = l(2);
lc1val = 0.5*l1val;
lc2val = lc1val;

gval = 0;

m1val = 1;
m2val = 1;
m3val = 1;

j1val = (m1val * l1val^2)/12;
j2val = (m2val * l2val^2)/12;
j3val = 0;

qdd = double(subs(qdd,{     xx,      yy,      q1,      q2,         dx,         dy,        dq1,        dq2,   g,   l1,   l2,   lc1,   lc2,   m1,   m2,   m3,   j1,   j2,   j3},...
                      {qval(1), qval(2), qval(3), qval(4), dqdtval(1), dqdtval(2), dqdtval(3), dqdtval(4),gval,l1val,l2val,lc1val,lc2val,m1val,m2val,m3val,j1val,j2val,j3val}));

% M * dqddt = f_cg(q, dqdt) + u;
   