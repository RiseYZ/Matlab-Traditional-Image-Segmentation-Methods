function mask = threshold_seg(image, threshold)
    % 此为分割算法的案例
    % 对图像应用阈值分割
    mask = (image < threshold * 255) * 255;
end