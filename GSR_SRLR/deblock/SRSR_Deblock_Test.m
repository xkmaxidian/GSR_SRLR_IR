function [QC_Re, Par, JPEG_PSNR, PSNR_Final, FSIM_Final, SSIM_Final, time_s] = SRSR_Deblock_Test(dataset, filename, tail, JPEG_Quality, is_resize)

filepath = [dataset, '/', filename, tail];
I = imread(filepath);
if is_resize
    I = imresize(I, [256, 256]);
end
colorI = I;
[~, ~, ch] = size(I);
if ch == 3
    I = rgb2gray(I);
    y_yuv = rgb2ycbcr(colorI);
    x_2_yuv(:,:,2) = y_yuv(:,:,2); %Copy U Component
    x_2_yuv(:,:,3) = y_yuv(:,:,3); %Copy V Component
end

randn ('seed',0);
I = double(I);
jpeg_name = strcat(filename, '_jeg_q', num2str(JPEG_Quality));
jpeg_path = strcat('JQ_',  num2str(JPEG_Quality), '/', dataset, '_', jpeg_name, '.jpg');
imwrite(uint8(I), jpeg_path, 'Quality', JPEG_Quality);
JPEG_Image = imread(jpeg_path);
nim = double(JPEG_Image);

ImageName = filename
JPEG_PSNR = csnr(nim, I, 0, 0);
fprintf('PSNR of the JPEG noisy image(JQ=%d) = %f \n', JPEG_Quality, JPEG_PSNR);

Par = Deblock_Par_Set(JPEG_Quality);
JPEG_header_info = jpeg_read(jpeg_path);
Par.QTable = JPEG_header_info.quant_tables{1};
Par.blockSize = 8;
[m, n] = size(nim);
m_ = 8 - mod(m, 8);
n_ = 8 - mod(n, 8);
if(m_ == 8)
    m_ = 0;
end
if(n_ == 8)
    n_ = 0;
end
nim = padarray(nim, [m_, n_], 'replicate','post');
Par.C_q = blkproc(nim, [8, 8], 'dct2');
if(m_ >= 1)
    nim(m+1:m+m_, :) = [];
end
if(n_ >= 1)
    nim(:, n+1:n+n_) = [];
end
meanQuant = mean(mean(Par.QTable(1:3,1:3)));
Par.nSig = sqrt(0.69*meanQuant^1.3);

time0 = clock;
[All_PSNR, deimgs, iter] = SRSR_Deblock_Denoising(nim, I, Par, m_, n_);
time_s = etime(clock, time0);

im = deimgs{iter};
PSNR_Final = csnr(im, I, 0, 0);
FSIM_Final = FeatureSIM(im, I);
SSIM_Final = cal_ssim(im, I, 0, 0);

if ch == 3
    x_2_yuv(:,:,1) = uint8(im);
    QC_Re = ycbcr2rgb(uint8(x_2_yuv));
else
    QC_Re = uint8(im);
end
save(strcat('convergence', ImageName, '.mat'), "All_PSNR");
end