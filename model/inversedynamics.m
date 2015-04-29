% function [Tau_control] = inversedynamics(q, qdot, y, Tau_ext)
function [Tau_control] = inversedynamics(u)

q = u(1:3,1);
qdot = u(4:6,1);
y = u(7:9,1);
Tau_ext = u(10:12,1);


I1 = 0.5;
I2 = 0.1;
I3 = 0.08;
m1 = 0.75;
m2 = 0.5;
m3 = 0.25;
L1 = 0.13;
L2 = 0.13;
l1 = 0.05;
l2 = 0.11;
g = 9.8;

q1 = q(1);
q2 = q(2);
q3 = q(3);

q1dot = qdot(1);
q2dot = qdot(2);
q3dot = qdot(3);


A = [(1/2).*(2.*I1+l1.^2.*m2+L1.^2.*m3+l2.^2.*m3+(l1.^2.*m2+L1.^2.*m3).*cos(2.*q2)+(-1).*l2.^2.*m3.*cos(2.*(q2+q3))+2.*L1.*l2.*m3.*sin(q3)+2.*L1.*l2.*m3.*sin(2.*q2+q3)),       0,      0;
     0,     I2+I3+l1.^2.*m2+L1.^2.*m3+l2.^2.*m3+2.*L1.*l2.*m3.*sin(q3),     I3+l2.^2.*m3+L1.*l2.*m3.*sin(q3);
     0,     I3+l2.^2.*m3+L1.*l2.*m3.*sin(q3),                               I3+l2.^2.*m3];

B = [q1dot.*(2.*l2.*m3.*q3dot.*cos(q2+q3).*(L1.*cos(q2)+l2.*sin(q2+q3)) + q2dot.*(2.*L1.*l2.*m3.*cos(2.*q2+q3) + (-1).*(l1.^2.*m2+L1.^2.*m3).*sin(2.*q2)+l2.^2.*m3.*sin(2.*(q2+q3))));
    (1/2).*(2.*L1.*l2.*m3.*q3dot.*(2.*q2dot+q3dot).*cos(q3)+q1dot.^2.*((-2).*L1.*l2.*m3.*cos(2.*q2+q3)+(l1.^2.*m2+L1.^2.*m3).*sin(2.*q2)+(-1).*l2.^2.*m3.*sin(2.*(q2+q3))));
    (-1).*l2.*m3.*(L1.*q2dot.^2.*cos(q3)+q1dot.^2.*cos(q2+q3).*(L1.*cos(q2)+l2.*sin(q2+q3)))];
  
G = [0,     g.*((-1).*l1.*m2.*cos(q2)+(-1).*L1.*m3.*cos(q2)+(-1).*l2.*m3.*sin(q2+q3)),      (-1).*g.*l2.*m3.*sin(q2+q3)]';

Tau_d = Tau_ext + B + G;

Tau_control = Tau_d + A*y;

end