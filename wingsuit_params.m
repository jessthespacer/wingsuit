% --- System constants ---
% Suit mass [kg]
% NOTE: This value is arbitrary
m = 70;

% Suit moment of inertia, z-axis [kg m^2]
Izz = 12.8803;

% Airfoil areas [m^2]
A1 = 1.13;
A2 = 0.47;

% Wingsuit vector lengths [m]
r1 = 0.456;
r2 = 0.469;

% Aerodynamic coefficient curve fits [dimensionless]
% ALL TEMP
CL1 = @(alph) CL1f(alph);
CL2 = @(alph) CL2f(alph);
CD1 = @(alph) CD1f(alph);
CD2 = @(alph) CD2f(alph);
CM1 = @(alph) CM1f(alph);
CM2 = @(alph) CM2f(alph);

% Airfoil chord lengths [m]
c1 = 1.2;
c2 = 0.9;

% Unit vectors
ie = [1; 0];
je = [0; 1];

% Density of air [kg m^-3]
rho = 1.2;

% Gravity [m s^-2]
g = -9.81 * je;

% --- Save parameters ---
save('wingsuit_params.mat');