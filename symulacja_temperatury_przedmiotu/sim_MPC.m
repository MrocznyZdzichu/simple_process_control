function [y, u] = sim_MPC(plant, conditions, Ny, Nu, psi, lambda, u0, y0)
u = u0;
y = y0;

ACell = repmat({psi}, 1, Ny);
Psi = blkdiag(ACell{:});

ACell = repmat({lambda}, 1, Nu);
Lambda = blkdiag(ACell{:});
clear ACell;

[CA, CV, M] = MPCSmatrices(plant.system.A...
                            ,plant.system.B(:, 1)...
                            ,plant.system.C...
                            ,Ny, Nu);
  
K = ((M'*Psi*M+Lambda)^-1)*M'*Psi;

for i = 2:length(conditions.times)
    xi = y(:, end) - plant.pp_T';
    prev_du = u(end) - plant.pp_Pt;
    prev_To = conditions.To(i-1) - plant.pp_To;
    Y0i = CA*xi + CV*plant.system.B(:,1)*prev_du + CV*plant.system.B(:, 2)*prev_To;
    Y0i = Y0i + plant.pp_T(2);
    
    deltaui = K*(conditions.SP(i) - Y0i);
    ui = u(end) + deltaui(1);
    ui = ac_power(plant.Ph, ui);
    ui = ui + conditions.noise_u*randn(1);
    
    T = step_sim(conditions.times(i-1),conditions.times(i), y(:, end), conditions.Pz(i), ui, conditions.To(i));
    T(2) = T(2) + conditions.noise_y*randn(1);
    y = [y, T'];
    u = [u, ui];
end
end

