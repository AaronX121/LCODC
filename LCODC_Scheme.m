% load('Filtered_Dataset.mat')
% load('�����豸Ȩ��.mat')
% load('Statistical_Matrix.mat')
% load('Centroids.mat')

% 1.ʵ���������
Car_Number = size(new_Dataset,1); % �����豸������8826
Car_Capacity = 200; % ÿ�������豸�ܹ��洢�����ݰ���������
Overflow_Count = 0; % ���ڼ�¼��ĳһʱ��Ƭ�ڴ�����������豸����
Car_In_Data_Center = 0; % ���ڼ�¼���������Ľ��շ�Χ�ڵ������豸����
Number_of_Grids_With_Packet_Exchange = 0; %���ڼ�¼�������ݽ������������

% 2.����Ԥ����
Car_Total_Point_Number = zeros(Car_Number,1); % �洢ÿ���ƶ��ڵ�Ĺ켣����Ŀ
Time_Slice = zeros(); % ��ǰʱ��Ƭ
Internal_Memory = zeros(Car_Capacity,4,Car_Number); % ģ��ÿ�������豸�ڴ�ľ���
Current_Memory_Index = zeros(Car_Number,1); % �洢ÿ�������豸�ڴ����Ѵ洢�����ݰ�����
Overall_Uploaded_Packet = []; % ���ڴ洢�����ύ�����ݰ���Ϣ
Summary_Matrix = [];

% 3.����Ԥ����
% Car_Total_Point_Number������T-Drive���ݼ��й���9957680���켣����Ϣ��
for i = 1 : Car_Number
    Car_Total_Point_Number(i,1) = size(new_Dataset{i,1}.Location,1);
end

% 4.ʵ������
% ʵ����ʱ��Ϊ���ձ�׼������ǰ�ƽ�

for Time_Slice = 1 : max(Car_Total_Point_Number)
    
    tic;
    
    %---------------------%                                          (���)
    %-�����豸λ��ȷ��ģ��-% 
    %---------------------%
    % <<˵��>>
    %     ��ģ�������ҳ��ڵ�ǰʱ��Ƭ��Ȼ�й켣��¼�������豸�б�(Current_Car_List)��
    % ���Ÿ��ݾ�γ��λ�ü�����������ڵ�����ţ�����ڱ���Current_Car_Grid_Index�С�
    
    % �ҳ��ڵ�ǰʱ��Ƭ��Ȼ�м�¼���ƶ��ڵ��б�
    Current_Car_List = find(Car_Total_Point_Number >= Time_Slice);
    
    % ��ȡ�м�¼���ƶ��ڵ�ľ�γ�ȣ�����ڱ���Current_Car_Location��
    Current_Car_Location = zeros(size(Current_Car_List,1),2); % Ԥ�����ڴ�
    for i = 1 : size(Current_Car_List,1)
        Current_Car_Location(i,:) = new_Dataset{Current_Car_List(i,1),1}.Location(Time_Slice,:);
    end
    
    % ����ÿ���ƶ��ڵ������x,y�ţ�����ڱ���Current_Car_Grid_Index��
    Current_Car_Grid_Index = zeros(size(Current_Car_List,1),2); % Ԥ�����ڴ�
    [Current_Car_Grid_Index(:,1),Current_Car_Grid_Index(:,2)] = GridIndex_Calculate(Current_Car_Location);
    
    %----------------------%                                         (���)
    %-�����豸�ɼ����ݰ�ģ��-%
    %----------------------%
    % <<˵��>>
    %     ��ģ��ģ�����ݰ��Ĳ������ռ����̡����ɵ����ݰ������һ��ȫ�ֱ���Internal_Memory�С�ÿ�����ݰ�����Ϣ
    % �����������������ţ�������ĳ������������ݰ��Ĳɼ�ʱ�䡣
    
    % ģ���ƶ��ڵ��ڸ������вɼ����ݰ�����һ�����У�x,y����ţ������У����ݰ���Ӧ�����Ȩֵ�������У����ݰ��ɼ�ʱ�䣩
    Collected_Packet = zeros(size(Current_Car_List,1),4); % Ԥ�����ڴ�
    
    Collected_Packet(:,1) = Current_Car_Grid_Index(:,1);
    Collected_Packet(:,2) = Current_Car_Grid_Index(:,2);
    % ���Ȩֵ                                                      [���Ż�]
    for i = 1 : size(Current_Car_List,1)
        % matlab�����ȡ��1��ʼ
        if(Current_Car_Grid_Index(i,1) == 0)
            Current_Car_Grid_Index(i,1) = 1;
        end
        if(Current_Car_Grid_Index(i,2) == 0)
            Current_Car_Grid_Index(i,2) = 1;
        end
        
       Collected_Packet(i,3) =  Statistical_Matrix(Current_Car_Grid_Index(i,1),Current_Car_Grid_Index(i,2));
    end
    Collected_Packet(:,4) = ones(size(Current_Car_List,1),1) * Time_Slice; % ��¼���ݰ�����ʱ��
    
    %---------------------%                                          (���)
    %-�����豸�ڴ����ģ��-%
    %---------------------%
    % <<˵��>>
    %     ��ģ�����ڸ���ÿ�������豸�ڴ��е����ݡ�����ģ�����ڴ�δ�������²��������ݰ�
    % ��ӵ��ڴ��ĩβ������ڴ�������������ڴ����������ݰ����²������ݰ���Ȩ�ز��Ӵ�
    % С����ȡȨֵ����ǰ��������
    
    % �ж�ÿ�������豸�ڴ��Ƿ������������ڴ�洢����
    for i = 1 : size(Current_Car_List,1)
        
        % �ڴ�δ�����ͨ������Current_Memory_Indexʵ�֣�
        if(Current_Memory_Index(Current_Car_List(i,1),1) < Car_Capacity)
            Current_Memory_Index(Current_Car_List(i,1),1) = Current_Memory_Index(Current_Car_List(i,1),1) + 1; % ���ݰ�����+1
            Internal_Memory(Current_Memory_Index(Current_Car_List(i,1),1),:,Current_Car_List(i,1)) = Collected_Packet(i,:); % ����ǰ�����豸�ɼ������ݰ������ڴ���
        
        % �ڴ����
        else
            Overflow_Count = Overflow_Count + 1;
            Buffer = [squeeze(Internal_Memory(:,:,Current_Car_List(i,1)));Collected_Packet(i,:)]; % ����ǰ�ɼ������ݰ���֮ǰ���е����ݰ����뻺����
            Data_Weight = Calculate_Data_Packet_Weight(Buffer, Time_Slice); % �������ݰ�Ȩֵ
            [~,L] = sort(Data_Weight,'descend'); % ��Ȩֵ�Ӵ�С����
            Internal_Memory(:,:,Current_Car_List(i,1)) = Buffer(L(1:Car_Capacity),:); % ȡȨֵ����Car_Capacity�����ݰ�����������豸���ڴ��У��������������ݰ�
        end
    end
    
    %------------------------%                                       (���)
    %-�����������ύ���ݰ�ģ��-%
    %------------------------%
    % <<˵��>>
    %     ��ģ������ģ�������豸�����������ύ���ݰ��Ĺ��̡����ȸ�ģ���ҳ����д����������Ľ��շ�Χ��
    % �����豸��ţ�����ȡ����Щ�����豸�ڴ��е��������ϵ���ʱ����temp_Uploaded_Packet�С��ڴ˹���
    % ��ͬʱ��Ϊÿ�����ݰ����������豸�����Ϣ����󣬽���ʱ����temp_Uploaded_Packetѹ���ύ������
    % ���ĺ�̨��Ӧ�ı���Overall_Uploaded_Packet��������������󣬶������ύ���ݰ����������ĵ�����
    % �豸�����ڴ���ա�
    
    % �Դ����������Ľ��շ�Χ�ڵ������豸�����ϴ����ݵ��������Ĳ�����������ڴ��д洢������
    [temp_Dump_Car_List] = Find_Devices_In_Centroids(Current_Car_Grid_Index,centroids);
    Car_In_Data_Center = Car_In_Data_Center + size(temp_Dump_Car_List,1);
    Dump_Car_List = Current_Car_List(temp_Dump_Car_List(:,1)); % Dump_Car_List�洢����Ҫ���������ķ������ݴ���������豸���
    temp_Uploaded_Packet = []; % Ԥ�����ڴ�
    
    % ��������Ҫ��������ݰ�������ڱ���Uploaded_Packet��
    for i = 1 : size(Dump_Car_List,1)
        temp_Uploaded_Packet = [temp_Uploaded_Packet;[squeeze(Internal_Memory(:,:,Dump_Car_List(i,1))),ones(size(Internal_Memory(:,:,Dump_Car_List(i,1)),1),1)*Dump_Car_List(i,1)]];
    end
    % ȥ�����п��ڴ��Լ��ٴ洢����
    temp_index = find(sum(temp_Uploaded_Packet(:,1),2) > 0);
    Uploaded_Packet = temp_Uploaded_Packet(temp_index,:);
    % ���ϵ�ǰʱ���Ӧ��ʱ��Ƭ��Ϣ
    Uploaded_Packet(:,6) = ones(size(Uploaded_Packet,1),1)*Time_Slice;
    % �ύ���ݰ�
    Overall_Uploaded_Packet = [Overall_Uploaded_Packet;Uploaded_Packet];
    % ��������豸���ڴ�
    for i = 1 : size(Dump_Car_List,1)
        Internal_Memory(:,:,Dump_Car_List(i,1)) = 0;
    end
    
    %---------------------%                                          (���)
    %-�����豸���ݽ���ģ��-%
    %---------------------%
    %  <<˵��>>
    %    ��ģ�������ҳ�ͬ����һ�������е������豸���ϡ�Ȼ����Ըü����е�ÿ�������豸�Ƚ���
    % ��ü�����ʣ������������豸��Ȩ����Ϣ������LCODC���Ծ����Ƿ�Ҫ�㲥�����ڴ��е����ݰ���
    % �������������豸��˵����������ݰ��������Ͻ��յ������ݰ��������ܺ���ȻС�ڵ����ڴ�������
    % ��򵥵ؽ����յ������ݰ������ڴ��С�����ܺʹ������ڴ�����������Ҫ����ÿ�����ݰ���Ȩ�ء�
    % ȡȨ������ǰ����������������ڴ��С�
    
    % �ҳ����д���ͬһ�������е������豸��ţ�����������Ԫ��������
    [Transmission_Car_List] = Find_Grid_With_Transmissions(Current_Car_Grid_Index,centroids);
    Number_of_Grids_With_Packet_Exchange = size(Transmission_Car_List,1);
    for i = 1 : size(Transmission_Car_List,1)
        fake_Current_Car_In_Same_Grid = Transmission_Car_List{i,1};
        Current_Car_In_Same_Grid = Current_Car_List(fake_Current_Car_In_Same_Grid,1); % ����Current_Car_In_Same_Grid�洢�Ŵ���ͬһ����������豸���
        Current_Device_Weight = Device_Weight(Current_Car_In_Same_Grid,1); % ��ȡ�����豸��Ȩ����Ϣ�����ܳ���Ȩ��Ϊ0�������豸��
        
        for j = 1 : size(Current_Car_In_Same_Grid,1)
            temp_Current_Car_In_Same_Grid = Current_Car_In_Same_Grid;
            temp_Current_Device_Weight = Current_Device_Weight;
            Current_Car_Weight = temp_Current_Device_Weight(j,1);
            
            temp_Current_Device_Weight(j,:) = []; % ȥ����ǰ�����豸��Ȩ���Ի�ȡͬ���������������豸��Ȩ��
            temp_Current_Car_In_Same_Grid(j,:) = []; % ȥ����ǰ�����豸����Ի�ȡͬ���������������豸�ı��
            
            % �����ǰ�����豸Ȩ��С��ʣ�������豸Ȩ�ص����ֵ����1�ĸ��ʹ㲥���ݰ�
            if(Current_Car_Weight < max(temp_Current_Device_Weight))
                temp_Transmitted_Packet = squeeze(Internal_Memory(:,:,Current_Car_In_Same_Grid(j,1)));
                temp_Transmitted_Packet = temp_Transmitted_Packet(find(temp_Transmitted_Packet(:,1) > 0),:);
                
                % ����ͬ�����ڵ����������豸��Ҫ�������ݰ�
                for k = 1 : size(temp_Current_Car_In_Same_Grid,1)
                    Packet_Buffer = squeeze(Internal_Memory(:,:,temp_Current_Car_In_Same_Grid(k,1)));
                    Packet_Buffer = Packet_Buffer(find(Packet_Buffer(:,1) > 0),:);
                    Packet_Buffer = [Packet_Buffer;temp_Transmitted_Packet]; % ���������豸ԭ�����ݰ��ͽ��յ������ݰ��ϲ�
                    % ����������ݰ���������Ȼ�ܴ�����ڴ��У���򵥵ؽ��д�Ų���
                    if(size(Packet_Buffer,1) <= Car_Capacity)
                        Internal_Memory(1:size(Packet_Buffer,1),:,temp_Current_Car_In_Same_Grid(k,1)) = Packet_Buffer;
                    % ����������ݰ���������ʹ�ڴ����������Ҫ�������ݰ���Ȩ��
                    else
                        Packet_Weight = Calculate_Data_Packet_Weight(Packet_Buffer,Time_Slice); % �����������ݰ����½������ݰ���Ȩ��
                        [~,L] = sort(Packet_Weight,'descend'); % ��Ȩֵ�Ӵ�С����
                        Internal_Memory(:,:,temp_Current_Car_In_Same_Grid(k,1)) = Packet_Buffer(L(1:Car_Capacity),:); % ���µ�ǰ�����豸�ڴ�
                    end
                end
                
            % �����ǰ�����豸Ȩ�ش���ʣ�������豸Ȩ�ص����ֵ����ʽ(4)��ʾ���ʹ㲥���ݰ�
            else
                possibility = max(temp_Current_Device_Weight) / Current_Car_Weight; % ����㲥���ݰ��ĸ���
                dice = rand();
                % ���ݸ��ʼ�������Ҫ�㲥���ݰ�������ͬ��
                if(dice <= possibility)
                    temp_Transmitted_Packet = squeeze(Internal_Memory(:,:,Current_Car_In_Same_Grid(j,1)));
                    temp_Transmitted_Packet = temp_Transmitted_Packet(find(temp_Transmitted_Packet(:,1) > 0),:);
                
                    % ����ͬ�����ڵ����������豸��Ҫ�������ݰ�
                    for k = 1 : size(temp_Current_Car_In_Same_Grid,1)
                        Packet_Buffer = squeeze(Internal_Memory(:,:,temp_Current_Car_In_Same_Grid(k,1)));
                        Packet_Buffer = Packet_Buffer(find(Packet_Buffer(:,1) > 0),:);
                        Packet_Buffer = [Packet_Buffer;temp_Transmitted_Packet]; % ���������豸ԭ�����ݰ��ͽ��յ������ݰ��ϲ�
                        % ����������ݰ���������Ȼ�ܴ�����ڴ��У���򵥵ؽ��д�Ų���
                        if(size(Packet_Buffer,1) <= Car_Capacity)
                            Internal_Memory(1:size(Packet_Buffer,1),:,temp_Current_Car_In_Same_Grid(k,1)) = Packet_Buffer;
                        % ����������ݰ���������ʹ�ڴ����������Ҫ�������ݰ���Ȩ��
                        else
                            Packet_Weight = Calculate_Data_Packet_Weight(Packet_Buffer,Time_Slice); % �����������ݰ����½������ݰ���Ȩ��
                            [~,L] = sort(Packet_Weight,'descend'); % ��Ȩֵ�Ӵ�С����
                            Internal_Memory(:,:,temp_Current_Car_In_Same_Grid(k,1)) = Packet_Buffer(L(1:Car_Capacity),:); % ���µ�ǰ�����豸�ڴ�
                        end
                    end
                end
                % ���򲻹㲥���ݰ�
            end
        end
    end
    
    %---------------------%                                          (���)
    %-ʵʱģ����Ϣ���ģ��-%
    %---------------------%
    
    % ���ĳ��ʱ��Ƭ��ģ����Ϣ
    fprintf('��%d��ʱ��Ƭ��\n',Time_Slice);
    fprintf('1.����%d�������豸�����ڴ����.\n',Overflow_Count);
    fprintf('2.����%d�������豸�����������ύ���ݰ�.\n',Car_In_Data_Center);
    fprintf('3.����%d�������������豸������ݽ���.\n',Number_of_Grids_With_Packet_Exchange);
    fprintf('4.��ǰ�������Ĺ����յ�%d�����ݰ�.\n',size(Overall_Uploaded_Packet,1));
    % ����ģ����Ϣ
    Summary_Matrix(Time_Slice,1) = Overflow_Count;
    Summary_Matrix(Time_Slice,2) = Car_In_Data_Center;
    Summary_Matrix(Time_Slice,3) = Number_of_Grids_With_Packet_Exchange;
    Summary_Matrix(Time_Slice,4) = size(Overall_Uploaded_Packet,1);
    toc;
    fprintf('\n');
    
    % ����ͳ�Ƶı�������
    Overflow_Count = 0; 
    Car_In_Data_Center = 0;
    Number_of_Grids_With_Packet_Exchange = 0;
end

