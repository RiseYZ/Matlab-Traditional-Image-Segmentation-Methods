function outputImage = openingOperation(inputImage, elementSize)
    %开运算是先腐蚀后膨胀的组合操作，主要用于去除小的噪声。
    
    % 创建结构元素
    structElement = strel('square', elementSize);
    % 开运算：先腐蚀后膨胀
    outputImage = imopen(inputImage, structElement);
end
