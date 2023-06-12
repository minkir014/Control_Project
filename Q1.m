clc
clear

Kt = 9.5;
Kb = 0.0704;
J = 0.0058;
R = 10;

A = [0 1 0; 0 (-Kt*Kb)/(J*R) 0; 82/51 0 -1];
B = [0; (50*Kt)/(J*R); 0];
C = [0 0 51];
D = 0;
sys = ss(A, B, C, D);
[n, d] = ss2tf(A, B, C ,D);
sys_tf = tf(n, d);

CM = ctrb(sys);
det_cm = det(CM);
fprintf('Determinant of Controlability Matrix = %f\n', det_cm);
if det_cm ~= 0
    fprintf('System is controllable\n');
else
    fprintf('System is not controllabl\n');
end

OM = obsv(sys); 
det_om = det(OM);
fprintf('Determinant of Observability Matrix = %f\n', det_om);
if det_om ~= 0
    fprintf('System is observable\n');
else
    fprintf('System is not observable\n');
end

C_new = [0 0 1];
sys_new = ss(A, B, C_new, D);
[n_new, d_new] = ss2tf(A, B, C_new ,D);
fprintf('\n');
disp('H(s)/Vi(s)::');
sys_tf_new = tf(n_new, d_new)

poles = eig(A)
stability_degree = -1;
for i = 1 : size(poles)
    if (real(poles(i)) > 0 || (imag(poles(i)) == 0  && real(poles(i)) == 0))
        stability_degree = 2;
        break;
    elseif (real(poles(i)) == 0 && abs(imag(poles(i))) > 0)
        stability_degree = 1;
    else
        stability_degree = 0;
    end
end

if stability_degree == 0
    fprintf("System is Stable\n")
elseif stability_degree == 1
    fprintf("System is Critically Stable\n")
else
    fprintf("System is Unstable\n")
end

figure('Name','Step Response','NumberTitle','off');
step(sys_new, [0 100])
title("System Before Feedback for 100 seconds increasing")
xlabel("Time")
ylabel("Amplitude")
fprintf('Steady state value of the system due to step input = %d\n', dcgain(sys_tf));

G = tf([1],[1 1000]);
sys_feedback_new = feedback(G*sys_tf_new, 1);
figure('Name','Step Response','NumberTitle','off');
sys_info = stepinfo(sys_feedback_new)
step(ss(sys_feedback_new))
title("System after Controller and Feedback")
[num, den] = tfdata(sys_feedback_new);
syms s;
tf_sym = poly2sym(cell2mat(num),s)/poly2sym(cell2mat(den),s);
fprintf("Ess for the system = %f", 1 - dcgain(sys_feedback_new))

G_new = tf([2.755 3.746],[1 1000]);
sys_feedback_new_1 = feedback(G_new*sys_tf_new, 1);
sys_info = stepinfo(sys_feedback_new_1)
