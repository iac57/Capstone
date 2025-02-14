%% Simulation of Maglev Ball System
% Izzy, Evan, and Gabe
% Advisors: Dr. Ching and Dr. Trobaugh
%THIS CONTROLLER STABILIZES TO WHATEVER EQUILIBRIUM POINT WE SET
% i.e., regulator

% System parameters
m = 0.00831;  % mass of the ball (kg)
c = 2.4832e-5;  % electromagnetic force constant
g = 9.81;  % gravitational constant
U = 1;  % steady-state current (Amps)
h_eq = sqrt(c / (m * g)) * U;  % equilibrium distance

a_21 = (2 * c * U^2) / (m * h_eq^3);
b_2 = - (2 * c * U) / (m * h_eq^2);
A = [0, 1; a_21, 0];
B = [0; b_2];
C = [1, 0]; 

p = [-1, -2];  
Kt = place(A, B, p);

disp('State Feedback Gains (Kt):');
disp(Kt);


tspan = [0, 10];
x0 = [0.03, 0];  
r = 0.02; 

[t, x_lin] = ode45(@(t, x_lin) linodefcn(x_lin, A, B, C, Kt), tspan, x0);

U_eq = U; 
k_current = - (m * h_eq^2) / (2 * c * U);
control_signal = x_lin * (-Kt');  
actual_current = U_eq + k_current * control_signal;

figure;
plot(t, x_lin(:, 1)+0.02, 'b', 'LineWidth', 1.5);
xlabel('Time (s)');
ylabel('Ball Position (m)');
title('Maglev Ball Position Over Time');
grid on;

figure;
plot(t, control_signal+U, 'r', 'LineWidth', 1.5);
xlabel('Time (s)');
ylabel('Current (Amps)');
title('Electromagnet Current Over Time');
grid on;

function dxdt = linodefcn(x, A, B, C, Kt)
    y = C * x;  
    u = -Kt * x;  
    dxdt = A * x + B * u; 
end
