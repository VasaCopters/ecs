% Bla bla.. MIT license and the author is Markus Lindelöw 2015
classdef Quaternion
    %QUATERNION Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        r = 1;
        v = [0 0 0]';
    end
    
    methods
        function  q = Quaternion(r, v, u)
            if nargin == 0
                % Default: nothing to do
                return
            elseif nargin == 1
                % r is a vecotr [x y z], the norm is the angle to rotate
                v = r/norm(r);
                r = norm(r);
            elseif nargin == 2
                %Nothing is needed here
            elseif nargin == 3
                % Simultaneous rotation
                %r = roll;
                %v = pitch;
                %u = yaw;
                v = [r, v, u];
                r = norm(v);
            end
            
            % now r is angle and v is the axis
            if r == 0
                q.r = 1;
                q.v = [1 0 0];
            else
                q.r = cos(r/2);
                q.v = v/norm(v)*sin(r/2);
            end
        end
        
        function c = mtimes(a,b)
            r1 = a.r;
            v1 = a.v;
            r2 = b.r;
            v2 = b.v;
            
            c = Quaternion();
            c.r = r1*r2-dot(v1,v2);
            c.v = r1*v2+r2*v1+cross(v1,v2);
            
        end
        
        function c = mpower(a,b)
            if b == -1
                c = Quaternion(0, 0, 0);
                c.r = a.r;
                c.v = -a.v;
            else
                error('Currently only supports only ^-1');
            end
        end
        
        function [roll, pitch, yaw] = getEulerAngles(q,t)
            if nargin == 1
                t = 'XYZ';
            end
            
            q0 = q.r;
            q1 = q.v(1);
            q2 = q.v(2);
            q3 = q.v(3);
            
           switch t
               case 'ZYX'
                   roll = atan2(2*(q0*q1+q2*q3), 1-2*(q1^2+q2^2));
                   pitch = asin(2*(q0*q2-q3*q1));
                   yaw = atan2(2*(q0*q3+q1*q2), 1-2*(q2^2+q3^2)); 
               otherwise
                    error('Not supported')
           end
        end
        
        function R = getRotationMatrix(q)
            a = q.r;
            b = q.v(1);
            c = q.v(2);
            d = q.v(3);
            
            R = [a^2+b^2-c^2-d^2, 2*b*c-2*a*d, 2*b*d+2*a*c,
                 2*b*c+2*a*d, a^2-b^2+c^2-d^2, 2*c*d-2*a*b,
                 2*b*d-2*a*c, 2*c*d+2*a*b, a^2-b^2-c^2+d^2];
        end
        
        function [r, v] = getAngleAxis(q)
            if q.r == 1
                r = 0;
                v = [1 0 0]';
            else
                r = 2 * acos(q.r);
                v = q.v ./ sqrt(1 - q.r^2);
            end
        end
    end
    
end

