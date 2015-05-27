
t = pitch_roll_yaw.time;
angles = pitch_roll_yaw.signals.values;
translation = X_Y_Z.signals.values;


plot(t,angles);
legend('pitch','roll','yaw');
xlabel('time (sec)');
ylabel('pitch, roll and yaw angles (rad)');
title('Quadcopter orientation');
grid;
print('-depsc', 'orientation_2');


plot(t,translation);
legend('X','Y','Z');
xlabel('time (sec)');
ylabel('X, Y and Z coordinate (m)');
title('Quadcopter translation');
grid;
print('-depsc', 'translation_2');
