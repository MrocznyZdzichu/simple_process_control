function [y, u] = sim_Kpoles_obs(times, y, system, K, L, SP, Pz, To, est_x, noise_u, noise_y)
pp_Pt = -50;
pp_T =[16.8061, 16.8106];
Ph = 5000;
u = pp_Pt;

for i = 2:length(times)
    %wspolrzedne odchylek
    yi = (y(end, :) - SP(i, :))';
    ui = -K*est_x;
    est_x = system.A*est_x ...      %dynamika obiektu
        + system.B(:, 1)*ui ...     %sterowanie
        + L*system.C*(yi - est_x);  %korekta estymacji
    
    %sterowanie w punkcie pracy
    ui = ui + pp_Pt;    
    Pt = ac_power(Ph, ui);
    Pt = Pt + noise_u*randn(1);
    u = [u, Pt];
    
    yi = step_sim(times(i-1), times(i), y(end,:), Pz(i), Pt, To(i));
    yi(2) = yi(2) + noise_y*randn(1);
    y = vertcat(y, yi);
end
end

