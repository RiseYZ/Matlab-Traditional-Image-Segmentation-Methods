function mask = activeContourModel(image, initialContour, alpha, beta, gamma, iterations)
    % activeContourModel - ���ڻ����ģ�͵�ͼ��ָ�
    %
    % ����:
    %   image          - ����Ҷ�ͼ��
    %   initialContour - ��ʼ���������Nx2�������Ϊ�����Զ�����
    %   alpha          - ��������ƽ���ȵĲ���
    %   beta           - �������������ȵĲ���
    %   gamma          - �����ƶ��Ĳ���
    %   iterations     - ��������
    %
    % ����ֵ:
    %   mask           - �ָ�����Ĥͼ��ѡ������Ϊ255������Ϊ0��
    
    % ���û���ṩ��ʼ������ʹ���Զ����������ɳ�ʼ����
    if isempty(initialContour)
        initialContour = generateInitialContour(image);
    end
    
    % ��ʼ��
    snakeContour = initialContour;
    [gx, gy] = gradient(double(image));
    
    for iter = 1:iterations
        % �����ڲ�����
        internalEnergy = computeInternalEnergy(snakeContour, alpha, beta);
        
        % �����ⲿ����
        externalEnergy = computeExternalEnergy(snakeContour, gx, gy);
        
        % ��������
        snakeContour = snakeContour - gamma * (internalEnergy + externalEnergy);
    end
    
    % ������Ĥͼ��
    mask = poly2mask(snakeContour(:, 1), snakeContour(:, 2), size(image, 1), size(image, 2)) * 255;
end

function initialContour = generateInitialContour(image)
    % generateInitialContour - ʹ�ñ�Ե����Զ����ɳ�ʼ����
    %
    % ����:
    %   image - ����Ҷ�ͼ��
    %
    % ����ֵ:
    %   initialContour - �Զ����ɵĳ�ʼ���������Nx2����
    
    % ��Ե���
    grayImage = rgb2gray(image);
    edges = edge(grayImage, 'Canny');
    
    % ��ȡ��ʼ����
    [B, ~] = bwboundaries(edges, 'noholes');
    
    % ѡ������������Ϊ��ʼ����
    if ~isempty(B)
        initialContour = B{1};
    else
        error('δ��⵽�κα�Ե�������������ʹ�������������ɳ�ʼ������');
    end
end

function internalEnergy = computeInternalEnergy(contour, alpha, beta)
    % computeInternalEnergy - �����ڲ�����
    %
    % ����:
    %   contour - ���������Nx2����
    %   alpha   - ��������ƽ���ȵĲ���
    %   beta    - �������������ȵĲ���
    %
    % ����ֵ:
    %   internalEnergy - �ڲ�������Nx2����
    
    n = size(contour, 1);
    a = circshift(contour, -1) - 2 * contour + circshift(contour, 1);
    b = circshift(contour, -2) - 4 * circshift(contour, -1) + 6 * contour - 4 * circshift(contour, 1) + circshift(contour, 2);
    internalEnergy = alpha * a + beta * b;
end

function externalEnergy = computeExternalEnergy(contour, gx, gy)
    % computeExternalEnergy - �����ⲿ����
    %
    % ����:
    %   contour - ���������Nx2����
    %   gx      - ͼ���ݶȵ�x����
    %   gy      - ͼ���ݶȵ�y����
    %
    % ����ֵ:
    %   externalEnergy - �ⲿ������Nx2����
    
    externalEnergy(:, 1) = interp2(gx, contour(:, 2), contour(:, 1));
    externalEnergy(:, 2) = interp2(gy, contour(:, 2), contour(:, 1));
end
