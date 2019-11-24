function Cm = CM(alph)
	if abs(alph < 20)
		Cm = -1E-09 * alph^4 + 8E-07 * alph^3 + 3E-09 * alph^2 + ...
			0.0009 * alph - 8E-06;
	else
		Cm = 0;
	end
end