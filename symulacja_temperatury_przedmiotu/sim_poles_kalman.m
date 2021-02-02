function [y, u, yest] = sim_poles_kalman(system, Q, R, k, noise_u, noise_y, x_est, times, Pz, SP, To)
[kest, L, P] = kalman(system, Q, R);
%tylko 1. wejscie jest sterujace
K = place(system.A, system.B(:, 1), k);

Ph = 5000;
pp_Pz = 0;
pp_Pt = -50;
pp_To = 22;
pp_T =[16.8061, 16.8106];

y0 = pp_T;
y = y0;
u = pp_Pt;

yest = pp_T(2);

for i = 2:length(times)
    ui = -K*x_est(:, end);
    ui = ui + pp_Pt;    
    Pt = ac_power(Ph, ui);
    Pt = Pt + noise_u*randn(1);
    u = [u, Pt];
    
    yi = step_sim(times(i-1), times(i), y(end,:), Pz(i), Pt, To(i));
    yi(2) = yi(2) + noise_y*randn(1);
    y = vertcat(y, yi);
    
    x_est = system.A*x_est ...                                   
        + system.B*([ui-pp_Pt; To(i) - pp_To])...
        + L*(yi(1)-SP(i, 1) - system.C*x_est);                       
    yest = [yest, x_est(2)+pp_T(2)];
end
end

