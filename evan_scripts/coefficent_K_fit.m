clear, clc, close all

% Load column of data
load K_fit.mat;

X = X(:, 2);

% Linear regression using left divide
beta = X \ y;

% Display coefficients
disp('Coefficients:')
disp(beta)


% Predict values
y_fit = X * beta;

% Plot
figure;
% scatter(X(:,2), y, 'b', 'filled'); hold on; % Original data
% plot(X(:,2), y_fit, 'r-', 'LineWidth', 2);   % Fitted line
scatter(X, y, 'b', 'filled'); hold on; % Original data
plot(X, y_fit, 'r-', 'LineWidth', 2);   % Fitted line
xlabel('X');
ylabel('y');
title('Linear Regression using Left Divide (\\)');
legend('Data', 'Fit');
grid on;

K = beta^2*(0.008369)*9.81 % A^2N/m^2


%%% Nonzero y intercept
% Load column of data
load K_fit.mat;

% Linear regression using left divide
beta = X \ y;

% Display coefficients
disp('Coefficients:')
disp(beta)

% Predict values
y_fit = X * beta;

% Plot
figure;
scatter(X(:,2), y, 'b', 'filled'); hold on; % Original data
plot(X(:,2), y_fit, 'r-', 'LineWidth', 2);   % Fitted line
xlabel('X');
ylabel('y');
title('Linear Regression using Left Divide (\\)');
legend('Data', 'Fit');
grid on;

K = beta(2)^2*(0.008369)*9.81 % A^2N/m^2
