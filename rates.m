% --- Vector components ---
% Y     = [alph1; omeg1; x; y; xdot; ydot]
% Ydot  = [alph1dot; omeg1dot; xdot; ydot; xddot; yddot]]

function Ydot = rates(Y, theta, zeta)
    alph1 = Y(1);
    alph2 = alph1 - theta;
    omeg1 = Y(2);
    vel = [Y(5); Y(6)];
    xdot = vel(1);
    ydot = vel(2);
    uinfty = norm(vel);
    
    ie = evalin('base', 'ie');
    je = evalin('base', 'je');
    
    % --- Forces and moments ---
    % Lift and drag
    L1 = lift(1, uinfty, alph1, zeta);
    L2 = lift(2, uinfty, alph2, zeta);
    D1 = drag(1, uinfty, alph1, zeta);
    D2 = drag(2, uinfty, alph2, zeta);
    M1 = mom(1, uinfty, alph1);
    M2 = mom(2, uinfty, alph2);
    
    % --- Geometry ---
    r1 = evalin('base', 'r1');
    r2 = evalin('base', 'r2');
    R1 = r1 * (ie * cos(alph1 + zeta) + je * sin(alph1 + zeta));
    R2 = r2 * (-ie * sin(alph1 + zeta) + je * cos(alph1 + zeta));
    
    % --- Rotational rates ---
    % Angular velocity
    Ydot(1) = omeg1;
    
    % Angular acceleration
    Izz = evalin('base', 'Izz');    % Import Izz from base
    
    ang_accel = 1/Izz * (cross([L1 + D1; 0], [R1; 0]) + ...
        cross([L2 + D2; 0], [R2; 0]) + M1 + M2);
    Ydot(2) = ang_accel(3);
    
    % --- Translational rates ---
    % Lateral velocity
    Ydot(3) = xdot;
    Ydot(4) = ydot;
    
    % Lateral acceleration
    m = evalin('base', 'm');
    g = evalin('base', 'g');
    lat_accel = (L1 + L2) / m + (D1 + D2) / m + g;
    Ydot(5) = lat_accel(1);
    Ydot(6) = lat_accel(2);
end

function L = lift(airfoil, uinfty, alph, zeta)
    % Retrieve aerodynamic properties for given airfoil
    if airfoil == 1
        A = evalin('base', 'A1');
        CLf = evalin('base', 'CL1');
    else
        A = evalin('base', 'A2');
        CLf = evalin('base', 'CL2');
    end
    CL = CLf(alph);
    
    % Basis vector transforms
    ie = evalin('base', 'ie');
    je = evalin('base', 'je');
    je_prime = -ie * sin(zeta) + je * cos(zeta);
    
    % Calculate lift
    rho = evalin('base', 'rho');
    L = 0.5 * rho * CL * A * uinfty^2 * je_prime;
end

function D = drag(airfoil, uinfty, alph, zeta)
    % Retrieve aerodynamic properties for given airfoil
    if airfoil == 1
        A = evalin('base', 'A1');
        CDf = evalin('base', 'CD1');
    else
        A = evalin('base', 'A2');
        CDf = evalin('base', 'CD2');
    end
    CD = CDf(alph);
    
    % Basis vector transforms
    ie = evalin('base', 'ie');
    je = evalin('base', 'je');
    ie_prime = ie * cos(zeta) + je * sin(zeta);
    
    % Calculate drag
    rho = evalin('base', 'rho');
    D = 0.5 * rho * CD * A * uinfty^2 * (-ie_prime);
end

function M = mom(airfoil, uinfty, alph)
    % Retrieve aerodynamic properties for given airfoil
    if airfoil == 1
        A = evalin('base', 'A1');
        c = evalin('base', 'c1');
        CMf = evalin('base', 'CM1');
    else
        A = evalin('base', 'A2');
        c = evalin('base', 'c2');
        CMf = evalin('base', 'CM2');
    end
    CM = CMf(alph);
    
    % Calculate moment
    rho = evalin('base', 'rho');
    M = 0.5 * rho * CM * A * uinfty^2 * c;
end