function [T_b] = thrust(voltage)

voltage = min(voltage, [1 1 1 1]'*4);
voltage = max(voltage, [0 0 0 0]'*4);

w1 = voltage(1)*14000;
w2 = voltage(2)*14000;
w3 = voltage(3)*14000;
w4 = voltage(4)*14000;

d = 0.0325;             % for the Cross mode
% d = 0.046;            % for the Plus mode

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
k = 0.25*(C1*lu^2 + C2*lu + C3)*9.8/1000/lu;
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

% T1 = d*(f2 - f4);                       % Plus Mode
% T2 = d*(f3 - f1);                       % Plus Mode

T1 = d*(f1 + f4 - f2 - f3);               % Cross Mode
T2 = d*(f4 + f3 - f2 - f1);               % Cross Mode

T3 = -Cq*w1^2 + Cq*w2^2 - Cq*w3^2 + Cq*w4^2;

T_b = [f, T1, T2, T3]';

end