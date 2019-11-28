% Main wing (circular Clark Y, R^2 = 1)
function Cd = CD1f(alph)
	alph = alph * 180 / pi;

	if abs(alph) < 20
		Cd = 0.0004 * alph^2 + 0.0032 * alph + 0.0202;
	else
		Cd = 0.2442;
	end
end