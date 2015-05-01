function [T_b] = thrust(omega)

w1 = omega(1);
w2 = omega(2);
w3 = omega(3);
w4 = omega(4);

d = 0.046;

%Thrust (in gram) = 1.0942e-07*rpm² – 2.1059e-04*rpm + 0.15417.

C1 = 1.0942e-07;
C2 = -2.1059e-04;
C3 = 0.15417;

Cq = 1*(10^(-9));            %%      *(60/(2*pi))^2;                    % Cq in rpm

f1 = 0.25*(C1*w1^2 + C2*w1 + C3)*9.8/1000;
f2 = 0.25*(C1*w2^2 + C2*w2 + C3)*9.8/1000;
f3 = 0.25*(C1*w3^2 + C2*w3 + C3)*9.8/1000;
f4 = 0.25*(C1*w4^2 + C2*w4 + C3)*9.8/1000;


%-- Approximate linear when really low rpm --
lu = 1183;
k = y(lu)/lu;

if w1 < lu
    f1 = k * w1;
end
if w2 < lu
    f2 = k * w2;
end
if w3 < lu
    f3 = k * w3;
end
if w4 < lu
    f4 = k * w4;
end

f = f1 + f2 + f3 + f4;

T1 = d*(f2 - f4);
T2 = d*(f3 - f1);

T3 = -Cq*w1^2 + Cq*w2^2 - Cq*w3^2 + Cq*w4^2;

T_b = [f, T1, T2, T3]';

end