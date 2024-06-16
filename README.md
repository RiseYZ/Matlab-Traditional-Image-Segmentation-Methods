# Matlab-Traditional-Image-Segmentation-Methods
青岛大学（QDU） 数字图像处理 课程实验
## 青岛大学 数字图像处理 课程实验(Matlab)

### 图像分割算法代码目录



#### 主要分割算法

1、阈值分割

2、区域生长

3、区域分裂与合并

4、边缘检测

5、分水岭分割

6、活动轮廓图

7、图割算法

8、K均值聚类

9、高斯混合模型

10、马尔科夫随机场

11、U-Net



#### 目录结构

```
7th-ImageSegment    // 项目目录
├─data				// 数据集:测试集原始图像,对应灰度图像,标签
│  ├─test
│  ├─gray_test
│  └─label
├─deep_learn		// 深度学习模型:U-Net，该模型单独由unet.m文件执行
├─function			// 工具函数目录
├─pred_result		// 各模型预测结果,每一各模型对应一个结果目录,存放分割的掩膜(二值图像)
├─seg_algorithm		// 各个分割算法具体函数实现
└─run.m				// 项目执行脚本文件,所有的传统分割算法在该文件执行,预测结束后自动评估dice与iou
```



#### 实验数据集说明

本实验所使用的数据集为 **ISIC 2016** ，该数据集是**皮肤病变图像**的分割数据集，其中训练集约有900张图像，测试集约有350张图像。因为传统图像分割算法大多是无监督模型，所以**我们仅选择了其中的900张训练集图像作为我们实验的数据集**（我们没有使用全部的图像，最开始仅仅只是为了简单起见就拿了其中的900张）。而U-Net模型是把这900张图像按照6:2:2划分成训练集，验证集和测试集

#### 运行前说明
你需要下载对应的数据集并且按照上述目录结构保存


#### run.m 执行脚本

开始运行前请把matlab的运行目录位于项目目录(7th-ImageSegment)下, 否则会出现路径的引用错误

所有的传统分割算法由该文件执行,您只需修改变量 **method(于24行)** 所对应的字符串值即可

**method** 的合法取值由下方的 **switch … case …(于39行)** 语句的case条件决定

```matlab
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



```

