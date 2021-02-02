function dTdt = odefcn(t, T, sig, sig2, m, c, a, b, h, cp, density, Pz, Pt, To)
dTdt = zeros(2, 1);
dTdt(1) = (Pz + Pt - sig*(T(1)-To))/(a*b*h*cp*density);
dTdt(2) = -(sig2*(T(2)-T(1)))/(m*c);
end

