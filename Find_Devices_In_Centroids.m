% �ú��������ҳ����������Ľ��շ�Χ�ڵ������豸���

function [Dump_Car_List] = Find_Devices_In_Centroids(Current_Car_Grid_Index, centroids)

Maximum_Distance = 5;

Dump_Car_List = [];
for i = 1 : size(centroids,1)
    Distance_Matrix = abs(Current_Car_Grid_Index(:,1) - centroids(i,1)) + abs(Current_Car_Grid_Index(:,2) - centroids(i,2)); % ����ÿ�������豸����i���������ĵ������پ���
    temp_list = find(Distance_Matrix <= Maximum_Distance); % �ҳ�����С���������Ľ��վ���������豸���
    Dump_Car_List = [Dump_Car_List;temp_list]; % ��֮ǰ�Ľ���ϲ�
end
Dump_Car_List = unique(Dump_Car_List); % Ϊ��ֹ�쳣����ȥ��

end

