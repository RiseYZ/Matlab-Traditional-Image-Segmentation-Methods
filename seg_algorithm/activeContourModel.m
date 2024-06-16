function mask = activeContourModel(image, initialContour, alpha, beta, gamma, iterations)
    % activeContourModel - 基于活动轮廓模型的图像分割
    %
    % 参数:
    %   image          - 输入灰度图像
    %   initialContour - 初始轮廓坐标的Nx2矩阵，如果为空则自动生成
    %   alpha          - 控制轮廓平滑度的参数
    %   beta           - 控制轮廓弯曲度的参数
    %   gamma          - 轮廓移动的步长
    %   iterations     - 迭代次数
    %
    % 返回值:
    %   mask           - 分割后的掩膜图像（选中区域为255，其余为0）
    
    % 如果没有提供初始轮廓，使用自动化方法生成初始轮廓
    if isempty(initialContour)
        initialContour = generateInitialContour(image);
    end
    
    % 初始化
    snakeContour = initialContour;
    [gx, gy] = gradient(double(image));
    
    for iter = 1:iterations
        % 计算内部能量
        internalEnergy = computeInternalEnergy(snakeContour, alpha, beta);
        
        % 计算外部能量
        externalEnergy = computeExternalEnergy(snakeContour, gx, gy);
        
        % 更新轮廓
        snakeContour = snakeContour - gamma * (internalEnergy + externalEnergy);
    end
    
    % 创建掩膜图像
    mask = poly2mask(snakeContour(:, 1), snakeContour(:, 2), size(image, 1), size(image, 2)) * 255;
end

function initialContour = generateInitialContour(image)
    % generateInitialContour - 使用边缘检测自动生成初始轮廓
    %
    % 参数:
    %   image - 输入灰度图像
    %
    % 返回值:
    %   initialContour - 自动生成的初始轮廓坐标的Nx2矩阵
    
    % 边缘检测
    grayImage = rgb2gray(image);
    edges = edge(grayImage, 'Canny');
    
    % 提取初始轮廓
    [B, ~] = bwboundaries(edges, 'noholes');
    
    % 选择最大的轮廓作为初始轮廓
    if ~isempty(B)
        initialContour = B{1};
    else
        error('未检测到任何边缘，请调整参数或使用其他方法生成初始轮廓。');
    end
end

function internalEnergy = computeInternalEnergy(contour, alpha, beta)
    % computeInternalEnergy - 计算内部能量
    %
    % 参数:
    %   contour - 轮廓坐标的Nx2矩阵
    %   alpha   - 控制轮廓平滑度的参数
    %   beta    - 控制轮廓弯曲度的参数
    %
    % 返回值:
    %   internalEnergy - 内部能量的Nx2矩阵
    
    n = size(contour, 1);
    a = circshift(contour, -1) - 2 * contour + circshift(contour, 1);
    b = circshift(contour, -2) - 4 * circshift(contour, -1) + 6 * contour - 4 * circshift(contour, 1) + circshift(contour, 2);
    internalEnergy = alpha * a + beta * b;
end

function externalEnergy = computeExternalEnergy(contour, gx, gy)
    % computeExternalEnergy - 计算外部能量
    %
    % 参数:
    %   contour - 轮廓坐标的Nx2矩阵
    %   gx      - 图像梯度的x分量
    %   gy      - 图像梯度的y分量
    %
    % 返回值:
    %   externalEnergy - 外部能量的Nx2矩阵
    
    externalEnergy(:, 1) = interp2(gx, contour(:, 2), contour(:, 1));
    externalEnergy(:, 2) = interp2(gy, contour(:, 2), contour(:, 1));
end
