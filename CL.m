% NACA 0012
function Cl = CL(alph)
	alph *= 180 / pi;

	if alph < -23
		Cl = 0;
	else if alph < 23
		Cl = -4E-07 * alph^5 + 2E-08 * alph^4 + 3E-05 * alph^3 - ...
			2E-06 * alph^2 + 0.1093 * alph + 3E-05;
	else
		Cl = 0;
	end
end