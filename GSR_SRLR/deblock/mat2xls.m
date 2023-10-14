dataset = 'BSD100';
JPEG_Quality = 10;
load('BSD100_SRSR_JPEG_Quality_10_Final.mat');
for i=1:size(res_data, 2)
    s = strcat('A', num2str(i));
    xlswrite(strcat(dataset, '_SRSR_JPEG_Quality_',num2str(JPEG_Quality),'_Final.xls'), res_data{i}, 'sheet1', s);
end