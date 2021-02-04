function [y, u] = sim_lqr(plant, conditions, Q, R, u0, y0, x0)
%LQR setup
u = u0;
y = y0;
x = x0;
K = lqr(plant.system.A, plant.system.B, Q, R);

for i = 2:length(conditions.times)
    dui = -K*x(:, i-1);
    ui = dui + plant.pp_Pt;
    ui = ac_power(plant.Ph, ui);
    ui = ui + conditions.noise_u*randn(1);
    u = [u, ui];
    
    yi = step_sim(conditions.times(i-1)...
                    , conditions.times(i)...
                    , y(:, i-1)...
                    , conditions.Pz(i)...
                    , ui ...
                    , conditions.To(i));
    yi(2) = yi(2) + conditions.noise_y*randn(1);
    y = [y, yi'];
    
    xi = yi' - [conditions.SP(i); conditions.SP(i)] ;
    x = [x, xi];
end
end

