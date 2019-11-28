% Main wing (circular Clark Y, R^2 = .9945)
function Cl = CL1f(alph)
	alph = alph * 180 / pi;

	if abs(alph) < 40
        Cl = 0.0374 * alph + 0.1888;
    else
        Cl = 0;
        disp("AIRFOIL 1 STALL");
    end
end