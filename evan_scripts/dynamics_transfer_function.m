%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% MagLev DYNAMICS SIMLUATION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Evan Sharafuddin, Izzy Collins, Gabe Garcia
% 3/19/2025

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

%%% write out Laplace transformed linearized equation
a = 2*K*i0^2 / ( m*x0^3 );
b = -2*K*i0^2 / ( m*x0^2 );

s = tf('s');
P = b / ( s^2 - a );

C = pidtune(P, 'PID');

sys = P*C / ( 1 + P*C );
figure, step(sys)
t = 0:0.001:0.1;
figure, lsim(sys, 0.001*ones(size(t)), t);