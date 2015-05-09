function [A, B, constant] = linearize(operating_q, operating_u)

Ixx = 2.09*10^(-05);
Iyy = 2.09*10^(-05);
Izz = 3.81*10^(-05);
d = 0.046;
m = 0.027;
g = 9.8;
    
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

f_0 = operating_u(1);                         % Thrust
T_theta_0 = operating_u(1);                   % Pitch torque
T_phi_0 = operating_u(2);                     % Roll Torque
T_psi_0 = operating_u(3);                     % Yaw Torque

% Assignment for simplification
wx_0 = theta_dot_0;
wy_0 = phi_dot_0;
wz_0 = psi_dot_0;



A_trans =  (1/m)*[ -f_0*cos(theta_0),                             0,             0;
                   -f_0*sin(theta_0)*sin(phi_0),  f_0*cos(theta_0)*cos(phi_0),   0;
                   -f_0*sin(theta_0)*cos(phi_0), -f_0*cos(theta_0)*sin(phi_0),   0];
          
B_trans = (1/m)*[ -sin(theta_0); cos(theta_0)*sin(phi_0); cos(theta_0)*cos(phi_0) ];

K_trans = (1/m)*[ f_0*theta_0*cos(theta_0);
                  f_0*sin(theta_0)*sin(phi_0)*theta_0 - f_0*cos(theta_0)*cos(phi_0)*phi_0;
                  f_0*sin(theta_0)*cos(phi_0)*theta_0 + f_0*cos(theta_0)*sin(phi_0)*phi_0];

A_angle = [  0,                  -wz_0*(Izz - Iyy)/Ixx,  -wy_0*(Izz - Iyy)/Ixx;
            -wz_0*(Ixx - Izz)/Iyy,   0,                  -wx_0*(Ixx - Izz)/Iyy;
            -wy_0*(Iyy - Ixx)/Izz,  -wx_0*(Iyy - Ixx)/Izz,   0                ];
        
B_angle = [ (1/Ixx),    0,        0;
             0,      (1/Iyy),     0;
             0,         0,      (1/Izz)];
         
K_angle = [ wy_0*wz_0*(Izz - Iyy)/Ixx;    wx_0*wz_0*(Ixx- Izz)/Iyy;    wx_0*wy_0*(Iyy - Ixx)/Izz];


A = [ zeros(3,3),   eye(3),      zeros(3,3),  zeros(3,3);
      zeros(3,3),   A_angle,     zeros(3,3),  zeros(3,3);
      zeros(3,3),   zeros(3,3),  zeros(3,3),  eye(3);
      A_trans,      zeros(3,3),  zeros(3,3),  zeros(3,3)];
  
B = [ zeros(3,4);
      zeros(3,1), B_angle;
      zeros(3,4);
      B_trans, zeros(3,3)];


constant = [ zeros(3,1);
             K_angle;
             zeros(3,1);
             K_trans];
         
end
      
      

