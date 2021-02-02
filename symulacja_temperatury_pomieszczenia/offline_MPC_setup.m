function [PSI, LAMBDA, M, CtAt, CtV] = offline_MPC_setup(system, ndi, p, m, psi, lambda)
M = dynamicMatrix(p, m, system.A, system.B(1:ndi), system.C);

psi_vec = [];
for i = 1:p
    psi_vec = [psi_vec, diag(psi)];
end
PSI = diag(psi_vec);

lambda_vec = [];
for i = 1:m
    lambda_vec = [lambda_vec, diag(lambda)];
end
LAMBDA = diag(lambda_vec);

[CtAt,CtV]=MPCSmatrices(system.A, system.B(1:ndi), system.C,p,m);
end