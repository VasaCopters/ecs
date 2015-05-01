function [T_b] = thrust(omega)

w1 = omega(1);
w2 = omega(2);
w3 = omega(3);
w4 = omega(4);

d = 0.046;

%Thrust (in gram) = 1.0942e-07*rpm² – 2.1059e-04*rpm + 0.15417.

C1 = 1.0942e-07;
C2 = -2.1059e-04;

% C3 = 0.15417;
 
if w1 < 2000 && w1 > -2000
    C13 = 0.15417;
else
    C13 = 0;
end

if w2 < 2000 && w2 > -2000
    C23 = 0.15417;
else
    C23 = 0;
end

if w3 < 2000 && w3 > -2000
    C33 = 0.15417;
else
    C33 = 0;
end

if w4 < 2000 && w4 > -2000
    C43 = 0.15417;
else
    C43 = 0;
end

Cq = 1*(10^(-9));            %%      *(60/(2*pi))^2;                    % Cq in rpm

f1 = 0.25*(C1*w1^2 + C2*w1 + C13)*9.8/1000;
f2 = 0.25*(C1*w2^2 + C2*w2 + C23)*9.8/1000;
f3 = 0.25*(C1*w3^2 + C2*w3 + C33)*9.8/1000;
f4 = 0.25*(C1*w4^2 + C2*w4 + C43)*9.8/1000;

f = f1 + f2 + f3 + f4;

T1 = d*(f2 - f4);
T2 = d*(f3 - f1);

T3 = -Cq*w1^2 + Cq*w2^2 - Cq*w3^2 + Cq*w4^2;

T_b = [f, T1, T2, T3]';

end