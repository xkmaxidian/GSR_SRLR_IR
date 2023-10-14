clear;
addpath(genpath('./jpegtbx_1.4'));

% dataset = 'Test_Images';
% dataset = 'LIVE1';
% dataset = 'classic5';
% dataset = 'Set5';
% dataset = 'Set14';
% dataset = 'Set12';
% dataset = 'fingerprint';
%dataset = 'BSD100';
dataset = 'Convergence';

if strcmp(dataset, 'Test_Images')
    file_names = {'Bahoon', 'Barbara', 'boats', 'couple', ...
                  'elaine', 'fingerprint', 'Goldhill', 'Lake', ...
                  'lena', 'pentagon', 'plants', 'starfish', 'straw'};
    file_num = 13;
    tail = '.tif';
    is_resize = false;
elseif strcmp(dataset, 'classic5')
    file_names = {'baboon', 'barbara', 'boats', 'lena', ...
                  'peppers'};
    file_num = 5;
    tail = '.bmp';
    is_resize = false;
elseif strcmp(dataset, 'LIVE1')
    file_names = {'bikes', 'building2', 'buildings', 'caps', 'carnivaldolls', 'cemetry', ...
                  'churchandcapitol', 'coinsinfountain', 'dancers', 'flowersonih35', 'house', 'lighthouse2', ...
                  'lighthouse3', 'manfishing', 'monarch', 'ocean', 'paintedhouse', 'parrots', ...
                  'plane', 'rapids', 'sailing1', 'sailing2', 'sailing3', 'sailing4', ...
                  'statue', 'stream', 'studentsculpture', 'woman', 'womanhat'};
    file_num = 29;
    tail = '.bmp';
    is_resize = false;
elseif strcmp(dataset, 'Set5')
    file_names = {'baby_GT', 'bird_GT', 'butterfly_GT', 'head_GT', ...
                  'woman_GT'};
    file_num = 5;
    tail = '.bmp';
    is_resize = false;
elseif strcmp(dataset, 'Set14')
    file_names = {'baboon', 'barbara', 'bridge', 'coastguard', 'comic', 'face', 'flowers', ...
                  'foreman', 'lenna', 'man', 'monarch', 'pepper', 'ppt3', 'zebra'};
    file_num = 14;
    tail = '.bmp';
    is_resize = false;
elseif strcmp(dataset, 'Set12')
    file_names = {'01', '02', '03', '04', '05', '06', '07', ...
                  '08', '09', '10', '11', '12'};
    file_num = 12;
    tail = '.png';
    is_resize = false;
elseif strcmp(dataset, 'fingerprint')
    file_names = {'f0001_01', 'f0002_05', 'f0003_10', 'f0004_05', 'f0005_03', 'f0006_09', 'f0007_09', 'f0008_10'};
    file_num = 8;
    tail = '.png';
    is_resize = false;
elseif strcmp(dataset, 'BSD100') 
    file_num = 100;
    tail = '.jpg';
    file_names = cell(1, file_num);
    files = dir(fullfile('./BSD100',['*' tail]));
    len1 = size(files,1);
    for i=1:len1
        file_names{i} = files(i).name(1:end-4);
    end
    is_resize = false;
else
    file_names = {'06', '03', '04', '05', '07'};
    file_num = 5;
    tail = '.png';
    is_resize = false;
end

JPEG_Quality_Num = [10, 20, 30, 40];

for i = 1:1
    for j = 1:1
        JPEG_Quality = JPEG_Quality_Num(i);
        filename = file_names{j};
        [im, Par, JPEG_PSNR, PSNR_Final, FSIM_Final, SSIM_Final, time_s] = SRSR_Deblock_Test(dataset, filename, tail, JPEG_Quality, is_resize);
        
        Final_denoising = strcat(dataset, '_', filename,'_SRSR','_JQ_',num2str(JPEG_Quality),'_PSNR_',num2str(PSNR_Final),'_SSIM_',num2str(SSIM_Final),'.png');
        imwrite(uint8(im), strcat('./JQ_',num2str(JPEG_Quality),'_Result/',Final_denoising));
        
        s = strcat('A', num2str(j));
        res_data = {filename, JPEG_Quality, JPEG_PSNR, Par.omega, Par.tau, PSNR_Final, FSIM_Final, SSIM_Final, time_s};
        xlswrite(strcat(dataset, '_SRSR_JPEG_Quality_',num2str(JPEG_Quality),'_Final.xls'), res_data, 'sheet1', s);
    end
end