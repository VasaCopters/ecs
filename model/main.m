clear all
Qu = diag([0.1 0.1 0.1 0.1]);
Qx = diag([0.1 0.1 0.1 0.1 0.1 0.1 0.1 0.1 0.1 0.1 0.1 100]);

%zeta = [0 0 0]';

% omega = 1000*[1 1 1 1]';
%w = [0 0 0]';

% operating point : order - angles_pitch.roll.yaw,angles_dot,translation_x.y.z, translation_dot
operating_q = [0 0 0 0 0 0 0 0 0 0 0 0]';
operating_u = [1.3 1.3 1.3 1.3]';

[A, B, constant] = linearize(operating_q, operating_u);

Klqr = lqr(A,B,Qx,Qu);

% Reference = [0 0 0 0 0 0 0 0 0 0];

