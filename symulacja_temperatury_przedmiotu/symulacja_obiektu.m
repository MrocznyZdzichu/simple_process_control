%% Symulacja całościowa
sig = 15;
sig2 = 58;
m = 5;
c = 490;
a = 3;
b = 7;
h = 3;
Ph = 5000;
cp = 1005;
density = 1.3;
Pz = 0;
Pt = 100;
To = 20;

[t, y] = ode45(@(t, T) odefcn(t, T, sig, sig2, m, c, a, b, h, cp, density, Pz, Pt, To), [0, 360], [20, 12]);
plot(t, y)

%% Symulacja step by step
times = [0:15:20000];
ampl = 0;
Pz = 0*randn(1, length(times));
Pt = -50*ones(1, length(times));
To = 20*ones(1, length(times));
y0 = [22, 5];
y = y0;

for i = [2:length(times)]
   yi = step_sim(times(i-1), times(i), y(end,:), Pz(i), Pt(i), To(i));
   y = vertcat(y, yi);
end
plot(times, y);
legend('Temperatura pomieszczenia', 'Temperatura obiektu')

%znalezlismy przykladowy punkt pracy:
% pp_Pz = 0;
% pp_Pt = -50;
% pp_To = 22
% pp_T =[16.8061 16, 8106];

%% Linearyzacja modelu w punkcie pracy. Model w przestrzeni stanu
sig = 15;
sig2 = 58;
m = 5;
c = 490;
a = 3;
b = 7;
h = 3;
Ph = 5000;
cp = 1005;
density = 1.3;
Pz = 0;
Pt = 50;
To = 20;

a1 = -sig/(a*b*h*cp*density);
a2 = 0;
a3 = sig2/(m*c);
a4 = -sig2/(m*c);

b1 = 1/(a*b*h*cp*density);
b2 = 1/(a*b*h*cp*density);
b3 = sig/(a*b*h*cp*density);
b4 = 0;
b5 = 0;
b6 = 0;

A = [a1, a2; a3, a4];
B = [b1, b2, b3; b4, b5, b6];
C = [0, 1];
D = [0, 0, 0];

system = ss(A, B, C, D);