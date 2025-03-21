%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% MagLev DYNAMICS SIMLUATION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Evan Sharafuddin, Izzy Collins, Gabe Garcia
% 3/19/2025

%%% References
% https://cpjobling.github.io/eglm03-textbook/intro.html
% Dr. Wise, ESE 543, WashU
% https://ctms.engin.umich.edu/CTMS/index.php?example=Introduction&section=ControlRootLocus
% T. Wong, “Design of a magnetic levitation control system- an under- graduate problem,” IEEE Transactions on Education, vol. E-29, no. 4, pp. 196–200, 1986

%%% NOTES
% I do not know what is going on. ss2tf and transfer function derivations
% are yielding different results. Need to determine which one is actually
% right




clear
clc
close all

%%% define model parameters
% electromechanical constant
% K = 1.2425e-5; % [N-A^2/m^2] TODO might want to verify this value further
               %             TODO need to find exact weight of the ball we used
K = 9.7091e-06;
% mass of ball
m = 0.008369;  % [kg]        TODO need to measure this
% commanded equilibrium position of ball
x0 = 10; % [mm]
% gravitational constant
g = 9.81; % [m/s^2]

%%% adjust model parameters
x0 = x0 / 1e3; % [mm] -> [m]

%%% determine equilibrium current value
i0 = sqrt( m*g*x0^2 / K ); % A

%% STEP 1: Determine governing differential equation for the MagLev system
% % represent as a system of first-order ODEs
% dx_dt = @(t, x) [x(2)                ; 
%                  -K/m * (i0/x(1))^2 + g]; % NOTE sign error in overleaf fixed here
% tspan = [0 1];
% 
% % start at X, no initial velocity
% [t, y] = ode45(dx_dt, tspan, [x0 0]);
% figure, plot(t, y(:,1))
% 
% % start at X, small initial velocity away from magnet
% [t, y] = ode45(dx_dt, tspan, [x0 0.00001]);
% figure, plot(t, y(:,1))
% 
% % start at X, small initial velocity toward magnet
% [t, y] = ode45(dx_dt, tspan, [x0 -0.01]);
% figure, plot(t, y(:,1))
% 
% % start at small distance from X away from magnet
% [t, y] = ode45(dx_dt, tspan, [x0+0.0001 0]);
% figure, plot(t, y(:,1))
% 
% % start at small distance from X towards magnet
% [t, y] = ode45(dx_dt, tspan, [x0-0.0001 0]);
% figure, plot(t, y(:,1))


%% STEP 2: Hand tune a PID controller
% Create plant and controller transfer functions
s = tf('s');

Kp = 100;
Ki = 10000;
Kd = 5;

a_21 = 2*K*i0^2 / (m*x0^3);
b_2 = 2*K*i0 / (m*x0^2);
% a_21 = 1;
% b_2 = 1;

P = b_2 / ( s^2 + a_21 );
Kt = Kp + Ki/s + Kd*s; % controller
% 
% % simulate open loop response at rest
% % t = linspace(0, 1, 1e3);
% % y = lsim(P, zeros(size(t)), t);
% % figure, plot(t,y)
% % title("Open loop response")
% 
% % simulate impulse imput
% u = zeros(size(t));
% u(1) = 1;
% y = lsim(P,u,t);
% figure, plot(t,y)
% 
% % add control
% cl = minreal((P*Kt)/(1+P*Kt));
% u = ones(size(t)) * 0.005; % go 5 mm away from equilib
% y = lsim(cl, u, t);
% figure, plot(t, y)
% title("Controlled output")
% 
% %%%Analyse the open loop system
% sys_OL = P*Kt;
% figure, margin(sys_OL)

%% STEP: state space representation
% a_21 = 1;
% b_2 = 1;

A = [0    1;
     a_21 0];
B = [0; -b_2];
C = [1 0];
D = 0;


[b, a] = ss2tf(A, B, C, D);
sys = tf(b, a);
rlocus(sys)
step(sys)




%% STEP 4: Simulate noise, sensor bandwidth, and filtering
