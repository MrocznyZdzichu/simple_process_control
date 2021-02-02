function [y, u] = sim_PID(K, I, D, To, y0, SP, Pz, times, windup, noise_u, noise_y)
pp_Pt = -50;
Ph = 5000;

sum_e = 0;
prev_e = 0;
u = 0;
y = y0;
for i = [2:length(times)]
    e = SP(i) - y(end, 2);
    
    ui = pid_(K, I, D, e, prev_e, sum_e)+pp_Pt;
    uii = ac_power(Ph, ui);
    uii = uii + noise_u*randn(1,1);
    u = [u, uii];
    
    prev_e = e;
    if windup == 1 && abs(u(end)) > Ph
        sum_e = sum_e + 0;
    else
        sum_e = sum_e + e;
    end
    Pt = u(end);
    
    yi = step_sim(times(i-1), times(i), y(end,:), Pz(i), Pt, To(i));
    yi = yi + noise_y*randn(1, 1);
    y = vertcat(y, yi);
end
end

