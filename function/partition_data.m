function [imdsTrain, imdsVal, imdsTest, pxdsTrain, pxdsVal, pxdsTest] = partition_data(imds, pxds, labelIDs)
    % 计算每个数据集的数量
    numFiles = numel(imds.Files);
    numTrain = round(0.6 * numFiles);
    numVal = round(0.2 * numFiles);
    
    % 按顺序分割数据集
    imdsTrainFiles = imds.Files(1:numTrain);
    imdsValFiles = imds.Files(numTrain+1:numTrain+numVal);
    imdsTestFiles = imds.Files(numTrain+numVal+1:end);
    
    pxdsTrainFiles = pxds.Files(1:numTrain);
    pxdsValFiles = pxds.Files(numTrain+1:numTrain+numVal);
    pxdsTestFiles = pxds.Files(numTrain+numVal+1:end);
    
    % 创建训练集、验证集和测试集的数据存储器
    imdsTrain = imageDatastore(imdsTrainFiles);
    imdsVal = imageDatastore(imdsValFiles);
    imdsTest = imageDatastore(imdsTestFiles);
    
    pxdsTrain = pixelLabelDatastore(pxdsTrainFiles, pxds.ClassNames, labelIDs);
    pxdsVal = pixelLabelDatastore(pxdsValFiles, pxds.ClassNames, labelIDs);
    pxdsTest = pixelLabelDatastore(pxdsTestFiles, pxds.ClassNames, labelIDs);
end
