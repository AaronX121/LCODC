tic;
Device_Weight = zeros(size(new_Dataset,1),1); % Ԥ�����ڴ�

Maximum_Distance = 5; % �������ĵĽ��հ뾶Ϊ500m
t_weight = 0; % ���ڼ�¼�����豸Ȩֵ���м����

for i = 1 : size(new_Dataset,1)
    
    [x_temp,y_temp] = GridIndex_Calculate(new_Dataset{i,1}.Location);
    
    for j = 1 : size(centroids,1)
        temp = abs(x_temp-centroids(j,1)) + abs(y_temp-centroids(j,2)); % �������j���������ĵ������پ���
        t_weight = t_weight + size(find(temp <= Maximum_Distance),1); % ͳ������С�ڽ��հ뾶�ĵ����
    end
    
    Device_Weight(i,1) = t_weight; % ��ֵ
    t_weight = 0; % ����
        
end
toc;