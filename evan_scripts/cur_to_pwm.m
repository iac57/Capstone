% current to pwm fit
T = readtable("pwm_to_i_test.csv");

pwm = T.Var1;
cur = T.Var2;

cur = cur(cur>=0);
pwm = pwm(cur>=0);

% Fit the data
cutoff = 1;
cur_sm = cur(cur<=cutoff);
pwm_sm = pwm(cur<=cutoff);
cur_lg = cur(cur>cutoff);
pwm_lg = pwm(cur>cutoff);

ft = fittype('a*log10(x)', 'independent', 'x', 'coefficients', 'a');
[fitted_curve1, gof1] = fit(cur_sm, pwm_sm, ft);
ft = fittype('a*x+b', 'independent', 'x', 'coefficients', {'a', 'b'});
[fitted_curve2, gof2] = fit(cur_lg, pwm_lg, ft);

% Plot results
figure;
plot(fitted_curve1, cur_sm, pwm_sm)
% xlim([cur(1) cur(end)])
% xlabel('cur'), ylabel('pwm');
% title('Fit of y = a * sqrt(x) + b');
% legend('Data', 'Fit');
