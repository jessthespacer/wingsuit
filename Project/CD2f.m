% Main wing (circular Clark Y, R^2 = 1)
function Cd = CD2f(alph)
	alph = alph * 180 / pi;

	if abs(alph) < 42
		Cd = 0.0008 * alph^2 - 0.0001 * alph + 0.0079;
	else
		Cd = 1.4149;
	end
end