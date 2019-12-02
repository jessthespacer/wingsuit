% --- Vector components ---
% Y     = [alph; alphdot; x; y; xdot; ydot]
% Ydot  = [alphdot; alphddot; xdot; ydot; xddot; yddot]

function Ydot = rates(t, Y, theta, verbose)
    % Load model constants
    m = evalin('base', 'm');
    Izz = evalin('base', 'Izz');
	g = evalin('base', 'g');

	% Read last timestep's rates
    Ydot = zeros(6, 1);
	alph = Y(1);
	alphdot = Y(2);
	xdot = Y(5);
	ydot = Y(6);

	uinfty = norm([xdot, ydot]);
	
	% Get zeta
	zet = atan2(-ydot, xdot);

	% Effective angles
	alph_eff = alph + zet;
	beta_eff = alph_eff - theta;

	% --- Forces and moments ---
	% Aerodynamic forces and moments
	Lc = lift(1, uinfty, alph_eff);
	Ld = lift(2, uinfty, beta_eff);
	Dc = drag(1, uinfty, alph_eff);
	Dd = drag(2, uinfty, beta_eff);
	Mc = mom(1, uinfty, alph_eff);
	Md = mom(2, uinfty, beta_eff);
    
    % Get L/D ratio
    L = Lc + Ld;
    D = Dc + Dc;
    LDR = L/D;
    v = [t, LDR];
    fid = fopen('LDRplot.csv', 'at');
    fprintf(fid, '%.12d, %.12d\n', v);
    fclose(fid);

	% Sums of forces and moments
	Lcy = Lc * cos(zet) + Dc * sin(zet);
	Ldy = Ld * cos(zet) + Dd * sin(zet);
	Dcx = Dc * cos(zet) - Lc * sin(zet);
	Ddx = Dd * cos(zet) - Ld * sin(zet);

	Ly = Lcy + Ldy;
	Dx = Dcx + Ddx;
	Mo = Mc + Md + ...
		Lc * .456 * cos(alph_eff) + ...
		Dc * .456 * sin(alph_eff) - ...
		Ld * .469 * cos(alph_eff) - ...
		Dd * .469 *  sin(alph_eff);

	% --- Rates ---
	% Calculate rates
    xddot = -Dx / m;
    yddot = Ly / m - g;
    alphddot = Mo / Izz;

    % Write angular rates to output
   	Ydot(1) = alphdot;
   	Ydot(2) = alphddot;

   	% Write lateral rates to output
   	Ydot(3) = xdot;
	Ydot(4) = ydot;
	Ydot(5) = xddot;
	Ydot(6) = yddot;
end

function L = lift(airfoil, uinfty, alph)
	% Retrieve aerodynamic properties for given airfoil
	if airfoil == 1
		A = evalin('base', 'A1');
		CLf = evalin('base', 'CL1');
	else
		A = evalin('base', 'A2');
		CLf = evalin('base', 'CL2');
	end
	CL = CLf(alph);

	% Calculate lift
	rho = evalin('base', 'rho');
	L = 0.5 * rho * CL * A * uinfty^2;
end

function D = drag(airfoil, uinfty, alph, zet)
	% Retrieve aerodynamic properties for given airfoil
	if airfoil == 1
		A = evalin('base', 'A1');
		CDf = evalin('base', 'CD1');
	else
		A = evalin('base', 'A2');
		CDf = evalin('base', 'CD2');
	end
	CD = CDf(alph);
	
	% Calculate drag
	rho = evalin('base', 'rho');
	D = 0.5 * rho * CD * A * uinfty^2;
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