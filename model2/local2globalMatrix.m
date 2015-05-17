function [ R ] = local2globalMatrix( roll, pitch, yaw )
%LOCAL2GLOBALMATRIX Summary of this function goes here
%   Detailed explanation goes here


    R = [cos(pitch)*cos(yaw), sin(yaw)*cos(pitch), -sin(pitch);
         cos(yaw)*sin(pitch)*sin(roll) - sin(yaw)*cos(roll), sin(yaw)*sin(pitch)*sin(roll) + cos(yaw)*cos(roll), cos(pitch)*sin(roll);
         cos(yaw)*sin(pitch)*cos(roll)+sin(yaw)*sin(roll), sin(yaw)*sin(pitch)*cos(roll)-cos(yaw)*sin(roll), cos(pitch)*cos(roll)];
     
end
