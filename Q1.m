clc
clear

% Initialize Givens
Kt = 9.5;
Kb = 0.0704;
J = 0.0058;
R = 10;

% Create Matrices of State Space Representation
A = [0 1 0; 0 (-Kt*Kb)/(J*R) 0; 82/51 0 -1];
B = [0; (50*Kt)/(J*R); 0];
C = [0 0 51];
D = 0;

% Creating a State Space Object
sys = ss(A, B, C, D);

% Getting the Trasfer Function of The Tank Flow Rate with respect to the
% Input Voltage
[n, d] = ss2tf(A, B, C ,D);
sys_tf = tf(n, d);

% Getting the controllability Matrix and its determinant to determine the controllability
CM = ctrb(sys);
det_cm = det(CM);

% The conditions check if the system is controllable or not via the determinant
% since the controllability matrix will be a square matrix
fprintf('Determinant of Controlability Matrix = %f\n', det_cm);
if det_cm ~= 0
    fprintf('System is controllable\n');
else
    fprintf('System is not controllabl\n');
end

% Getting the observability matrix and its determinant to check for the observability
OM = obsv(sys); 
det_om = det(OM);

% The conditions check if the system is observable or not via the determinant
% since the observability matrix will be a square matrix
fprintf('Determinant of Observability Matrix = %f\n', det_om);
if det_om ~= 0
    fprintf('System is observable\n');
else
    fprintf('System is not observable\n');
end

% Getting The transfer of function of the Height of The tank with respect 
% to The input Voltage
C_new = [0 0 1];
sys_new = ss(A, B, C_new, D);
[n_new, d_new] = ss2tf(A, B, C_new ,D);
fprintf('\n');
disp('H(s)/Vi(s)::');
sys_tf_new = tf(n_new, d_new)

% Getting the eigen values of the A Matrix to determine the poles of the
% system
poles = eig(A)

% The loop goes over all the poles and check their position in The S-domain
% The purpose of the variable stability degree is to get the highest
% priority of unstability of all poles which is if the system is unstable
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

% Plotting the time domain step response of the output
figure('Name','Step Response','NumberTitle','off');
step(sys, [0 100])
title("System Before Feedback for 100 seconds increasing")
xlabel("Time")
ylabel("Amplitude")

% Getting the steady state error
fprintf('Steady state value of the system due to step input = %d\n', dcgain(sys_tf));

% Creating Feedback System after adding a lead compensator to stabilize the system
% and plotting it with its transient information (rise time, peak time, etc..)
G = tf([1],[1 1000]);
sys_feedback_new = feedback(G*sys_tf_new, 1);
figure('Name','Step Response','NumberTitle','off');
sys_info = stepinfo(sys_feedback_new)
step(ss(sys_feedback_new))
title("System after Controller and Feedback")
[num, den] = tfdata(sys_feedback_new);

% Printing the new steady state error
fprintf("Ess for the system = %f", 1 - dcgain(sys_feedback_new))

% Adding a PD Controller to the Lead Compensator to improve Transient
% Characteristics like reducing settling time and maximum overshhot
G_new = tf([2.755 3.746],[1 1000]);
sys_feedback_new_1 = feedback(G_new*sys_tf_new, 1);
sys_info = stepinfo(sys_feedback_new_1)
