% --- System constants ---
% Suit mass [kg]
m = 100;

% Suit moment of inertia, z-axis [kg m^2]
Izz = 12.8803;

% Airfoil areas [m^2]
A1 = 1.13;
A2 = 0.47;

% Wingsuit vector lengths [m]
r1 = 1;
r2 = 1;

% % Aerodynamic coefficient curve fits [dimensionless]
CL1 = @(alph) CL(alph);
CL2 = @(alph) CL(alph);
CD1 = @(alph) CD(alph);
CD2 = @(alph) CD(alph);
CM1 = @(alph) CM(alph);
CM2 = @(alph) CM(alph);

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