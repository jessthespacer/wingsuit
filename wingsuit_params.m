% --- System constants ---
% Suit mass [kg]
m = 100;

% Suit moment of inertia, z-axis [kg m^2]
Izz = 10;

% Airfoil areas [m^2]
A1 = 1;
A2 = 1;

% Wingsuit vector lengths [m]
r1 = 1;
r2 = 1;
r3 = 1;

% Aerodynamic coefficient curve fits [dimensionless]
CL1 = @(alph) 1;
CL2 = @(alph) 1;
CD1 = @(alph) 1;
CD2 = @(alph) 1;
CM1 = @(alph) 1;
CM2 = @(alph) 1;

% Airfoil chord lengths [m]
c1 = 1;
c2 = 1;

% Unit vectors
ie = [1; 0];
je = [0; 1];

% Density of air [kg m^-3]
rho = 1.2;

% Gravity [m s^-2]
g = -9.81 * je;

% --- Save parameters ---
save('wingsuit_params.mat');