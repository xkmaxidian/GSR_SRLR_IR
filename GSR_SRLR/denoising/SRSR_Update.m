function [Imout] = SRSR_Update(InputImage, Par)

[H, W] = size(InputImage);
Region = 25;
patch = Par.patch;
step = Par.step;
Patchsize = patch*patch;
N = H-patch+1;
M = W-patch+1;
L = N*M;
row = 1:step:N;
row = [row, row(end)+1:N];
col = 1:step:M;
col = [col, col(end)+1:M];
Groupset = zeros(Patchsize, L, 'single');
cnt = 1;

for i = 1:patch
    for j = 1:patch
        Patch = InputImage(i:H-patch+i, j:W-patch+j);
        Patch = Patch(:);
        Groupset(cnt, :) = Patch';
        cnt = cnt + 1;
    end
end

GroupsetT = Groupset';
I = (1:L);
I = reshape(I, N, M);
NN = length(row);
MM = length(col);

Imgtemp = zeros(H, W);
Imgweight = zeros(H, W);

Sim = Par.Sim;
nSig = Par.nSig;
omega = Par.omega;
tau = Par.tau;
c1 = Par.c1;
c2 = Par.c2;
p = Par.p;

parfor i = 1:NN
    Array_Patch = zeros(patch, patch, Sim);
    Imgtemp_Tmp = zeros(H, W);
    Imgweight_Tmp = zeros(H, W);
    row_tmp = row;
    col_tmp = col;
    Groupset_Tmp = Groupset;
    for j = 1:MM
        currow = row_tmp(i);
        curcol = col_tmp(j);
        off =  (curcol-1)*N + currow;
        Patchidx = Similar_Search(GroupsetT, currow, curcol, off, Sim, Region, I);
        curArray = Groupset_Tmp(:, Patchidx);
        
        M_temp = repmat(mean(curArray, 2), 1, Sim);
        curArray = curArray-M_temp;
        D = getpca(curArray);
        A0 = D'*curArray;
        
        cc = mean(A0.^2, 2);
        cc = max(0, cc-nSig^2);
        cc = sqrt(cc);
        eta = 2*c2*sqrt(2)*nSig^2./(cc.^2 + eps);
        lamda = 2*c1*sqrt(2)*nSig^2./(cc + eps);
        [~, S, V] = svd(A0, "econ");
        Z = V*nu_soft(S, tau*mean(cc))*V';
        
        I_Z = eye(size(Z));
        eta = repmat(eta, 1, Sim);
        Delta = eta.*(A0*(I_Z-Z-Z'+Z*Z'));
        t = 1./(omega + eta*norm(I_Z-Z, 2)^2);
        A0 = A0-t.*Delta;
        
        A = A0;
        mu = t(:, 1).*lamda;
        for ii = 1:Patchsize
            for jj = 1:Sim
                A(ii, jj) = GST(A0(ii, jj), mu(ii), p, 1);
            end
        end

        curArray = D*A + M_temp;
        
        for k = 1:Sim
            Array_Patch(:, :, k) = reshape(curArray(:, k), patch, patch);
        end
        
        for k = 1:length(Patchidx)
            RowIndx = ComputeRowNo(Patchidx(k), N);
            ColIndx = ComputeColNo(Patchidx(k), N);
            Imgtemp_Tmp(RowIndx:RowIndx+patch-1, ColIndx:ColIndx+patch-1) = Imgtemp_Tmp(RowIndx:RowIndx+patch-1, ColIndx:ColIndx+patch-1) + Array_Patch(:,:,k)';
            Imgweight_Tmp(RowIndx:RowIndx+patch-1, ColIndx:ColIndx+patch-1) = Imgweight_Tmp(RowIndx:RowIndx+patch-1, ColIndx:ColIndx+patch-1) + 1;
        end

    end

    Imgtemp = Imgtemp + Imgtemp_Tmp;
    Imgweight = Imgweight + Imgweight_Tmp;

end

Imout = Imgtemp./(Imgweight+eps);

end