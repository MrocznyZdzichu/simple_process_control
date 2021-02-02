function [y, u] = sim_MPC(ssd_system, ndi, umin, umax, p, m, psi, lambda, times, zakl, y0, SP, T0)
a = 3;
b = 7;
h = 3;
Ph = 3500;
Pc = 3500;
c = 1005;
sig = 15;
den = 1.3;

pp_Pt = -60;
pp_Pz = 0;
pp_T = 18;
pp_T0 = 22;

[PSI, LAMBDA, M, CtAt, CtV] = offline_MPC_setup(ssd_system, ndi, p, m, psi, lambda);

u = 0;
y = y0;

for i = 2:length(times)
    du = mpc_step_u(SP, i, p, m, ssd_system, ndi, y(:,end), PSI, LAMBDA, M, CtAt, CtV, u(end));
    ui = u(end)+du(1);
    if ui + pp_Pt > umax
        ui = 3500 - pp_Pt;
    elseif ui +pp_Pt < umin
        ui = -3500 - pp_Pt;
    end
    
    u = [u, ui];
%     fprintf('Przyrost sterowania to: %.2f. Sterowanie to: %.2f\n', du, ui)
    
    T0i = T0(i);
    Pz = zakl(i);
    Pti = ui+pp_Pt;
    dTdt = @(t, T) (Pz + Pti - sig*(T-T0i))/(a*b*h*c*den); 
    
    [tt, yy] = simulate_step(dTdt, times(i-1), times(i), y(end)+pp_T);
    y = [y, yy-pp_T];
end
end