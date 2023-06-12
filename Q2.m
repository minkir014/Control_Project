clc
clear
G = tf([240],poly([-4 -6]));
sys = feedback(G,1);
S = stepinfo(sys);
ess = 1-dcgain(sys);

fprintf('ess due to step input = %f\n', ess);
fprintf('and the overshoot = %f%%\n', S.Overshoot);

Kp = 1;
Ki = 2;
Kd = 0.1;

C = tf([Kd Kp Ki], [1 0]);
sys_new = feedback(G*C, 1);
S_new = stepinfo(sys_new);

ess_new = 1-dcgain(sys_new);

fprintf('ess due to step input = %f\n', ess_new);
fprintf('and the overshoot = %f%%\n', S_new.Overshoot);
fprintf('and the settling time = %f\n', S_new.SettlingTime);
