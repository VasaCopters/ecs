function R = rotation( v, t )
%ROTATION R = rotation( v, t )
%   v är den vektor som ger rotationsaxeln
%   t är den skalär som ger rotationsvinkeln
%   R är den beräknade 3x3 rotationsmatrisen

    M = [ cos(t) -sin(t) 0;
          sin(t) cos(t)  0;
          0      0       1];

    u = [ v(2); -v(1); 0 ];
    if all (u == 0)
        u = [1; 0; 0];
    end

    w = [ v(1)*v(3); v(2)*v(3); -(v(1)^2+v(2)^2) ];
    if all (w == 0)
        w = [0; 1; 0];
    end
    
    f1 = u/norm(u);
    f2 = w/norm(w);
    f3 = v/norm(v);

    P = [f1 f2 f3];

    R = P*M*P';
end