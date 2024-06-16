function segmented_mask = adjustGMMLabels(segmented_mask)
    img_size = size(segmented_mask);

    % 获取图像中心点的标签
    center_label = segmented_mask(floor(img_size(1)/2), floor(img_size(2)/2));
    
    % 如果中心点的标签不是2，则交换标签1和2
    if center_label ~= 2
        segmented_mask(segmented_mask == 1) = 3;
        segmented_mask(segmented_mask == 2) = 1;
        segmented_mask(segmented_mask == 3) = 2;
    end
end
