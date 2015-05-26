clear all;
clc;

Ts = 1/100;
Kv = 14000;
Qu = diag([5 5 5 5]);
Qx = 1e-1*diag([50 50 10 5 5 5 0.1 0.1 0.1 0.1 0.1 10]);
m = 0.027;
g = 9.8;

% operating point : order - angles_pitch.roll.yaw,angles_dot,translation_x.y.z, translation_dot
operating_q = [0 0 0 0 0 0 0 0 0 0 0 0]';
operating_voltage = control_PWM([m*g,0,0,0]')

% [A, B, constant] = linearize(operating_q, operating_thrust);

[A, B, C, D, constant] = linearize_voltage(operating_q, operating_voltage);
Klqr_continuous = lqr(A,B,Qx,Qu);                                                   % continuous for the simulation
Kr_continuous = pinv(D - (C - D*Klqr_continuous)*(A - B*Klqr_continuous)\B);        % continuous for the simulation

sys = ss(A,B,C,D);

% Discrete time for real system
clc
sysd = c2d(sys,Ts);
Ad = sysd.a;
Bd = sysd.b;
Cd = sysd.c;
Dd = sysd.d;

Klqr_d = lqrd(A,B,Qx,Qu,Ts)                % Discrete for real system

Kr_discrete = pinv(Dd - (Cd - Dd*Klqr_d)*(Ad - Bd*Klqr_d)\Bd)

eig(Ad - Bd*Klqr_d)                         % eigen values
%% LQR gain conversion in degrees
clc
Klqrd_degrees = [Klqr_d(:,1:6)/(180/pi), Klqr_d(:,7:end)]

Kr_degrees = pinv(Dd - (Cd - Dd*Klqrd_degrees)*(Ad - Bd*Klqrd_degrees)\Bd)
%initial input in pwm

r = [0 0 0 0 0 0 0 0 0 0 0 0]';                         % reference
u_initial = ( Kr_degrees*(r - operating_q) - Klqrd_degrees*(zeros(12,1) - operating_q) + operating_voltage ) %*(65535/4)
% Kr_degrees*(r - operating_q)
% Klqrd_degrees*(zeros(12,1)- operating_q)


%% Debug
clc
x = [0 0 0 0 0 0 0 0 0 0 0 0]';
klqr = Klqrd_degrees;
kr = Kr_degrees;
x_op = operating_q;
u_op = operating_voltage;

dx = x - x_op;
dr = r - x_op;
r_op = kr * dr;
kdx = klqr * dx;
du = r_op - kdx;
u = du + u_op;
