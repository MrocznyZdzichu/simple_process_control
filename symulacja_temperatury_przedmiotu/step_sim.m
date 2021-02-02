function T = step_sim(t0, t, T0, Pz, Pt, To)
sig = 15;           %wspolczynnik przewodzenia ciepla miedzy pomieszczeniem a otoczeniem
sig2 = 58;          %wspolczynnik przewodzenia ciepla dla stali
m = 20;             %masa stalowego obiektu
c = 490;            %cieplo wlasciwe stali
a = 3;              %
b = 7;              %   wymiary pomieszczenia
h = 3;              %
Ph = 5000;          %maksymalna moc klimatyzatora (grzenie i chlodzenie)
cp = 1005;          %cieplo wlasciwe powietrza
density = 1.3;      %gestosc powietrza
tspan = [t0, t];

[t, T] = ode45(@(t, T) odefcn(t, T, sig, sig2, m, c, a, b, h, cp, density, Pz, Pt, To), tspan, T0);
T = T(end,:);
end

