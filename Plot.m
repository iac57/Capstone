%% Rise time calculations

% Load the CSV file
data1 = readtable('10000Hz-risetime_test_0-50.csv');
data2 = readtable('10000Hz-risetime_test_0-100.csv');
data3 = readtable('10000Hz-risetime_test_50-100.csv');

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


%% Rise time calculations

% Load the CSV files
data1 = readtable('10000Hz-risetime_test_30-60.csv');
data2 = readtable('10000Hz-risetime_test_0-100.csv');

% Extract time and current
time1 = data1.Time;
time2 = data2.Time;

current1 = data1.("CurrentReading");
current2 = data2.("CurrentReading");


% Calculate rise time for 0-50% duty cycle
beginning1 = find(current1 > 0.2, 1, 'first');
ending1 = find(current1 > 1.9, 1, 'first');
rise_time1 = time1(ending1) - time1(beginning1);
disp(['Rise time (30-60%): ', num2str(rise_time1), ' s'])

% Optional: Calculate rise time for 0-100% (could be useful for comparison)
beginning2 = find(current2 > 0.2, 1, 'first');
ending2 = find(current2 > 1.9, 1, 'first');
rise_time2 = time2(ending2) - time2(beginning2);
disp(['Rise time (0-100%): ', num2str(rise_time2), ' s'])

% Plot all three datasets
figure;
plot(time1, current1, 'b', 'DisplayName', '30-60%');
hold on;
plot(time2, current2, 'r', 'DisplayName', '0-100%');
% plot(time3, current3, 'g', 'DisplayName', '50-100%');
xlabel('Time (s)');
ylabel('Current (A)');
title('Current vs. Time for Duty Cycle Jumps');
legend;
xlim([0.15 0.3]);
ylim([-1 3]);
grid on;

% plot steps
step1 = [0.6*ones(beginning2, 1);  1.1*ones(length(current2) - beginning2, 1)];
step2 = [zeros(beginning2, 1);  1.9*ones(length(current2) - beginning2, 1)];
plot(time2, step1)
plot(time2, step2)


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

% %% PWM to current calculatons
% current_data = readtable('pwm_to_i_test.csv');
% % Example data
% % x = current_data.PWM;
% % y = current_data.CurrentReading;
% 
% x=distance;
% y=current;
% 
% % Fit y = a * x^2
% X_squared = x.^2;
% a = X_squared \ y;  % Least squares solution
% 
% % Predicted values
% y_fit = a * X_squared;
% 
% % R^2 calculation
% SS_res = sum((y - y_fit).^2);
% SS_tot = sum((y - mean(y)).^2);
% R_squared = 1 - SS_res / SS_tot;
% 
% % Plot
% figure;
% plot(x, y, 'DisplayName','Measured Data', 'LineWidth', 4); hold on;
% plot(x, y_fit, 'r-', 'LineWidth', 2, 'DisplayName', sprintf('Fit: y = %.3f·x^2, R^2 = %.3f', a, R_squared));
% xlabel('PWM');
% ylabel('Current');
% title('PWM vs Current with Quadratic Fit');
% legend('show', 'Location', 'southeast');
% grid on;
% 
% 
