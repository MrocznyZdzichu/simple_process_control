function [t, y] = simulate_step(fun, t0, t, y0)

[tt, yy] = ode45(fun, [t0, t], y0);
t = tt(end);
y = yy(end);
end

