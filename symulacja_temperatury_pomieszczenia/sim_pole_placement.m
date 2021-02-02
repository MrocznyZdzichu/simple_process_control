function [t, y, u] = sim_pole_placement(times, system, SP, zakl, y0, p, T0, do_plot)
a = 3;
b = 7;
h = 3;
Ph = 3500;
c = 1005;
sig = 15;
den = 1.3;

pp_T = 18;
pp_Pz = 0;
pp_Pt = -60;

t0 = times(1);
t = t0;
y = y0;
u = [];

K = place(system.A,system.B,p);
K(2) = 0;

for i = 2:length(times)
    T0i = T0(i);
    Pz = zakl(i);
    ui = -1*K(1)*(y(i-1)-SP(i));
    ui = ui + pp_Pt;
    Pt = ac_power(Ph, ui);
    u = [u, Pt];
    dTdt = @(t, T) (Pz + Pt-sig*(T-T0i))/(a*b*h*c*den); 
    
    [tt, yy] = simulate_step(dTdt, t(i-1), times(i), y(i-1));
    t = [t, tt];
    y = [y, yy];
end
u = [u(1), u];
if do_plot == 1
    plot(t,y)
end
end

