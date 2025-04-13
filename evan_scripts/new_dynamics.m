%%% New transfer function dynamics derivation
% trying to successfully implement lead compensator
% https://ieeexplore.ieee.org/stamp/stamp.jsp?tp=&arnumber=5570565

% Good resource for discrete time control systems
% https://idsc.ethz.ch/content/dam/ethz/special-interest/mavt/dynamic-systems-n-control/idsc-dam/Lectures/Digital-Control-Systems/Slides_DigReg_2013.pdf

clear, clc, close all

%%% define model parameters
K = 9.7091e-06; % [N-A^2/m^2], electromechanical constant
m = 0.006;  % [kg]        
x0 = 5 * 1e-3; % [mm] -> [m], commanded equilibrium position of ball
g = 9.81; % [m/s^2]
L = 0.14485; % H
R = 8; % Ohm

%%% calculate other constants
i0 = sqrt( m*g*x0^2 / K ); % A
a = 2*K*i0^2 / ( m*x0^3 );
b = 2*K*i0 / ( m*x0^2 ); % TODO need to bookkeep a negative somewhere.
                         % seems like there is a negative number messing
                         % up my derivation. When I get rid of the negative
                         % in front of b, it fixes the root locus.

%%% write out Laplace transforms
s = tf('s');
P1 = ( 1/L ) / ( s + R/L );
P2 = ( b ) / ( s^2 - a );

G = (( s + 40 ) / ( s + 400 )); % Wong 1986
figure, rlocus(G*P1*P2)

k = 7e3;

figure, nyquist(k*G*P1*P2)
figure, step( feedback(P1*P2*G*k, 1) )

%%% convert to state space for initial condition testing
sys_ol = k*G*P1*P2;
sys_cl = minreal( sys_ol / (1 + sys_ol) );
[A, B, C, D] = tf2ss( sys_ol.Numerator{1}, sys_ol.Denominator{1} );

%%% change controller to discrete time
Ts = 5e-4; % typical loop/sampling frequency -- TODO experiment with different values of this
sys_d = c2d(G, Ts)


