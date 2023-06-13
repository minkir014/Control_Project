# Control_Project
The project's aim is to practice compensation and controller design and also develop problem solving skills by modeling of real-life electromechanical system.

## Skills Learned
- Using MATLAB commands to simulate Control Blocks and execute algorithms and operations on the data

- Using SIMULINK to design controller by using available tools as PID Tuner

## Problems Encountered and Solved
- Using SIMULINK to develop PD Controller with a predetermined lead compensator can't be achieved so, we had to find another way.

![Problem with PID Tuner in SIMULINK](https://drive.google.com/uc?id=1YHdBBr6-jBzurWf9fAGSeVM-dW4LEL62)
<p style="text-align: center; margin-top: 1px;">Problem with PID Tuner in SIMULINK</p>

- So, we had to find another way which is to use a PI Controller to use the PID Tuner normally and add a block equivalent to $\frac{s}{s + 1000}$ The term (*s* + 1000) is the lead compensator given. The term *s* is to remove the effect of the *s* in integrator denominator while keeping the Numerator as it is. We then swapped in our Matlab Code *K<sub>p</sub>* for *K<sub>d</sub>*  as it was multiplied by *s* and *K<sub>I</sub>* became *K<sub>p</sub>*

![Compensator Formula](https://drive.google.com/uc?id=1fIC78HF6Qmm5a3uAU2eMLWRpL91hdhKg)
<p style="text-align: center; margin-top: 1px;">Compensator Block is selected. The PI block is also on the left which parameters were tuned and the block on the right is the system</p>