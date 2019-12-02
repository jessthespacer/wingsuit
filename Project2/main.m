% ME 362 - Term project - Team 6
% Due December 3, 2019
% Team Members: Vincent Hartanto, Zirui Liu, Jin Sing Sia,
% 	Rabhav Vaishnav, Lucas Wen
% Programmer: Jin Sing Sia
close all; clear all;

% --- Load parameters ---
load('wingsuit_params.mat');
f = fopen('LDRplot.csv', 'w');
fclose(f);

% --- Vector components ---
% Y     = [alph; alphdot; x; y; xdot; ydot]
% Ydot  = [alphdot; alphddot; xdot; ydot; xddot; yddot]]

% --- Initial conditions ---
alph_0 = 0 * pi/180;			% Initial angle of attack
alphdot_0 = 0;					% Initial angular velocity
x_0     = 0;					% Initial x (please always set to zero)
y_0     = 0;					% Initial y (please always set to zero)
xdot_0  = 50;					% Initial x velocity
ydot_0  = 0;					% Initial y velocity

Y0 = [alph_0, alphdot_0, x_0, y_0, xdot_0, ydot_0];

% --- Simulation parameters ---
t_f = 5;						% Simulation length

% --- Control algorithm ---
theta = 0;
theta_command = @(y) theta * pi/180;

% --- Solve system ---
% Usage of rates(Y, theta, verbose):
%	Y:			State vector Y at current timestep
%	theta:		Elevator angle at current timestep
%	verbose:	Print out diagnostic information
[t, Y] = ode45(@(t, y) rates(t, y, theta_command(y), false), [0 t_f], Y0);

% --- Plot results ---
figure(1);
subplot(2, 2, 1);
plot(Y(:, 3), Y(:, 4));
title('Flightpath');
xlabel('x [m]');
ylabel('y [m]');
grid on;

% figure(2);
subplot(2, 2, 2);
V = sqrt(Y(:, 5).^2 + Y(:, 6).^2);
plot(t, V);
title('Freestream velocity');
xlabel('Time [s]');
ylabel('Velocity [m/s]');
xlim([0 t_f]);
grid on;

% figure(3);
subplot(2, 2, 3);
plot(t, Y(:, 1) * 180 / pi);
title('Angle of attack');
xlabel('Time [s]');
ylabel('Angle of attack [degrees]');
xlim([0 t_f]);
grid on;

% figure(4);
subplot(2, 2, 4);
plot(t, Y(:, 5));
hold on;
plot(t, Y(:, 6));
title('Velocity components');
xlabel('Time [s]');
ylabel('Velocity [m/s]');
legend('x-velocity', 'y-velocity');
xlim([0 t_f]);
grid on;

sgtitle({'Wingsuit simulation', ...
    ['alph_0 = ', num2str(alph_0), ' deg, xdot_0 = ', num2str(xdot_0), ...
    ' m/s, theta = ', num2str(theta), ' deg'], ...
});

figure(2);
T = readtable('LDRplot.csv');
plot(T.Var1, T.Var2);
title('Lift/Drag ratio');
xlabel('Time [s]');
ylabel('LDR');
xlim([0 t_f]);
grid on;