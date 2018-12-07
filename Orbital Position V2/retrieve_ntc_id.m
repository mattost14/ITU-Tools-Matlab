function [notified_ntw,coord_ntw] = retrieve_ntc_id(conn)

%% 
%Accessing table com_el 
tablename = 'com_el';
%selectquery = ['SELECT ntc_id,sat_name,long_nom,f_active FROM ' tablename ' WHERE ' 'sat_name=' satName];
selectquery = ['SELECT ntc_id,adm,sat_name,long_nom,ntf_rsn,d_rcv,ntc_type FROM ' tablename];
curs = exec(conn,selectquery);
curs = fetch(curs);
com_el_data = curs.Data;


%Filter for only geo sats using ntc_type = 'G'
%com_el_data = com_el_data(~isnan(cell2mat(com_el_data(:,4))),:);
com_el_data = com_el_data(strcmp(com_el_data(:,7),'G'),:);
%Filter for only notified ntws
notified_ntw = com_el_data(strcmp(com_el_data(:,5),'N'),:);
unique_ntw = unique(notified_ntw(:,3));
notified_ntw_filtered=[];
for r=1:length(unique_ntw)
    data = notified_ntw(strcmp(notified_ntw(:,3),unique_ntw{r}),:);
    dateofntc = datenum(data(:,6));
    [value, idx]=max(dateofntc);
    ntc_id = data{idx,1};
    notified_ntw_filtered = [notified_ntw_filtered;notified_ntw(cell2mat(notified_ntw(:,1))==ntc_id,:)];
end
notified_ntw=notified_ntw_filtered;
%Filter for only coord ntws
coord_ntw = com_el_data(strcmp(com_el_data(:,5),'C'),:);
%Filter for only api ntws
api_ntw = com_el_data(strcmp(com_el_data(:,5),'A'),:);

coord_ntw_filtered = coord_ntw; today=datetime('today');
for i=1:length(coord_ntw(:,1))
    sat_name = coord_ntw(i,3);
    ntc_id = coord_ntw{i,1};

    %check if there is a notification register
    check = notified_ntw(strcmp(notified_ntw(:,3),sat_name),:);
    if(isempty(check))
        adm = coord_ntw(i,2);
        %check if api rcv data for 7 years deadline
        %apicheck = api_ntw(cell2mat(api_ntw(:,1))==ntc_id,:);
        apicheck = api_ntw(strcmp(api_ntw(:,3),sat_name),:);
        apicheck = apicheck(strcmp(apicheck(:,2),adm),:);
        if(~isempty(apicheck))
            API_d_rcv = apicheck{1,6};
            daysleft = datenum(API_d_rcv)+7*365-datenum(today);
            if(daysleft<0)
                %delete register in coordination
                coord_ntw_filtered(cell2mat(coord_ntw_filtered(:,1))==ntc_id,:)=[];
            end
        end
    else
        %delete register in coordination
        coord_ntw_filtered(cell2mat(coord_ntw_filtered(:,1))==ntc_id,:)=[];
    end
end
coord_ntw = coord_ntw_filtered;
end