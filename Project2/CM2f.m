% Main wing (circular Clark Y, R^2 = .998)
function Cm = CM2f(alph)
    alph = alph * 180 / pi;
    
    if abs(alph) < 42
        Cm = -0.01 * alph;
    else
        Cm = -0.42;
    end
end