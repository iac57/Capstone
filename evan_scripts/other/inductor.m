%%% Fit to determine inductance of magnet

T = readtable("inductor_charging_test_med_mean_10win.csv");
t = T.Time;
i = T.CurrentReading;

% figure, scatter(t, i)

% i = V_b/R * (1-e^-tR/L)
% http://hyperphysics.phy-astr.gsu.edu/hbase/electric/indtra.html

i = i(t > 0.1015 & t < 0.2);
t = t(t > 0.1015 & t < 0.2);
t = t - 0.1; % shift time 


figure, plot(t, i)

g = fittype('a*(1-exp(-c*x))');
f0 = fit(t,i,g)
hold on, plot(t, f0(t))

% R/L = c
R = 8; % ohms, approx
L = R/f0.c