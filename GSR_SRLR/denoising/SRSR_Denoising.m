function [All_PSNR, Denoising, iter] = SRSR_Denoising(nim, I, Par)

Output = nim;
v = Par.nSig;

Denoising = cell(1, Par.Iter);
All_PSNR = zeros(1, Par.Iter);

for iter = 1:Par.Iter
    Output = Output + Par.gamma*(nim-Output);
    dif = Output - nim;
    vd = abs(v^2 - mean((mean(dif.^2))));
    if iter == 1
        Par.nSig = sqrt(vd);
    else
        Par.nSig = sqrt(vd)*Par.lamada;
    end

    [Tmp_Out] = SRSR_Update(Output, Par);
    Output = (nim + Par.omega*Par.nSig^2*Tmp_Out)/(1+Par.omega*Par.nSig^2);
    Denoising{iter} = Output;
    
    All_PSNR(iter) = csnr(Output, I, 0, 0);
    
    if iter > 1
        dif = norm(abs(Denoising{iter})-abs(Denoising{iter-1}), 'fro')/norm(abs(Denoising{iter-1}), 'fro');
    else
        dif = norm(abs(Denoising{iter})-abs(nim), 'fro')/norm(abs(nim), 'fro');
    end
    
    fprintf('Iteration %d : PSNR = %f,  sig = %f,  dif = %f \n', iter, All_PSNR(iter), Par.nSig, dif);
    if dif < Par.Error
        break;
    end

end

end