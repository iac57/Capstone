%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% MagLev dynamics
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Evan Sharafuddin, Izzy Collins, Gabe Garcia
% 3/21/2025
clear, clc, close all

%%% define model parameters
% electromechanical constant
% K = 1.2425e-5; % [N-A^2/m^2]
K = 9.7091e-06;
% mass of ball
m = 0.006;  % [kg]        
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
P_tf = b / ( s^2 + a );

% %%% write out state space representation of dynamics
% A = [0 1;
%      a 0];
% B = [0; b];
% % let output be position
% C = [1 0];
% D = 0;
% 
% P_ss = ss(A, B, C, D);

%%% add inductor dynamics
Tao_L = 1 / 55.23; % note: inductance is approximately 0.14485, would be worth checking more fits though
L = 0.14485;
R = 8;

% note equation for inductor: v = L * di/dt -> i_dot = v / L
%                                              I*s = V / L
%                                              I / V = L / s
%   input: v -> output: i
I_tf = 1 / (R+L*s);

%%% combine transfer functions
sys_tf = P_tf*I_tf
figure, rlocus(sys_tf)
Kk = 200;

cl = minreal(Kk*sys_tf / (1+Kk*sys_tf));
t = 0:0.001:0.5;
figure, lsim(cl, 0.01*ones(size(t)), t)


% % add integrator for finite steady state error
% 
% sys_tf = sys_tf / s;
% 
% figure, rlocus(sys_tf)
% 
% Kk = 50;
% 
% cl = minreal(Kk*sys_tf / (1+Kk*sys_tf));
% t = 0:0.001:0.5;
% figure, lsim(cl, 0.1*ones(size(t)), t)


%%
% % add lead compensator
% p0 = -1000; 
% z0 = -100;
% comp_tf = (s-z0) / (s-p0)
% 
% figure, rlocus(1/s*sys_tf*comp_tf);
% 
% 
% 
% % simulate with compensator
% Kk = 7.5e3; 
% 
% tf_final = 1/s*Kk*sys_tf*comp_tf;
% cl = minreal(tf_final / (1 + tf_final));
% 
% t = 0:0.001:0.5;
% figure, lsim(cl, 0.1*ones(size(t)), t)
