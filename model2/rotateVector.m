function [ M ] = rotate( from_vector, to_vector )
%LOCAL2GLOBAL Summary of this function goes here
%   Detailed explanation goes here

ssc = @(v) [0 -v(3) v(2); v(3) 0 -v(1); -v(2) v(1) 0];
RU = @(A,B) eye(3) + ssc(cross(A,B)) + ...
     ssc(cross(A,B))^2*(1-dot(A,B))/(norm(cross(A,B))^2);
     
M = RU(from_vector, to_vector);

end

