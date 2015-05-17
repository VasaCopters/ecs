close all
clear all
x = 0:10;
y = (1-x)/2;

plot(x,y)
hold on
axis equal

t1 = [  0.5   1    0   0.5;
        0    -1   -1   0  ;
        0     0    0   0  ];

plot(t1(1,:),t1(2,:));
hold on
axis equal
t2 = spegel(t1, 1,2,0,1);
plot(t2(1,:), t2(2,:),'r');
