% --- Vector components ---
% Y     = [alph1; omeg1; x; y; xdot; ydot]
% Ydot  = [alph1dot; omeg1dot; xdot; ydot; xddot; yddot]]

function Ydot = rates(Y, theta, verbose)
	alph1 = Y(1);
	alph2 = alph1 - theta;
	omeg1 = Y(2);
	vel = [Y(5); Y(6); 0];
	xdot = vel(1);
	ydot = vel(2);
	uinfty = norm(vel);
	
	ie = evalin('base', 'ie');
	je = evalin('base', 'je');

	if (vel == [0; 0; 0])
		zet = 0;
	else
		zet = acos(dot(vel / norm(vel), [ie; 0]));
	end

	ie_prime = ie * cos(zet) + je * sin(zet);
	je_prime = -ie * sin(zet) + je * cos(zet);
	
	% --- Forces and moments ---
	% Lift and drag
	L1 = lift(1, uinfty, alph1, zet);
	L2 = lift(2, uinfty, alph2, zet);
	D1 = drag(1, uinfty, alph1, zet);
	D2 = drag(2, uinfty, alph2, zet);
	M1 = mom(1, uinfty, alph1);
	M2 = mom(2, uinfty, alph2);
	
	% Convert to 3D vectors
	L1 = [L1; 0];
	L2 = [L2; 0];
	D1 = [D1; 0];
	D2 = [D2; 0];
	M1 = [0; 0; M1];
	M2 = [0; 0; M2];
	
	% --- Geometry ---
	r1 = evalin('base', 'r1');
	r2 = evalin('base', 'r2');
	R1 = r1 * (ie_prime * cos(alph1) + je_prime * sin(alph1));
	R2 = -r2 * (ie_prime * cos(alph1) + je_prime * sin(alph1));
	R1 = [R1; 0];
	R2 = [R2; 0];
	
	% --- Rotational rates ---
	% Angular velocity
	Ydot(1) = omeg1;
	
	% Angular acceleration
	Izz = evalin('base', 'Izz');    % Import Izz from base
	
	ang_accel = 1 / Izz * (cross(R1, L1 + D1) + ...
		cross(R2, L2 + D2) + M1 + M2);
	Ydot(2) = ang_accel(3);
	
	% --- Translational rates ---
	% Lateral velocity
	Ydot(3) = xdot;
	Ydot(4) = ydot;
	
	% Lateral acceleration
	m = evalin('base', 'm');
	g = evalin('base', 'g');
	g = [g; 0];
	lat_accel = (L1 + L2) / m + (D1 + D2) / m + g;
	Ydot(5) = lat_accel(1);
	Ydot(6) = lat_accel(2);

	if verbose
		vel
		uinfty
		zet
		L1
		L2
		D1
		D2
		M1
		M2
		R1
		R2
		ML1 = cross(R1, L1)
		ML2 = cross(R2, L2)
		MD1 = cross(R1, D1)
		MD2 = cross(R2, D2)
		F = L1 + L2 + D1 + D2 - [0; m * 9.81; 0]
		Fmag = norm(F)
		Mtot = ML1 + ML2 + MD1 + MD2 + M1 + M2
	end
end

function L = lift(airfoil, uinfty, alph, zet)
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
	je_prime = -ie * sin(zet) + je * cos(zet);
	
	% Calculate lift
	rho = evalin('base', 'rho');
	L = 0.5 * rho * CL * A * uinfty^2 * je_prime;
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
	
	% Basis vector transforms
	ie = evalin('base', 'ie');
	je = evalin('base', 'je');
	ie_prime = ie * cos(zet) + je * sin(zet);
	
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