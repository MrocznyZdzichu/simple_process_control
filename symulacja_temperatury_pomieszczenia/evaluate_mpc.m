function [score] = evaluate_mpc(t, u)
u = u(t>200);
score = sum(abs(u));
end

