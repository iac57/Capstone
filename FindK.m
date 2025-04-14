distance = [3.5052
4.6482
5.6642
6.6802
7.493
8.6614
9.2202
10.033
10.5918
11.3792
11.811];

% distance = [3.5052
% 4.6482
% 5.6642
% 6.6802
% 7.493
% 8.6614];

distance=distance*10^-3;

current = [0.75
0.85
0.95
1.05
1.15
1.25
1.35
1.45
1.55
1.65
1.75];

% current = [0.75
% 0.85
% 0.95
% 1.05
% 1.15
% 1.25];

% Linear fit
coeffs = polyfit(current, distance, 1);
slope = coeffs(1);
intercept = coeffs(2);
fit_line = polyval(coeffs, current);

% R² calculation
SS_res = sum((distance - fit_line).^2);
SS_tot = sum((distance - mean(distance)).^2);
R_squared = 1 - SS_res / SS_tot;


m=8*10^-3;
g=9.81;
K= slope^2*m*g;

% Plot data and fit
figure;
plot(current, distance, 'o', 'DisplayName','Measured Data', 'LineWidth', 2); hold on;
plot(current, fit_line, '-', 'DisplayName','Linear Fit', 'LineWidth', 2);
xlabel('Distance (m)', 'FontSize', 14);
ylabel('Current (A)', 'FontSize', 14);
title('Distance vs Current at Equilibrium', 'FontSize', 14);
legend('FontSize', 14, 'Location','southeast');
set(gca, 'FontSize', 14);
grid on;

eqn_str = sprintf('y = %.3fx %.3f\nR^2 = %.4f', slope, intercept, R_squared);
x_text = min(current) + (max(current) - min(current)) * 0.05;
y_text = max(distance) - (max(distance) - min(distance)) * 0.2;
text(x_text, y_text, eqn_str, 'FontSize', 14, 'BackgroundColor','white');
