function [x, y] = GridIndex_Calculate(location)
% ���룺ĳ����ľ�γ����Ϣ
% ������õ�����Ӧ��������(x,y)
% ˵����
% �涨ԭ������Ϊ(115.7 E��39.4 N)��ÿ������ĳ���Ϊ 100*(sqrt(2)/2)(m)

grid_size = 100 * (sqrt(2)/2);

temp1 = [ones(size(location,1),1)*115.7,location(:,2)];
temp2 = [location(:,1),ones(size(location,1),1)*39.4];
x_distance = Distance_Calculate(location,temp1);
y_distance = Distance_Calculate(location,temp2);

x_distance = x_distance * 1000;
y_distance = y_distance * 1000;

x = floor(x_distance / grid_size);
y = floor(y_distance / grid_size);

end

