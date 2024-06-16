function outputImage = closingOperation(inputImage, elementSize)
    % 闭运算是先膨胀后腐蚀的组合操作，主要用于填充小的空洞。

    % 创建结构元素
    structElement = strel('square', elementSize);
    % 闭运算：先膨胀后腐蚀
    outputImage = imclose(inputImage, structElement);
end
