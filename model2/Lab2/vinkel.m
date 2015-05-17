function v = vinkel( x, y )
%VINKEL Returns the angle between two vectors
%   <x,y> = |x||y|*cos(v)

v = acos(dot(x,y)/(norm(x)*norm(y)));

end