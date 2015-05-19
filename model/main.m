clear all;
clc;

Engine_front = 1.3;
Engine_right = 1.3;
Engine_left = 1.3;
Engine_back = 1.3;

Qu = diag([10 20 20 5]);
Qx = diag([1 1 1 1 1 1 1 1 1 1 1 1]);

Kv = 14000*[1 0 0 0
             0 1 0 0
             0 0 1 0
             0 0 0 1]';                         % rpm/Volt

zeta = [0 0 0]';

% omega = 1000*[1 1 1 1]';
w = [0 0 0]';

% operating point : order - angles_pitch.roll.yaw,angles_dot,translation_x.y.z, translation_dot
operating_q = [0 0 0 0 0 0 0 0 0.2 0 0 0]';
operating_pwm = [ 1.2 1.2 1.2 1.2]';

% [A, B, constant] = linearize(operating_q, operating_thrust);

[A, B, constant] = linearize_pwm(operating_q, operating_pwm);
Klqr = lqr(A,B,Qx,Qu)
