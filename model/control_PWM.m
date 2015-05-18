function [PWM, omega] = control_PWM(control_input)
% Provides PWM signal for perticular control input

Ct = 1.0942e-07;
C1 = 0.25*(Ct)*9.8/1000;                                                    % grams to newton                           
Cq = 1*(10^(-9))*(60/(2*pi))^2;                                             % Cq in rpm
d = 0.046;

Kv =  14000*[1 0 0 0
             0 1 0 0
             0 0 1 0
             0 0 0 1]';

B = control_input;

A = [  C1   C1    C1    C1;
       0    d*C1  0    -d*C1;
      -d*C1 0     d*C1  0;
      -Cq   Cq   -Cq    Cq];

X = linsolve(A,B);

w1 = sqrt(X(1));
w2 = sqrt(X(2));
w3 = sqrt(X(3));
w4 = sqrt(X(4));

omega = [w1 w2 w3 w4]';

PWM = Kv\[w1; w2; w3; w4];

end