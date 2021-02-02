function [y, u] = sim_PID(K, I, D, To, y0, SP, zakl, times)
a = 3;
b = 7;
h = 3;
Ph = 3500;
c = 1005;
sig = 15;
den = 1.3;

pp_Pt = -60;
pp_Pz = 0;
pp_T = 18;

sum_e = 0;
prev_e = 0;
u = 0;
y = y0;
for i = [2: length(times)]
    e = SP(i) - y(end);
    if u(end) > -1*Ph && u(end) < Ph 
        sum_e = sum_e + e;
    end
    
    ui = pid_(K, I, D, e, prev_e, sum_e);
    ui = ac_power(Ph, ui+pp_Pt);
    u = [u, ui+pp_Pt];
    prev_e = e;
    
    T0i = To(i);
    Pz = zakl(i);
    Pti = u(end);
    dTdt = @(t, T) (Pz + Pti - sig*(T-T0i))/(a*b*h*c*den); 
 
    [tt, yy] = simulate_step(dTdt, times(i-1), times(i), y(end));
    y = [y, yy];
end
end

