clear;

% dataset = 'Test_Images';
dataset = 'Set12';

if strcmp(dataset, 'Test_Images')
    file_names = {'Barbara', 'boats', 'foreman', 'Leaves', ...
                  'lena', 'Miss', 'Monarch', 'peppers', ...
                  'plants', 'starfish', 'airplane', 'House', 'J.Bean'};
    file_num = 13;
    tail = '.tif';
elseif strcmp(dataset, 'Set12')
    file_names = {'01', '02', '03', '04', ...
                  '05', '06', '07', '08', ...
                  '09', '10', '11', '12'};
    file_num = 12;
    tail = '.png';
end

Sigma_Num = [20, 30, 40, 50, 75, 100];

for i = 1 : 5
    for j = 1 : file_num
        Sigma = Sigma_Num(i);
        filename = file_names{j};
        [im, Par, PSNR_Final, FSIM_Final, SSIM_Final, time_s] = SRSR_Test(dataset, filename, tail, Sigma);
        
        Final_denoising = strcat(dataset, '_', filename,'_SRSR','_sigma_',num2str(Sigma),'_PSNR_',num2str(PSNR_Final),'_SSIM_',num2str(SSIM_Final),'.png');
        % imwrite(uint8(im), strcat('./',num2str(Sigma),'_Result/',Final_denoising));
        imwrite(uint8(im), strcat('./','realResult/',Final_denoising));
        
        s = strcat('A', num2str(j));
        res_data = {filename, Sigma, Par.omega, Par.tau, PSNR_Final, FSIM_Final, SSIM_Final, time_s};
        xlswrite(strcat(dataset, '_SRSR_Sigma_',num2str(Sigma),'_Final.xls'), res_data, 'sheet1', s);
    end
end