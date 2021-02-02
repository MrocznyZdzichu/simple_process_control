function [u] = pid_(K, I, D, e, prev_e, sum_e)
u = K*(e + (I*sum_e) + D*(e - prev_e));
end

