%% Simulation of Maglev Ball System
% Izzy, Evan, and Gabe
% Advisors: Dr. Ching and Dr. Trobaugh

%%
% Mass of the ball (kg)
m = 0.00831;
% Electromagnetic force constant
c = 2.4832 * 10^-5;
% Gravitational constant
g = 9.81;
% Current through the electromagnet (Amps)
U = 1;
% Distance between the ball and the top of the electromagnet in steady state
h_eq = (c / (m * g))^(1/2) * U;
h = 0.02;
u = (m * g / c)^(1/2) * h;

% Linearized system
a_21 = 2 * c * U^2 / (m * h_eq^3);
b_2 = -2 * c * U / (m * h_eq^2);
A = [0, 1; a_21, 0];
B = [0; b_2];
C = [1, 0];
D = [0]; 

% Augmented matrices for integral control
A_aug = [A, zeros(2,1); -C, 0]; 
B_aug = [B; 0];               
C_aug = [C, 0];
D_aug = [D];

% Desired pole locations
p = [-1, -2, -3];

% Compute gains
Ka = place(A_aug, B_aug, p);
Kt = Ka(1:2); 
Ki = Ka(3);  

disp('State Feedback Gains (Kt):');
disp(Kt);
disp('Integral Gain (Ki):');
disp(Ki);


tspan = [0, 200];
x0 = [0.01, 0, 0];
r = 0.03;

[t, x_lin] = ode45(@(t, x_lin) linodefcn(t, x_lin, A_aug, B_aug, C_aug, Ka, 0.03), tspan, x0);

control_input = zeros(length(t), 1);
for i = 1:length(t)
    control_input(i) = -Ka * (x_lin(i, :)' - [r; 0; 0]); 
end


ball_position = x_lin(:,1);
integral_state=x_lin(:,3);

figure;
plot(t, ball_position, 'b', 'LineWidth', 1.5);
xlabel('Time (s)');
ylabel('Ball Position (m)');
title('Maglev Ball Position Over Time');
grid on;

figure;
plot(t, integral_state, 'b', 'LineWidth', 1.5);
xlabel('Time (s)');
ylabel('Integral State');
title('Integral State Over Time');
grid on;

figure;
plot(t, control_input, 'r', 'LineWidth', 1.5);
xlabel('Time (s)');
ylabel('Control Input (Current, Amps)');
title('Control Input Over Time');
grid on;

function dxdt_lin = linodefcn(~, x, A_aug, B_aug, C_aug, Ka, r)
    u = -Ka * (x - [r; 0; 0]);
    dxdt_lin= A_aug*x+B_aug*u;
end
