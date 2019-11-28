% Main wing (circular Clark Y, R^2 = .9945)
function Cl = CL2f(alph)
	alph = alph * 180 / pi;
    
    if abs(alph) < 42
        Cl = 0.05 * alph;
    else
        Cl = 0;
        disp("AIRFOIL 2 STALL");
    end
end