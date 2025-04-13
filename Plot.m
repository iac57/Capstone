%% Rise time calculations

% Load the CSV file
data1 = readtable('10000Hz-risetime_test_0-50.csv');
data2 = readtable('10000Hz-risetime_test_0-100.csv');

% Extract time and current
time = data1.Time;
time2 = data2.Time;
current1 = data1.("CurrentReading");
current2 = data2.("CurrentReading");
beginning=find(current1 > 0.2, 1, 'first');
ending=find(current1 > 1.9, 1, "first");
rise_time = time(ending)-time(beginning);
disp(rise_time)

% Plot current as a function of time
figure;
plot(time2, current2);
xlabel('Time (s)');
ylabel('Current (A)');
title('Current vs. Time for 0-100 Dutycycle Jump');
xlim([0.15 0.3])
ylim([-1 3])
grid on;
% 
% figure;
% plot(time2, current2);
% xlabel('Time (s)');
% ylabel('Current (A)');
% title('Current vs. Time for 0-100 Dutycycle Jump');
% grid on;


% figure;
% plot(abs(fft(current1)));
% title(' FFT Current');
% grid on;

%% PWM to current calculatons
current_data = readtable('pwm_to_i_test.csv');
% Example data
% x = current_data.PWM;
% y = current_data.CurrentReading;

x=distance;
y=current;

% Fit y = a * x^2
X_squared = x.^2;
a = X_squared \ y;  % Least squares solution

% Predicted values
y_fit = a * X_squared;

% R^2 calculation
SS_res = sum((y - y_fit).^2);
SS_tot = sum((y - mean(y)).^2);
R_squared = 1 - SS_res / SS_tot;

% Plot
figure;
plot(x, y, 'DisplayName','Measured Data', 'LineWidth', 4); hold on;
plot(x, y_fit, 'r-', 'LineWidth', 2, 'DisplayName', sprintf('Fit: y = %.3f·x^2, R^2 = %.3f', a, R_squared));
xlabel('PWM');
ylabel('Current');
title('PWM vs Current with Quadratic Fit');
legend('show', 'Location', 'southeast');
grid on;


