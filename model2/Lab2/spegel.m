function s = spegel(x, A, B, C, D)
%SPEGEL s = spegel(x, A, B, C, D)
    %Returns the mirror of x throgh the plane Ax+Bx+Cx

    s = x;
    for i=1:size(x,2)
        n = [A;B;C]/norm([A;B;C]);
        d = D/norm([A;B;C]);
        s(:,i) = x(:,i)+2*(d-dot(x(:,i),n))*n;
    end
end