function outputImage = openThenClose(inputImage, openElementSize, closeElementSize)
    % 先开运算后闭运算的组合可以有效去除小的噪声点，同时填补较小的空洞，适用于图像中存在噪声和小空洞的情况。
    % 图像中噪声较多，但空洞较少，适合先进行开运算再进行闭运算。
    
    % 先开运算
    openedImage = openingOperation(inputImage, openElementSize);
    % 后闭运算
    outputImage = closingOperation(openedImage, closeElementSize);
end
