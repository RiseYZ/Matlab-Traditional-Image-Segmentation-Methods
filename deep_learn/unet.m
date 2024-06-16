clc;
close all;
clear all;

addpath('./function');

% 数据集路径更新
imageDir = './data/test';
labelDir = './data/label';

% 类别名称和标签ID
classNames = ["objective","background"];
labelIDs   = [255, 0];

% 创建图像和像素标签的数据存储器
imds = imageDatastore(imageDir);
pxds = pixelLabelDatastore(labelDir, classNames, labelIDs);

% 分割数据集为训练集、验证集和测试集: 6:2:2
[imdsTrain, imdsVal, imdsTest, pxdsTrain, pxdsVal, pxdsTest] = partition_data(imds, pxds, labelIDs);

% 网络结构参数
imageSize = [192 256 3];
numClasses = 2;
lgraph = unetLayers(imageSize, numClasses);

% 训练选项
options = trainingOptions('sgdm', ...
    'InitialLearnRate', 1e-3, ...
    'MaxEpochs', 20, ...
    'MiniBatchSize', 8, ...
    'VerboseFrequency', 10, ...
    'Plots', 'training-progress', ...
    'ValidationData', combine(imdsVal, pxdsVal), ...
    'ValidationFrequency', 5);

% 训练网络
dsTrain = combine(imdsTrain, pxdsTrain);
net = trainNetwork(dsTrain, lgraph, options);


% 对imdsTest中的每一张图像进行逐个预测
numTestImages = numel(imdsTest.Files);
predResultDir = './pred_result/U-Net';
for i = 1:numTestImages
    % 读取图像
    image = readimage(imdsTest, i);
    % 执行语义分割
    pred = predict(net, image);
    mask = unetpred2mask(pred);
    % 构建预测结果的文件路径
    [~, filename, ~] = fileparts(imdsTest.Files{i});
    predictedImageName = fullfile(predResultDir, strcat(filename, '.bmp'));
    % 将预测结果写入文件
    imwrite(mask, predictedImageName);
end

% 评估
[dice, iou] = unet_evaluate();

fprintf('Dice: %.4f\n', dice);
fprintf('IOU: %.4f\n', iou);

