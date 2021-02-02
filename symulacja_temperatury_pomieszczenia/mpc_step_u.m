function [du] = mpc_step_u(SP, step, p, m, system, ndi, y0, PSI, LAMBDA, M, CtAt, CtV, u)
    yzad = [SP(step:step+p-1)]';
    Y = CtAt*y0 + CtV*system.B(1:ndi)*u;
    
    K = ((M'*PSI*M+LAMBDA)^(-1))*M'*PSI;
    
    input_no = size(K,1)/m;
    dui = K*(yzad-Y);
    du = dui(1:input_no,:);
end
