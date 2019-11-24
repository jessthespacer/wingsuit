% NACA 0012
function Cd = CD(alph)
	alph *= 180 / pi;

	if abs(alph) < 19
		Cd = 0.0046 * exp(0.1307 * alph);
	else
		Cd = 0.11407;
	end
end