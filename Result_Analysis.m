function Result_Analysis(Overall_Uploaded_Packet)
Time_Delay = Overall_Uploaded_Packet(:,6) - Overall_Uploaded_Packet(:,4);
Average_Time_Delay = sum(Time_Delay) / size(Time_Delay,1);
Average_Time_Delay = Average_Time_Delay / 60;

Car_List = unique(Overall_Uploaded_Packet(:,5));

Grid = unique(Overall_Uploaded_Packet(:,1:2),'rows');

fprintf('1.���ռ�����%d�����ݰ�\n',size(Overall_Uploaded_Packet,1));
fprintf('2,���ݰ���ƽ���ӳ�Ϊ%fСʱ\n',Average_Time_Delay);
fprintf('3.��������%d����ͬ�����豸���ɼ������ݰ�\n',size(Car_List,1));
fprintf('4.��������%d����ͬ��������ݰ�\n',size(Grid,1));


end

