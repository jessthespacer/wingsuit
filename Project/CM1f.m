% Main wing (circular Clark Y, R^2 = .998)
function Cm = CM1f(alph)
    alph = alph * 180 / pi;
    
	if abs(alph) < 40
		Cm = -9E-5 * alph^2 - 0.001 * alph - 0.0596;
	else
		Cm = -0.25;
	end
end