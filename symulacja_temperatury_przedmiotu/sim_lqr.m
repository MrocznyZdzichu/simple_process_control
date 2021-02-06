function [y, u] = sim_lqr(plant, conditions, Q, R, u0, y0, x0, obs_type, obs_param)

if exist('obs_type') == 1
    if strcmp(obs_type,'Luenberg') == 1
        L = place(plant.system.A', plant.system.C', obs_param)';
    end
    if strcmp(obs_type, 'Kalman') == 1
        Qk = obs_param(1);
        Rk = obs_param(2);
        [~, L, ~] = kalman(plant.system, Qk, Rk); 
    end
end
%LQR setup
u = u0;
y = y0;
x = x0;
K = lqr(plant.system.A, plant.system.B(:, 1), Q, R);

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
    
    if exist('obs_type') == 0
        xi = yi' - [conditions.SP(i); conditions.SP(i)] ;
    end
    if exist('obs_type') == 1
        xi = plant.system.A*x(:, i-1) ...
            + plant.system.B * [dui; conditions.To(i) - plant.pp_To]...
            + L*(yi(1) - conditions.SP(i) - plant.system.C*x(:, i-1));
    end
    x = [x, xi];
end
end

