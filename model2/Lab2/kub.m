function kub( v, t )
%KUB Summary of this function goes here
%   Detailed explanation goes here


      
    if (size(v,2) > size(v,1))
        v = v';
    end
    
    front = [-1  1  1 -1;   %x
       1  1 -1 -1;   %y
      -1 -1 -1 -1];   %z
      
    % Define sides of the cube
    s(:,:,1) = front;                           %Front
    s(:,:,2) = rotation([0 1 0]', pi/2)*front;  %Right
    s(:,:,3) = rotation([0 1 0]', -pi/2)*front; %Left
    s(:,:,4) = rotation([0 1 0]', pi)*front;    %Back
    s(:,:,5) = rotation([1 0 0]', pi/2)*front;  %Right
    s(:,:,6) = rotation([1 0 0]', -pi/2)*front; %Left
    
    % Colors of the side
    c = ['r' 'g' 'b' 'y' 'm' 'c'];
    M = rotation(v, t);
    figure(1)
    
    %set(gcf, 'DoubleBuffer', 'on');
    if (t <= 0)
        t = 2*pi;
    end
    
    for j=0:t:2*pi
        for i=1:size(s,3)
            s(:,:,i) = M*s(:,:,i);
        end

        fill3(  s(1,:,1), s(2,:,1),s(3,:,1),c(1), ...
                s(1,:,2), s(2,:,2),s(3,:,2),c(2), ...
                s(1,:,3), s(2,:,3),s(3,:,3),c(3), ...
                s(1,:,4), s(2,:,4),s(3,:,4),c(4), ...
                s(1,:,5), s(2,:,5),s(3,:,5),c(5), ...
                s(1,:,6), s(2,:,6),s(3,:,6),c(6));

        axis equal
        axis([-2 2 -2 2 -2 2]);
        camproj('perspective');
        camlight('headlight')
        drawnow;
        pause(0.01);
    end

end