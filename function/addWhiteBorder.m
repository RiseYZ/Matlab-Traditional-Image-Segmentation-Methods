function padded_img = addWhiteBorder(img, pad_size)
    img = img / 255;
    
    % 创建一个填充后的图像，初始时全为白色（255）
    padded_img = ones(size(img) + 2 * pad_size) * 255;
    
    % 将原图像复制到填充后的图像中央
    padded_img(pad_size + 1:end - pad_size, pad_size + 1:end - pad_size) = img * 255;
end
