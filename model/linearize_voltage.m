function [A, B, C, D, constant] = linearize_voltage(operating_q, operating_pwm)
% function [A, B2] = linearize_pwm(operating_q, operating_pwm)
% constants
Ixx = 2.09*10^(-05);
Iyy = 2.09*10^(-05);
Izz = 3.81*10^(-05);
d = 0.046;
m = 0.027;
g = 9.8;
Kv = 14000;

Ct = 1.0942e-07;
C1 = 0.25*(Ct)*9.8/1000;                                                    % grams to newton                           
Cq = 1*(10^(-9))*(60/(2*pi))^2;                                             % Cq in rpm
d = 0.046;

C_propeller = [  C1   C1    C1    C1;
                 0    d*C1  0    -d*C1;
                -d*C1 0     d*C1  0;
                -Cq   Cq   -Cq    Cq];
%--------------------------------------------------------------------------
theta_0 = operating_q(1);
phi_0 = operating_q(2);
psi_0 = operating_q(3);
theta_dot_0 = operating_q(4);
phi_dot_0 = operating_q(5);
psi_dot_0 = operating_q(6);
x_0 = operating_q(7);
y_0 = operating_q(8);
z_0 = operating_q(9);
x_dot_0 = operating_q(10);
y_dot_0 = operating_q(11);
z_dot_0 = operating_q(12);

% Finding operating_thrust %
prop_omega = Kv*operating_pwm;

w1 = prop_omega(1);
w2 = prop_omega(2);
w3 = prop_omega(3);
w4 = prop_omega(4);

omega_square = [w1^2; w2^2; w3^2; w4^2];
operating_thrust = C_propeller*omega_square;

f_0 = operating_thrust(1);                                                  % Thrust
T_theta_0 = operating_thrust(1);                                            % Pitch torque
T_phi_0 = operating_thrust(2);                                              % Roll Torque
T_psi_0 = operating_thrust(3);                                              % Yaw Torque
%--------------------------------------------------------------------------
% Linearization
% Assignment for simplification
wx_0 = theta_dot_0;
wy_0 = phi_dot_0;
wz_0 = psi_dot_0;

A_trans = (1/m)*[ -f_0*cos(theta_0),                             0,             0;
                  -f_0*sin(theta_0)*sin(phi_0),  f_0*cos(theta_0)*cos(phi_0),   0;
                  -f_0*sin(theta_0)*cos(phi_0), -f_0*cos(theta_0)*sin(phi_0),   0];
          
B_trans = (1/m)*[ -sin(theta_0); cos(theta_0)*sin(phi_0); cos(theta_0)*cos(phi_0) ];

K_trans = (1/m)*[ f_0*theta_0*cos(theta_0);
                  f_0*sin(theta_0)*sin(phi_0)*theta_0 - f_0*cos(theta_0)*cos(phi_0)*phi_0;
                  f_0*sin(theta_0)*cos(phi_0)*theta_0 + f_0*cos(theta_0)*sin(phi_0)*phi_0 - m*g];

A_angle = [  0,                  -wz_0*(Izz - Iyy)/Ixx,  -wy_0*(Izz - Iyy)/Ixx;
            -wz_0*(Ixx - Izz)/Iyy,   0,                  -wx_0*(Ixx - Izz)/Iyy;
            -wy_0*(Iyy - Ixx)/Izz,  -wx_0*(Iyy - Ixx)/Izz,   0                ];
        
B_angle = [ (1/Ixx),    0,        0;
             0,      (1/Iyy),     0;
             0,         0,      (1/Izz)];
         
K_angle = [ wy_0*wz_0*(Izz - Iyy)/Ixx;    wx_0*wz_0*(Ixx- Izz)/Iyy;    wx_0*wy_0*(Iyy - Ixx)/Izz];

% state space parameters
A = [ zeros(3,3),   eye(3),      zeros(3,3),  zeros(3,3);           % A is 12x12 matrix
      zeros(3,3),   A_angle,     zeros(3,3),  zeros(3,3);
      zeros(3,3),   zeros(3,3),  zeros(3,3),  eye(3);
      A_trans,      zeros(3,3),  zeros(3,3),  zeros(3,3)];
  
B1 = [ zeros(3,4);
      zeros(3,1), B_angle;
      zeros(3,4);
      B_trans, zeros(3,3)];

u10 = operating_pwm(1);
u20 = operating_pwm(2);
u30 = operating_pwm(3);
u40 = operating_pwm(4);

B2 = B1*C_propeller*(Kv^2);

B = 2*B2*diag(operating_pwm);                    % B is 12x4 matrix

Delta =    [ zeros(3,1);
             K_angle;
             zeros(3,1);
             K_trans];

constant = Delta - B2*(operating_pwm);           % constant is 12x1 vector

C = eye(12);

D = zeros(12,4);

end