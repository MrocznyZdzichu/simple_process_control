function [dynamicMatrix] = dynamicMatrix(horizPred, horizControl, A, B, C)
column = [];
for i = 1:horizPred
    factor = eye(size(A, 1));
    for j = 2:i
        factor = factor + A^(j-1);
    end
    column = [column; C*factor*B];
end
dynamicMatrix = column;
for i = 1:horizControl-1
    new_column = column(1:end-i*size(A,1),:);
    new_column = [zeros(i*size(A, 1), size(A, 2)); new_column];
    dynamicMatrix = [dynamicMatrix, new_column];
end