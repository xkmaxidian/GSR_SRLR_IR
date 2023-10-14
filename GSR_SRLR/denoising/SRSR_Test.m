function [im, Par, PSNR_Final, FSIM_Final, SSIM_Final, time_s] = SRSR_Test(dataset, filename, tail, Sigma)

filepath = [dataset, '/', filename, tail];
I = imread(filepath);
[h, w, ch] = size(I);
if ch == 3
    I = rgb2gray(I);
end

I = double(I);
randn ('seed',0);
nim = I + Sigma*randn(h, w);
ImageName = filename
fprintf('PSNR of the noisy image(sigma=%d) = %f \n', Sigma, csnr(nim, I, 0, 0));
imwrite(uint8(nim), strcat('./',num2str(Sigma),'_noise/', dataset, '_', ImageName, '_noise_', num2str(Sigma), '.png'));
    
Par = Par_Set(Sigma);
time0 = clock;
[All_PSNR, deimgs, iter] = SRSR_Denoising(nim, I, Par);
time_s = etime(clock, time0);

im = deimgs{iter};
PSNR_Final = csnr(im, I, 0, 0);
FSIM_Final = FeatureSIM(im, I);
SSIM_Final = cal_ssim(im, I, 0, 0);
% save(strcat('convergence', ImageName, '.mat'), "All_PSNR");

end