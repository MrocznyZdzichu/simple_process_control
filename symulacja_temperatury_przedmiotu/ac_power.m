function P = ac_power(Pmax, u)
if u > Pmax
   P = Pmax;
elseif u < -1*Pmax
    P = -1*Pmax;
else
    P = u;
end
end

