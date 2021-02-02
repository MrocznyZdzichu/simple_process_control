function [t, y, zakl] = sim_manual_dist(times, ampl, y0, Pt, T0, do_plot)
a = 3;
b = 7;
h = 3;
Ph = 3500;
Pc = 3500;
c = 1005;
sig = 15;
den = 1.3;


zakl = cumsum(ampl*randn(1,length(times)));
t0 = times(1);
t = t0;
y = y0;

for i = 2:length(times)
    T0i = T0(i);
    Pz = zakl(i);
    Pti = Pt(i);
    dTdt = @(t, T) (Pz + Pti-sig*(T-T0i))/(a*b*h*c*den); 
    
    [tt, yy] = simulate_step(dTdt, t(i-1), times(i), y(i-1));
    t = [t, tt];
    y = [y, yy];
end
if do_plot == 1
    plot(t,y)
end
end

