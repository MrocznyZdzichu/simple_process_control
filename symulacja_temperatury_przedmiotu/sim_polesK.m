function [y, u] = sim_polesK(times, y, K, SP, Pz, To, noise_u, noise_y)
pp_Pt = -50;
pp_T =[16.8061, 16.8106];
Ph = 5000;
u = pp_Pt;

for i = 2:length(times)
%     we wspolrzednych odchylek
    x = y(end, :) - SP(i,:);
    ui = -K*x';
%     we wspolrzednych absolutnych
    Pt = ui +pp_Pt;
    Pt = ac_power(Ph, Pt);
    Pt = Pt + noise_u*randn(1);
    u = [u, Pt];
    
    yi = step_sim(times(i-1), times(i), y(end,:), Pz(i), Pt, To(i));
    yi(2) = yi(2) + noise_y*randn(1);
    y = vertcat(y, yi);
end
end

