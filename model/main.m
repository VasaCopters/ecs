clear all;
clc;

Engine_front = 2.25;
Engine_right = 2.25;
Engine_left = 1.2;
Engine_back = 1.2;

 Kv = 14000*[1 0 0 0
             0 1 0 0
             0 0 1 0
             0 0 0 1]';      % rpm/Volt

zeta = [0 0 0]';
% omega = 1000*[1 1 1 1]';
w = [0 0 0]';

% syms psi theta phi       % yaw, pitch and roll
% 
% Rx = [ 1,      0,         0;
%        0, cos(phi), -sin(phi);
%        0, sin(phi),  cos(phi)];
%    
% Ry = [  cos(theta),   0,   sin(theta);
%               0,   1,         0;
%        -sin(theta),   0,   cos(theta)];
%    
% Rz = [ cos(psi),   -sin(psi),   0;
%        sin(psi),    cos(psi),   0;
%              0,          0,   1];
% 
% Reb = Rz*Ry*Rx


   

