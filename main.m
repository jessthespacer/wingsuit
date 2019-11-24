% ME 362 - Term project - Team 6
% Due December 3, 2019
% Team Members: Vincent Hartanto, Zirui Liu, Jin Sing Sia,
% 	Rabhav Vaishnav, Lucas Wen
% Programmer: Jin Sing Sia
close all; clear all;

% --- Load parameters ---
load('wingsuit_params.mat');

% --- Vector components ---
% Y     = [alph1; omeg1; x; y; xdot; ydot]
% Ydot  = [alph1dot; omeg1dot; xdot; ydot; xddot; yddot]]

% --- Initial conditions ---
alph1_0 = 10 * pi/180;			% Initial angle of attack
omeg1_0 = 0;					% Initial angular velocity
x_0     = 0;					% Initial x (please always set to zero)
y_0     = 0;					% Initial y (please always set to zero)
xdot_0  = 70;					% Initial x velocity
ydot_0  = 0;					% Initial y velocity

Y0 = [0, 0, 0, 0, 70, 0];

% --- Simulation parameters ---
t_f = 1;						% Simulation length

% --- Solve system ---
% Usage of rates(Y, theta, verbose):
%	Y:			State vector Y at current timestep
%	theta:		Elevator angle at current timestep
%	verbose:	Print out diagnostic information

[t, Y] = ode45(@(t, y) rates(y, 0, false), [0 t_f], Y0);

% --- Plot results ---
figure(1);
plot(Y(:, 3), Y(:, 4));
title('Flightpath');
xlabel('x [m]');
ylabel('y [m]');
grid on;

figure(2);
V = sqrt(Y(:, 5).^2 + Y(:, 6).^2);
plot(t, V);
title('Freestream velocity');
xlabel('Time [s]');
ylabel('Velocity [m/s]');
grid on;

figure(3);
plot(t, Y(:, 1) * 180 / pi);
title('Angle of attack');
xlabel('Time [s]');
ylabel('Angle of attack [degrees]');
grid on;

figure(4);
plot(t, Y(:, 5));
hold on;
plot(t, Y(:, 6));
title('Velocity components');
xlabel('Time [s]');
ylabel('Velocity [m/s]');
legend('x-velocity', 'y-velocity');
grid on;