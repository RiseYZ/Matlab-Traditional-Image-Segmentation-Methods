function outputImage = closeThenOpen(inputImage, openElementSize, closeElementSize)
    % 先闭运算后开运算的组合可以先填充小的空洞和连接断裂的细节，然后去除小的噪声点，适用于图像中存在小空洞和噪声的情况。
    % 图像中有较多空洞或断裂细节，但噪声较少,适合先进行闭运算再进行开运算。
    
    % 先闭运算
    closedImage = closingOperation(inputImage, closeElementSize);
    
    % 后开运算
    outputImage = openingOperation(closedImage, openElementSize);
end
