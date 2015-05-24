clear all;
clc;

Ts = 1/100;

Qu = diag([5 5 5 5]);
Qx = 1e-1*diag([0.1 0.1 0.1 0.1 0.1 0.1 100 100 100 0.1 0.1 0.1]);

zeta = [0 0 0]';

% omega = 1000*[1 1 1 1]';
%w = [0 0 0]';

% operating point : order - angles_pitch.roll.yaw,angles_dot,translation_x.y.z, translation_dot
operating_q = [0 0 0 0 0 0 0 0 0 0 0 0]';
operating_voltage = [ 1.2 1.2 1.2 1.2]';

% [A, B, constant] = linearize(operating_q, operating_thrust);

[A, B, C, D, constant] = linearize_voltage(operating_q, operating_voltage);
Klqr_continuous = lqr(A,B,Qx,Qu);

sys = ss(A,B,C,D);
sysd = c2d(sys,Ts);

Klqr_d = lqrd(A,B,Qx,Qu,Ts)                % which one to use
% Klqr_discrete = lqrd(a,b,Qx,Qu,Ts);       % Which one to use