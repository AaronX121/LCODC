function [Weight] = Calculate_Data_Packet_Weight(Buffer, Current_Time_Slice)

k = 1000;
% Ԥ�����ڴ�
Weight = zeros(size(Buffer,1),1);

% �������ݰ�Ȩֵ�Ĺ�ʽ����Ըղ��������ݰ���ȨֵΪ���޴󣬼�һ��������ڴ��У�
Weight(:,1) = (1 ./ Buffer(:,3)) + k * (1./ (Current_Time_Slice - Buffer(:,4)));

% Weight = rand(size(Buffer,1),1);

end

