clc
close all
clear all


% 讲其他目录添加到路径，以便在该函数中调用其他目录中的函数（include）
addpath('./function');
addpath('./seg_algorithm');



% 给定数据集路径（RGB和灰度图像自行选择）
% test_folder = './data/test';    %RGB
test_folder = './data/gray_test';    %灰度图像

% 获取测试集文件列表
test_files = dir(fullfile(test_folder, '*.bmp')); 
% 初始化结果数组
num_files = length(test_files);


% 该变量控制执行的算法名称
% 如果要增加算法，请修改该变量的值，并在下方switch处添加对应语句
method = 'K_means';

nums = num_files;

%统计运行时间：开始
tic;

% 遍历文件并计算指标
for i = 1:nums
    clc
    fprintf('Schedule: %d / %d\n', i, nums);
    % 读取测试集图像
    image = imread(fullfile(test_folder, test_files(i).name));
    
    % 调用对应的分割算法（请注意分割函数的返回值统一为分割后的掩膜：选中的区域为255，其余为0）
    switch method
        case 'threshold_seg'
            mask = threshold_seg(image, 0.6);
        case 'K_means'
            mask = K_means(image);
        case 'region_grow'
            mask = region_grow(image);
        case 'SA_segmentation'
            true_folder = strcat('./data/label/Y_img_',int2str(i),'.bmp');
            lab = imread(true_folder);
            mask = SA_segmentation(image,lab);
        case 'GMM'
            mask = GMM(image, 2);
        case 'improvedGMM1'
            mask = improvedGMM1(image, 2);
        case 'improvedGMM2'
            mask = improvedGMM2(image, 2);
        case 'MRF'
            mask = MRF(image, 2, 20);
        case 'improvedMRF1'
            mask = improvedMRF1(image, 2, 20);
        case 'activecontour' %第二个参数需要传入初始轮廓模型，传空则自动确定，否则需要提供初始轮廓
            tmpmask = zeros(size(image));
            tmpmask(25:end-25,25:end-25) = 1;
            mask = activecontour(image,tmpmask,300);
        case 'splitAndMerge' 
            minsize = 8;
            threshold = 10;
            mask = splitAndMerge(image,2,@predicate);
        case 'graphCut' 
            mask = graphCut(image,20,20,20,20,5,'_');
        case 'graphCut+GMM' 
            mask = graphCut(image,20,20,20,20,10,'improvedGMM1');
        case 'graphCut+activecontour' 
            mask = graphCut(image,20,20,20,20,10,'activecontour');
        case 'graphCut+splitAndMerge' 
            mask = graphCut(image,20,20,20,20,10,'splitAndMerge');
        case 'edgedet_seg'
            mask = edgedet_seg(image);
        case 'watershed_seg'
            mask = watershed_seg(image);
        otherwise
            print('无效输入');
            exit;
    end
    
    % 检查 pred_result 目录是否存在，如果不存在，则创建
    if ~exist('./pred_result', 'dir')
       mkdir('./pred_result');
    end

    % 检查 method 对应的目录是否存在，如果不存在，则创建
    method_dir = sprintf('./pred_result/%s', method);
    if ~exist(method_dir, 'dir')
       mkdir(method_dir);
    end

    % 现在可以安全地保存图像了
    imwrite(mask, sprintf('%s/%s', method_dir, test_files(i).name));
    
end

% 统计运行时间：结束
run_time = toc;

[dice, iou] = evaluate(sprintf('./pred_result/%s', method));

fprintf('The evaluation of %s:\n', method);
fprintf('Elapsed time: %.4f seconds\n', run_time);
fprintf('Dice: %.4f\n', dice);
fprintf('IOU: %.4f\n', iou);

