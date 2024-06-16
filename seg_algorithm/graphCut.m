function mask = graphCut(img, bagX1, bagY1, bagX2, bagY2,iterCnt,preMethod)
    % 输入参数:
    % img     - 输入图像
    % bagX1   - 矩形区域左边距离图像左边界的像素数
    % bagY1   - 矩形区域上边距离图像上边界的像素数
    % bagX2   - 矩形区域右边距离图像右边界的像素数
    % bagY2   - 矩形区域下边距离图像下边界的像素数
    % iterCnt - 迭代次数
    % preMethod -使用preMethon确定初始边界
    % 获取图像尺寸
    [height, width, ~] = size(img);
    
    % 计算矩形区域的坐标和尺寸
    x = bagX1 + 1;
    y = bagY1 + 1;
    roiWidth = width - bagX1 - bagX2;
    roiHeight = height - bagY1 - bagY2;
    premask = 0;
    
    
    
    % 检查矩形区域的有效性
    if roiWidth <= 0 || roiHeight <= 0
        error('Invalid rectangle dimensions. The specified rectangle is outside the image boundaries.');
    end
    L = superpixels(img,1000);
    % 初始化掩码
    ROI = false(height, width); % Initialize all to false
    ROI(y:y+roiHeight-1, x:x+roiWidth-1) = true; % ROI area to true
    switch preMethod
        case 'splitAndMerge' 
            minsize = 8;
            threshold = 10;
            premask = splitAndMerge(img,2,@predicate);
            
            %执行闭开开
            premask = closingOperation(premask,9);
            premask = openingOperation(premask,9);
            premask = openingOperation(premask,9);
            SE = strel('square', 9);
            
            % 对二值图像进行膨胀操作
            BW_dilated = imdilate(premask, SE);
            ROI(premask == 0) = false; % 将 BW 中值为 0 的位置在 ROI 中设为 false
            ROI(premask ~= 0) = true;  % 将 BW 中值不为 0 的位置在 ROI 中设为 true
        case 'improvedGMM1'
            premask = improvedGMM1(img, 2);
%             premask = keepLargestIsland(premask);
            SE = strel('square', 6);
            premask = openingOperation(premask,11);
            premask = openingOperation(premask,11);
            premask = openingOperation(premask,11);
            premask = openingOperation(premask,11);
            premask = closingOperation(premask,11);
            
            
            %填充一圈白色像素
            premask = addWhiteBorder(premask,1);
            if countWhiteIslands(premask) > 1
                premask = removeBorder(premask);
            end
            %将填充的像素还原
            premask = premask(2:end-1, 2:end-1);
            
            % 对二值图像进行膨胀操作
            premask = imdilate(premask, SE);
            
            ROI(premask == 0) = false; % 将 BW 中值为 0 的位置在 ROI 中设为 false
            ROI(premask ~= 0) = true;  % 将 BW 中值不为 0 的位置在 ROI 中设为 true
         case 'activecontour' %第二个参数需要传入初始轮廓模型，传空则自动确定，否则需要提供初始轮廓
            tmpmask = zeros(size(img));
            tmpmask(25:end-25,25:end-25) = 1;
            premask = activecontour(img,tmpmask,100);
            SE = strel('square', 9);
           
            % 对二值图像进行膨胀操作
            BW_dilated = imdilate(premask, SE);
        otherwise
            
    end
    
    
    % 使用 grabcut 进行图像分割
    BW = grabcut(img, L, ROI);
    for i = 2:iterCnt
        ROI(BW == 0) = false; % 将 BW 中值为 0 的位置在 ROI 中设为 false
        ROI(BW ~= 0) = true;  % 将 BW 中值不为 0 的位置在 ROI 中设为 true
        BW = grabcut(img,L,ROI);
    end
    % 创建最终掩码图像，选中部分为 1，未选中部分为 0
%     mask = uint8(BW);
        mask = BW;
        
        
     %如果效果一般就注释
%      addWhiteBorder(mask,1);
%      if countWhiteIslands(mask) > 1
%            mask = removeBorder(mask);
%      end
%      mask = mask(2:end-1, 2:end-1);
     
     
end
function img = removeBorder(img)
    % 获取图像的大小
    [rows, cols] = size(img);
    
    % 遍历图像的边界像素
    for i = 1:rows
        for j = 1:cols
            % 如果是边界像素且像素值不为0，则进行递归处理
            if (i == 1 || i == rows || j == 1 || j == cols) && img(i, j) ~= 0
                img = recursiveRemove(img, i, j);
            end
        end
    end
end

function img = recursiveRemove(img, row, col)
    % 将当前像素置为0
    img(row, col) = 0;
    
    % 定义相邻像素的偏移量
    offsets = [-1, 0; 1, 0; 0, -1; 0, 1];
    
    % 对当前像素的相邻像素进行递归处理
    for k = 1:size(offsets, 1)
        newRow = row + offsets(k, 1);
        newCol = col + offsets(k, 2);
        
        % 检查相邻像素是否在图像范围内且像素值不为0
        if newRow >= 1 && newRow <= size(img, 1) && newCol >= 1 && newCol <= size(img, 2) && img(newRow, newCol) ~= 0
            img = recursiveRemove(img, newRow, newCol);
        end
    end
end