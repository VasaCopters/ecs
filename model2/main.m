clf

Sample = 1000;

T = 2;

roll = -1;
pitch = 3;
yaw = 2;

Plate = [-1 -1  1 1;
          1 -1 -1 1;
          0  0  0 0];
P1 = Plate;
P2 = Plate;
P3 = Plate;
P4 = Plate;



fill3(Plate(1,:), Plate(2,:), Plate(3,:),'green')
hold on

R = local2globalMatrix(roll, pitch, yaw);
P1 = R*P2;
%fill3(P1(1,:), P1(2,:), P1(3,:),'b')


N = T * Sample; %Sekunder
R = local2globalMatrix(roll / Sample, pitch / Sample, yaw / Sample);
for i=1:N
    P2 = R*P2;
end
fill3(P2(1,:), P2(2,:), P2(3,:),'r')


plot3([0 roll*2], [0 pitch*2], [0 yaw*2]);

dir = [roll pitch yaw]';
R = rotation(dir, -T*norm([roll pitch yaw]));

P3 = R*P3;
fill3(P3(1,:), P3(2,:), P3(3,:),'b')


q = Quaternion(-T*norm(dir), dir);
R = q.getRotationMatrix();
P4 = R*P4;
fill3(P4(1,:), P4(2,:), P4(3,:),'y')

[a, b, c] = q.getAngles();
p = [cos(a) cos(b) cos(c)]';
p2 = R*[1 1 1]';
p2 = p2/norm(p2);

plot3([0 p(1)], [0 p(2)], [0 p(3)],'k');
plot3([0 p2(1)], [0 p2(2)], [0 p2(3)],'c');



axis([-2 2 -2 2 -2 2]);
axis square

xlabel('x');
ylabel('y');
zlabel('z');